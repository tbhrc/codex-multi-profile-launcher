#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export CODEX_HOME="$HOME/.codex-business"
mkdir -p "$CODEX_HOME"
chmod 700 "$CODEX_HOME"
if [ ! -f "$CODEX_HOME/config.toml" ]; then
  cp "$ROOT/config/codex-business.config.toml" "$CODEX_HOME/config.toml"
  chmod 600 "$CODEX_HOME/config.toml"
fi
codex login
codex login status
