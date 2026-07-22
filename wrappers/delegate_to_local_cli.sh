#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROVIDER="antigravity"
MODEL=""
TASK_FILE=""
WORKDIR="$ROOT"
DRY_RUN=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --provider) PROVIDER="$2"; shift 2 ;;
    --model) MODEL="$2"; shift 2 ;;
    --task-file) TASK_FILE="$2"; shift 2 ;;
    --workdir) WORKDIR="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

if [ -z "$TASK_FILE" ]; then
  echo "Usage: $0 --task-file PATH [--provider antigravity|claude] [--model MODEL] [--workdir PATH] [--dry-run]" >&2
  exit 2
fi

export CODEX_HOME="$HOME/.codex"
export CODEX_BRIDGE_WORKER_ID="C2"
export CODEX_BRIDGE_WORKER_NAME="David Login"

case "$PROVIDER" in
  antigravity)
    COMMAND="agy"
    MODEL="${MODEL:-gemini-3.1-pro-high}"
    ARGS=(-p "$(<"$TASK_FILE")" --model "$MODEL" --dangerously-skip-permissions --print-timeout 45m)
    ;;
  claude)
    COMMAND="claude"
    MODEL="${MODEL:-claude-sonnet-4-6}"
    ARGS=(-p "$(<"$TASK_FILE")" --model "$MODEL" --permission-mode acceptEdits)
    ;;
  *)
    echo "Unsupported provider: $PROVIDER (allowed: antigravity, claude)" >&2
    exit 2
    ;;
esac

if [ ! -f "$TASK_FILE" ] || [ ! -d "$WORKDIR" ]; then
  echo "Task file or work directory is unavailable" >&2
  exit 2
fi
if ! command -v "$COMMAND" >/dev/null 2>&1; then
  echo "C2 dispatch blocked: $COMMAND is unavailable; no fallback is permitted." >&2
  exit 3
fi

if [ "$DRY_RUN" = true ]; then
  printf 'READY: profile=C2 provider=%s command=%s model=%s workdir=%s\n' "$PROVIDER" "$COMMAND" "$MODEL" "$WORKDIR"
  exit 0
fi

cd "$WORKDIR"
exec "$COMMAND" "${ARGS[@]}"
