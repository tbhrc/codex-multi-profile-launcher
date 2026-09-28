#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="/Applications/ChatGPT.app"
BIN="$APP/Contents/MacOS/ChatGPT"
CODEX_HOME_DIR="$HOME/.codex-business"
USER_DATA_DIR="$HOME/Library/Application Support/Codex-C1-Business"

c1_lock_pid() {
  local lock_target=""
  [[ -L "$USER_DATA_DIR/SingletonLock" ]] || return 1
  lock_target="$(readlink "$USER_DATA_DIR/SingletonLock" 2>/dev/null || true)"
  local lock_pid="${lock_target##*-}"
  [[ "$lock_pid" =~ ^[0-9]+$ ]] || return 1
  printf '%s\n' "$lock_pid"
}

c1_pid_is_live() {
  local lock_pid="$1"
  local command=""
  kill -0 "$lock_pid" 2>/dev/null || return 1
  command="$(ps -p "$lock_pid" -o command= 2>/dev/null || true)"
  [[ "$command" == *"$BIN --user-data-dir=$USER_DATA_DIR"* ]]
}

reopen_existing_c1() {
  local lock_pid=""
  lock_pid="$(c1_lock_pid)" || return 1
  c1_pid_is_live "$lock_pid" || return 1

  # The detached runtime does not receive the wrapper's Dock reopen event.
  if ! /usr/bin/osascript - "$lock_pid" <<'APPLESCRIPT'
on run argv
  set target_pid to (item 1 of argv) as integer
  tell application "System Events"
    tell first application process whose unix id is target_pid
      set frontmost to true
      if (count of windows) is 0 then
        keystroke "n" using command down
      end if
    end tell
  end tell
end run
APPLESCRIPT
  then
    /usr/bin/osascript -e 'display alert "Codex C1 Business" message "C1 is running but its window could not be reopened. Check macOS Automation permissions for the C1 launcher."' || true
  fi
  # Never start a second singleton client while the exact C1 owner is alive.
  return 0
}

cleanup_dead_c1_singleton() {
  local lock_pid=""
  local socket_target=""
  local singleton_name=""
  [[ -L "$USER_DATA_DIR/SingletonLock" ]] || return 0
  lock_pid="$(c1_lock_pid)" || return 0
  c1_pid_is_live "$lock_pid" && return 0

  socket_target="$(readlink "$USER_DATA_DIR/SingletonSocket" 2>/dev/null || true)"
  for singleton_name in SingletonCookie SingletonLock SingletonSocket; do
    if [[ -L "$USER_DATA_DIR/$singleton_name" ]]; then
      /bin/unlink "$USER_DATA_DIR/$singleton_name"
    fi
  done
  case "$socket_target" in
    /var/folders/*/T/com.openai.codex.*/SingletonSocket)
      [[ ! -S "$socket_target" ]] || /bin/unlink "$socket_target"
      ;;
  esac
}

if [ ! -x "$BIN" ]; then
  osascript -e 'display alert "Codex C1 Business" message "Could not find /Applications/ChatGPT.app. Install or move ChatGPT.app there, then try again."'
  exit 1
fi

mkdir -p "$CODEX_HOME_DIR" "$USER_DATA_DIR"
chmod 700 "$CODEX_HOME_DIR"

if reopen_existing_c1; then
  exit 0
fi
cleanup_dead_c1_singleton

if [ ! -f "$CODEX_HOME_DIR/config.toml" ]; then
  cp "$ROOT/config/codex-business.config.toml" "$CODEX_HOME_DIR/config.toml"
  chmod 600 "$CODEX_HOME_DIR/config.toml"
fi

export CODEX_HOME="$CODEX_HOME_DIR"
export CODEX_BRIDGE_WORKER_ID="C1"
export CODEX_BRIDGE_WORKER_NAME="Codex Business"
export __CFBundleIdentifier="com.folderdesk.codex.c1-business.runtime"

python3 "$ROOT/tools/aosctl.py" activate-worker C1 --codex-home "$CODEX_HOME_DIR" >/dev/null

# Do not replace the launcher process with the shared signed ChatGPT
# executable: that path previously caused C1/C2 macOS scene collisions.
nohup "$BIN" --user-data-dir="$USER_DATA_DIR" "$@" >/dev/null 2>&1 &
