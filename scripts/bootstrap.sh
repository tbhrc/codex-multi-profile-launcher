#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DAVID_HOME="$HOME/.codex-david"
BUSINESS_HOME="$HOME/.codex-business"

mkdir -p "$DAVID_HOME" "$BUSINESS_HOME"
chmod 700 "$DAVID_HOME" "$BUSINESS_HOME"

if [ ! -f "$DAVID_HOME/config.toml" ]; then
  cp "$ROOT/config/codex-david.config.toml" "$DAVID_HOME/config.toml"
  chmod 600 "$DAVID_HOME/config.toml"
fi

if [ ! -f "$BUSINESS_HOME/config.toml" ]; then
  cp "$ROOT/config/codex-business.config.toml" "$BUSINESS_HOME/config.toml"
  chmod 600 "$BUSINESS_HOME/config.toml"
fi

chmod 700 "$ROOT"/scripts/*.sh "$ROOT"/wrappers/*.sh

for dir in runtime/outputs runtime/logs runtime/tmp runtime/worktrees; do
  mkdir -p "$ROOT/$dir"
done

python3 "$ROOT/tools/aosctl.py" validate --verbose

echo
echo "Bootstrap complete."
echo "Project root: $ROOT"
echo "Codex David home: $DAVID_HOME"
echo "Codex Business home: $BUSINESS_HOME"
echo "Next: bash $ROOT/scripts/auth-codex-david.sh"
