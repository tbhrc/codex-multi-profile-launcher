#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export CODEX_HOME="$HOME/.codex-david"
export CODEX_BRIDGE_WORKER_ID="C2"
export CODEX_BRIDGE_WORKER_NAME="Codex David"
python3 "$ROOT/tools/aosctl.py" activate-worker C2 --codex-home "$CODEX_HOME"
cd "$ROOT"
exec codex "$@"
