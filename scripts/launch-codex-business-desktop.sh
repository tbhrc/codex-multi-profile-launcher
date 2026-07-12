#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP="/Applications/ChatGPT.app"
BIN="$APP/Contents/MacOS/ChatGPT"
CODEX_HOME_DIR="$HOME/.codex-business"
USER_DATA_DIR="$HOME/Library/Application Support/Codex-C1-Business"

if [ ! -x "$BIN" ]; then
  osascript -e 'display alert "Codex C1 Business" message "Could not find /Applications/ChatGPT.app. Install or move ChatGPT.app there, then try again."'
  exit 1
fi

mkdir -p "$CODEX_HOME_DIR" "$USER_DATA_DIR"
chmod 700 "$CODEX_HOME_DIR"

if [ ! -f "$CODEX_HOME_DIR/config.toml" ]; then
  cp "$ROOT/config/codex-business.config.toml" "$CODEX_HOME_DIR/config.toml"
  chmod 600 "$CODEX_HOME_DIR/config.toml"
fi

export CODEX_HOME="$CODEX_HOME_DIR"
export CODEX_BRIDGE_WORKER_ID="C1"
export CODEX_BRIDGE_WORKER_NAME="Codex Business"

python3 "$ROOT/tools/aosctl.py" activate-worker C1 --codex-home "$CODEX_HOME_DIR" >/dev/null

exec "$BIN" --user-data-dir="$USER_DATA_DIR" "$@"
