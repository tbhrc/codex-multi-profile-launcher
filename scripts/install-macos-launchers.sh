#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHATGPT_APP="${CHATGPT_APP:-/Applications/ChatGPT.app}"
APP_BIN="$CHATGPT_APP/Contents/MacOS/ChatGPT"
APPS_DIR="${APPS_DIR:-$HOME/Applications}"
C1_APP_NAME="${C1_APP_NAME:-Codex C1 Business}"
C1_BUNDLE_ID="${C1_BUNDLE_ID:-com.codex-multi-profile-launcher.c1-business}"

if [ ! -x "$APP_BIN" ]; then
  echo "Could not find the ChatGPT/Codex desktop app at: $CHATGPT_APP" >&2
  exit 1
fi
for tool in qlmanage sips iconutil; do
  command -v "$tool" >/dev/null 2>&1 || { echo "Missing required macOS tool: $tool" >&2; exit 1; }
done
mkdir -p "$APPS_DIR"
APP_DIR="$APPS_DIR/$C1_APP_NAME.app"
mkdir -p "$APP_DIR/Contents/MacOS" "$APP_DIR/Contents/Resources"
cat > "$APP_DIR/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleDisplayName</key><string>$C1_APP_NAME</string>
<key>CFBundleExecutable</key><string>launcher</string>
<key>CFBundleIdentifier</key><string>$C1_BUNDLE_ID</string>
<key>CFBundleIconFile</key><string>codex</string>
<key>CFBundleName</key><string>$C1_APP_NAME</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>CFBundleVersion</key><string>1</string>
<key>LSMinimumSystemVersion</key><string>12.0</string>
</dict></plist>
PLIST
cat > "$APP_DIR/Contents/MacOS/launcher" <<SH
#!/usr/bin/env bash
exec "$ROOT/scripts/launch-codex-business-desktop.sh" "\$@"
SH
chmod 755 "$APP_DIR/Contents/MacOS/launcher"
SVG="/tmp/codex-c1-icon.svg"
cat > "$SVG" <<SVGEOF
<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
<rect x="36" y="28" width="952" height="952" rx="220" fill="#1058a6"/>
<text x="196" y="700" font-family="Arial Black, Arial" font-size="560" font-weight="900" fill="#fff">C</text>
<rect x="610" y="560" width="292" height="292" rx="92" fill="#f8fbff"/>
<text x="670" y="795" font-family="Arial Black, Arial" font-size="260" font-weight="900" fill="#0a3c78">1</text>
</svg>
SVGEOF
qlmanage -t -s 1024 -o /tmp "$SVG" >/dev/null 2>&1
PNG="$SVG.png"; ICONSET="$APP_DIR/Contents/Resources/codex.iconset"; mkdir -p "$ICONSET"
sips -z 16 16 "$PNG" --out "$ICONSET/icon_16x16.png" >/dev/null
sips -z 32 32 "$PNG" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$PNG" --out "$ICONSET/icon_32x32.png" >/dev/null
sips -z 64 64 "$PNG" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$PNG" --out "$ICONSET/icon_128x128.png" >/dev/null
sips -z 256 256 "$PNG" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$PNG" --out "$ICONSET/icon_256x256.png" >/dev/null
sips -z 512 512 "$PNG" --out "$ICONSET/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$PNG" --out "$ICONSET/icon_512x512.png" >/dev/null
cp "$PNG" "$ICONSET/icon_512x512@2x.png"
iconutil -c icns "$ICONSET" -o "$APP_DIR/Contents/Resources/codex.icns"
rm -rf "$ICONSET"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_DIR" >/dev/null 2>&1 || true
echo "Installed C1 launcher: $APP_DIR"
echo "C2 is the normal/default ChatGPT/Codex app using ~/.codex and ~/Library/Application Support/Codex."
