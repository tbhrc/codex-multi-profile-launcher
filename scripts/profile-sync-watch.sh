#!/usr/bin/env bash
set -euo pipefail

SOURCE="${CODEX_SYNC_SOURCE:-$HOME/.codex}"
DESTINATION="${CODEX_SYNC_DESTINATION:-$HOME/.codex-business}"
LOCK_DIR="${CODEX_SYNC_LOCK_DIR:-$HOME/.codex-profile-sync-watch.lock}"
RECENT_SECONDS="${CODEX_SYNC_RECENT_SECONDS:-900}"

die() { echo "profile-sync-watch: $*" >&2; exit 1; }
[ -d "$SOURCE" ] || die "source profile not found: $SOURCE"
[ -d "$DESTINATION" ] || die "destination profile not found: $DESTINATION"

if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  echo "profile-sync-watch: another run is active; skipping"
  exit 0
fi
trap 'rmdir "$LOCK_DIR" 2>/dev/null || true' EXIT

now="$(date +%s)"
changed=0
for root in "$SOURCE" "$DESTINATION"; do
  for item in sessions archived_sessions memories history.jsonl session_index.jsonl; do
    path="$root/$item"
    [ -e "$path" ] || continue
    if [ -d "$path" ]; then
      find "$path" -type f -mmin "-$((RECENT_SECONDS / 60 + 1))" -print -quit 2>/dev/null | grep -q . && changed=1
    else
      modified="$(stat -f %m "$path" 2>/dev/null || echo 0)"
      [ "$modified" -gt 0 ] && [ $((now - modified)) -le "$RECENT_SECONDS" ] && changed=1
    fi
  done
done

if [ "$changed" -eq 0 ]; then
  echo "profile-sync-watch: no recent continuity changes; skipped"
  exit 0
fi

for item in sessions archived_sessions memories; do
  for direction in source-to-destination destination-to-source; do
    if [ "$direction" = source-to-destination ]; then
      from="$SOURCE/$item/"
      to="$DESTINATION/$item/"
    else
      from="$DESTINATION/$item/"
      to="$SOURCE/$item/"
    fi
    [ -d "$from" ] || continue
    mkdir -p "$to"
    rsync -a --update --exclude='auth.json' --exclude='.env' "$from" "$to"
  done
done

for item in history.jsonl session_index.jsonl; do
  [ -f "$SOURCE/$item" ] && [ -f "$DESTINATION/$item" ] || continue
  rsync -a --update "$SOURCE/$item" "$DESTINATION/$item"
  rsync -a --update "$DESTINATION/$item" "$SOURCE/$item"
done

echo "profile-sync-watch: synchronized safe continuity files"
