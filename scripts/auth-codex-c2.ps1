$ErrorActionPreference = "Stop"
$env:CODEX_HOME = Join-Path $HOME ".codex"
New-Item -ItemType Directory -Force -Path $env:CODEX_HOME | Out-Null
codex login
codex login status
