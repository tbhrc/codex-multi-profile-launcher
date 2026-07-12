$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$env:CODEX_HOME = Join-Path $HOME ".codex-business"
New-Item -ItemType Directory -Force -Path $env:CODEX_HOME | Out-Null
if (-not (Test-Path (Join-Path $env:CODEX_HOME "config.toml"))) {
    Copy-Item (Join-Path $Root "config/codex-business.config.toml") (Join-Path $env:CODEX_HOME "config.toml")
}
codex login
codex login status
