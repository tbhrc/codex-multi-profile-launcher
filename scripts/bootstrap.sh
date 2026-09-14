#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUSINESS_HOME="$HOME/.codex-business"
C2_HOME="$HOME/.codex"

mkdir -p "$BUSINESS_HOME"
chmod 700 "$BUSINESS_HOME"

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
echo "C1 Business home: $BUSINESS_HOME"
echo "C2 uses the normal/default Codex home: $C2_HOME"
echo "No separate C2 home is created."
