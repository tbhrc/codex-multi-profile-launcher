#!/usr/bin/env bash
set -euo pipefail
export CODEX_HOME="$HOME/.codex"
mkdir -p "$CODEX_HOME"
chmod 700 "$CODEX_HOME"
codex login
codex login status
