#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="/Applications/ChatGPT.app"
BIN="$APP/Contents/MacOS/ChatGPT"
CODEX_HOME_DIR="$HOME/.codex-david"
USER_DATA_DIR="$HOME/Library/Application Support/Codex-C2-David"

if [ ! -x "$BIN" ]; then
  osascript -e 'display alert "Codex C2 David" message "Could not find /Applications/ChatGPT.app. Install or move ChatGPT.app there, then try again."'
  exit 1
fi

mkdir -p "$CODEX_HOME_DIR" "$USER_DATA_DIR"
chmod 700 "$CODEX_HOME_DIR"

if [ ! -f "$CODEX_HOME_DIR/config.toml" ]; then
  cp "$ROOT/config/codex-david.config.toml" "$CODEX_HOME_DIR/config.toml"
  chmod 600 "$CODEX_HOME_DIR/config.toml"
fi

export CODEX_HOME="$CODEX_HOME_DIR"
export CODEX_BRIDGE_WORKER_ID="C2"
export CODEX_BRIDGE_WORKER_NAME="Codex David"

python3 "$ROOT/tools/aosctl.py" activate-worker C2 --codex-home "$CODEX_HOME_DIR" >/dev/null

exec "$BIN" --user-data-dir="$USER_DATA_DIR" "$@"
