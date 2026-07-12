#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== Codex David =="
CODEX_HOME="$HOME/.codex-david" codex login status || true

echo
echo "== Codex Business =="
CODEX_HOME="$HOME/.codex-business" codex login status || true

echo
echo "== Codex bridge active worker =="
cat "$ROOT/runtime/active_worker.json"
