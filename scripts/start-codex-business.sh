#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export CODEX_HOME="$HOME/.codex-business"
export CODEX_BRIDGE_WORKER_ID="C1"
export CODEX_BRIDGE_WORKER_NAME="tbhrc Login"
python3 "$ROOT/tools/aosctl.py" activate-worker C1 --codex-home "$CODEX_HOME"
cd "$ROOT"
exec codex "$@"
