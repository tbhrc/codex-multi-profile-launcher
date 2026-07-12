$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$env:CODEX_HOME = Join-Path $HOME ".codex"
$env:CODEX_BRIDGE_WORKER_ID = "C2"
$env:CODEX_BRIDGE_WORKER_NAME = "David Login"
python (Join-Path $Root "tools/aosctl.py") activate-worker C2 --codex-home $env:CODEX_HOME
Set-Location $Root
codex @args
