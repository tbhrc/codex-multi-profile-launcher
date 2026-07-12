#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  profile-sync.sh backup --to DESTINATION [--backup-dir DIRECTORY]
  profile-sync.sh merge --from SOURCE --to DESTINATION [--backup-dir DIRECTORY]
  profile-sync.sh verify --profile PROFILE

This utility transfers local Codex continuity data between isolated profiles.
It never copies auth.json, browser session state, OAuth stores, or config.toml.
Named desktop project containers are not portable; local folders and chat history are.
EOF
}

die() { echo "profile-sync: $*" >&2; exit 1; }

require_dir() { [ -d "$1" ] || die "directory not found: $1"; }

timestamp() { date '+%Y%m%d-%H%M%S'; }

backup_profile() {
  local destination="$1"
  local backup_dir="$2"
  require_dir "$destination"
  mkdir -p "$backup_dir"
  local target="$backup_dir/$(basename "$destination")-$(timestamp)"
  mkdir -p "$target"

  for item in sessions archived_sessions memories sqlite ambient-suggestions automations shell_snapshots; do
    [ -e "$destination/$item" ] && rsync -a "$destination/$item" "$target/"
  done
  for item in history.jsonl session_index.jsonl memories_1.sqlite goals_1.sqlite state_5.sqlite .codex-global-state.json; do
    [ -e "$destination/$item" ] && cp -p "$destination/$item" "$target/"
  done
  echo "Backup created: $target"
}

merge_profile() {
  local source="$1"
  local destination="$2"
  local backup_dir="$3"
  require_dir "$source"
  require_dir "$destination"
  backup_profile "$destination" "$backup_dir"

  for item in sessions archived_sessions memories sqlite ambient-suggestions automations shell_snapshots; do
    [ -d "$source/$item" ] || continue
    mkdir -p "$destination/$item"
    rsync -a --exclude='auth.json' --exclude='.env' "$source/$item/" "$destination/$item/"
  done
  for item in history.jsonl session_index.jsonl memories_1.sqlite goals_1.sqlite state_5.sqlite; do
    [ -f "$source/$item" ] && cp -p "$source/$item" "$destination/$item"
  done

  # Merge only sidebar expansion state. Preserve destination account/profile state.
  if command -v jq >/dev/null && [ -f "$source/.codex-global-state.json" ] && [ -f "$destination/.codex-global-state.json" ]; then
    local temp
    temp="$(mktemp "${TMPDIR:-/tmp}/profile-sync.XXXXXX")"
    jq --slurpfile source_state "$source/.codex-global-state.json" '
      . as $root
      | ($root["electron-persisted-atom-state"] // {}) as $destination_state
      | ($source_state[0]["electron-persisted-atom-state"] // {}) as $source_state_values
      | (reduce ($source_state_values | to_entries[] | select(.key | startswith("sidebar-project-expanded-v1-codex:"))) as $item
          ($destination_state; .[$item.key] = $item.value)) as $merged_state
      | $root | .["electron-persisted-atom-state"] = $merged_state
    ' "$destination/.codex-global-state.json" > "$temp"
    jq -e 'type == "object"' "$temp" >/dev/null
    mv "$temp" "$destination/.codex-global-state.json"
  fi

  for item in sessions archived_sessions memories sqlite ambient-suggestions automations shell_snapshots; do
    [ -d "$destination/$item" ] || continue
    find "$destination/$item" -type f \( -name 'auth.json' -o -name '.env' \) -delete 2>/dev/null || true
  done
  echo "Merged local continuity data from $source into $destination."
  echo "Restart the destination desktop profile before checking its sidebar."
  echo "Named desktop project containers may still need to be re-added manually."
}

verify_profile() {
  local profile="$1"
  require_dir "$profile"
  [ -f "$profile/auth.json" ] || die "destination auth.json is missing: $profile"
  [ -f "$profile/config.toml" ] || die "destination config.toml is missing: $profile"
  for item in sessions memories sqlite; do
    [ -e "$profile/$item" ] || die "expected continuity data is missing: $profile/$item"
  done
  if find "$profile/sessions" "$profile/memories" "$profile/sqlite" -type f \( -name 'auth.json' -o -name '.env' \) -print -quit 2>/dev/null | grep -q .; then
    die "credential-like file found in migrated continuity data"
  fi
  echo "Profile verification passed: $profile"
}

command="${1:-}"
[ -n "$command" ] || { usage; exit 2; }
shift
source=""
destination=""
profile=""
backup_dir="${HOME}/.codex-profile-backups"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --from) source="$2"; shift 2 ;;
    --to) destination="$2"; shift 2 ;;
    --profile) profile="$2"; shift 2 ;;
    --backup-dir) backup_dir="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown option: $1" ;;
  esac
done

case "$command" in
  backup) [ -n "$destination" ] || die "backup requires --to"; backup_profile "$destination" "$backup_dir" ;;
  merge) [ -n "$source" ] || die "merge requires --from"; [ -n "$destination" ] || die "merge requires --to"; merge_profile "$source" "$destination" "$backup_dir" ;;
  verify) [ -n "$profile" ] || die "verify requires --profile"; verify_profile "$profile" ;;
  *) usage; exit 2 ;;
esac
