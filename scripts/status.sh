#!/usr/bin/env bash
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== David Login =="
CODEX_HOME="$HOME/.codex" codex login status || true

echo
echo "== tbhrc Login =="
CODEX_HOME="$HOME/.codex-business" codex login status || true

echo
echo "== Codex bridge active worker =="
cat "$ROOT/runtime/active_worker.json"
