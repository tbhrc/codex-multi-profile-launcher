#!/usr/bin/env bash
set -euo pipefail

LABEL="com.david.codex-c1-remote-control"
AGENT_DIR="$HOME/Library/LaunchAgents"
PLIST="$AGENT_DIR/$LABEL.plist"
C1_HOME="$HOME/.codex-business"
CODEX_CLI="$(command -v codex || true)"
DOMAIN="gui/$(id -u)"

if [[ -z "$CODEX_CLI" || ! -x "$CODEX_CLI" ]]; then
  echo "Codex CLI is unavailable; cannot install $LABEL" >&2
  exit 1
fi
if [[ ! -d "$C1_HOME" ]]; then
  echo "C1 home is unavailable: $C1_HOME" >&2
  exit 1
fi

mkdir -p "$AGENT_DIR"
cat > "$PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key><array>
    <string>$CODEX_CLI</string>
    <string>remote-control</string>
    <string>start</string>
    <string>--json</string>
  </array>
  <key>EnvironmentVariables</key><dict>
    <key>CODEX_HOME</key><string>$C1_HOME</string>
    <key>PATH</key><string>$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>RunAtLoad</key><true/>
  <key>StartInterval</key><integer>300</integer>
  <key>StandardOutPath</key><string>/dev/null</string>
  <key>StandardErrorPath</key><string>/dev/null</string>
</dict></plist>
PLIST
chmod 600 "$PLIST"
plutil -lint "$PLIST" >/dev/null

if launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1; then
  launchctl bootout "$DOMAIN/$LABEL"
fi
launchctl bootstrap "$DOMAIN" "$PLIST"
echo "Installed $LABEL for C1 at login, with a five-minute restart check."
