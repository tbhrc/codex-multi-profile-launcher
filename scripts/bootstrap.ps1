$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$DavidHome = Join-Path $HOME ".codex"
$BusinessHome = Join-Path $HOME ".codex-business"

New-Item -ItemType Directory -Force -Path $DavidHome, $BusinessHome | Out-Null

if (-not (Test-Path (Join-Path $DavidHome "config.toml"))) {
    Copy-Item (Join-Path $Root "config/codex-david.config.toml") (Join-Path $DavidHome "config.toml")
}
if (-not (Test-Path (Join-Path $BusinessHome "config.toml"))) {
    Copy-Item (Join-Path $Root "config/codex-business.config.toml") (Join-Path $BusinessHome "config.toml")
}

python (Join-Path $Root "tools/aosctl.py") validate --verbose
Write-Host "Bootstrap complete. Next: .\\scripts\\auth-.codex.ps1"
