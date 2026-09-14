$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$BusinessHome = Join-Path $HOME ".codex-business"
$C2Home = Join-Path $HOME ".codex"

New-Item -ItemType Directory -Force -Path $BusinessHome | Out-Null
if (-not (Test-Path (Join-Path $BusinessHome "config.toml"))) {
    Copy-Item (Join-Path $Root "config/codex-business.config.toml") (Join-Path $BusinessHome "config.toml")
}

python (Join-Path $Root "tools/aosctl.py") validate --verbose
Write-Host "Bootstrap complete. C1=$BusinessHome; C2 uses default $C2Home."
