$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$env:CODEX_HOME = Join-Path $HOME ".codex-business"
$env:CODEX_BRIDGE_WORKER_ID = "C1"
$env:CODEX_BRIDGE_WORKER_NAME = "Codex Business"
python (Join-Path $Root "tools/aosctl.py") activate-worker C1 --codex-home $env:CODEX_HOME
Set-Location $Root
codex @args
