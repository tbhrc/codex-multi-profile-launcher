#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CHATGPT_APP="${CHATGPT_APP:-/Applications/ChatGPT.app}"
APP_BIN="$CHATGPT_APP/Contents/MacOS/ChatGPT"
APPS_DIR="${APPS_DIR:-$HOME/Applications}"

C1_APP_NAME="${C1_APP_NAME:-Codex C1 Business}"
C2_APP_NAME="${C2_APP_NAME:-Codex David Login}"
C1_BUNDLE_ID="${C1_BUNDLE_ID:-com.codex-multi-profile-launcher.c1-business}"
C2_BUNDLE_ID="${C2_BUNDLE_ID:-com.codex-multi-profile-launcher.c2-david}"

if [ ! -x "$APP_BIN" ]; then
  echo "Could not find the ChatGPT/Codex desktop app at: $CHATGPT_APP" >&2
  echo "Set CHATGPT_APP=/path/to/ChatGPT.app and rerun." >&2
  exit 1
fi

for tool in qlmanage sips iconutil; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing required macOS tool: $tool" >&2
    exit 1
  fi
done

mkdir -p "$APPS_DIR"

write_plist() {
  local app_name="$1"
  local bundle_id="$2"
  local app_dir="$APPS_DIR/$app_name.app"
  mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources"
  cat > "$app_dir/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleDisplayName</key>
  <string>$app_name</string>
  <key>CFBundleExecutable</key>
  <string>launcher</string>
  <key>CFBundleIdentifier</key>
  <string>$bundle_id</string>
  <key>CFBundleIconFile</key>
  <string>codex</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>$app_name</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>12.0</string>
</dict>
</plist>
PLIST
}

write_launcher() {
  local app_name="$1"
  local script="$2"
  local app_dir="$APPS_DIR/$app_name.app"
  cat > "$app_dir/Contents/MacOS/launcher" <<SH
#!/usr/bin/env bash
exec "$ROOT/$script" "\$@"
SH
  chmod 755 "$app_dir/Contents/MacOS/launcher"
}

write_svg() {
  local out="$1"
  local number="$2"
  local bg1="$3"
  local bg2="$4"
  local number_color="$5"
  cat > "$out" <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">
  <defs>
    <linearGradient id="g" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="$bg1"/>
      <stop offset="1" stop-color="$bg2"/>
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="24" stdDeviation="22" flood-color="#000" flood-opacity="0.38"/>
    </filter>
  </defs>
  <rect x="36" y="28" width="952" height="952" rx="220" fill="url(#g)" filter="url(#shadow)"/>
  <rect x="48" y="40" width="928" height="928" rx="208" fill="none" stroke="#fff" stroke-opacity="0.28" stroke-width="8"/>
  <path d="M168 202 C326 86 589 80 748 221" fill="none" stroke="#fff" stroke-opacity="0.22" stroke-width="12" stroke-linecap="round"/>
  <text x="210" y="714" font-family="Arial Black, Arial, Helvetica, sans-serif" font-size="560" font-weight="900" fill="#000" opacity="0.22">C</text>
  <text x="196" y="700" font-family="Arial Black, Arial, Helvetica, sans-serif" font-size="560" font-weight="900" fill="#fff">C</text>
  <rect x="610" y="560" width="292" height="292" rx="92" fill="#f8fbff" stroke="#fff" stroke-opacity="0.75" stroke-width="7"/>
  <text x="670" y="795" font-family="Arial Black, Arial, Helvetica, sans-serif" font-size="260" font-weight="900" fill="$number_color">$number</text>
</svg>
SVG
}

build_icon() {
  local app_name="$1"
  local svg="$2"
  local app_dir="$APPS_DIR/$app_name.app"
  local resources="$app_dir/Contents/Resources"
  local iconset="$resources/codex.iconset"
  local png="$svg.png"

  qlmanage -t -s 1024 -o /tmp "$svg" >/dev/null 2>&1
  mkdir -p "$iconset"
  cp "$png" "$resources/codex-custom-icon-1024.png"

  sips -z 16 16 "$png" --out "$iconset/icon_16x16.png" >/dev/null
  sips -z 32 32 "$png" --out "$iconset/icon_16x16@2x.png" >/dev/null
  sips -z 32 32 "$png" --out "$iconset/icon_32x32.png" >/dev/null
  sips -z 64 64 "$png" --out "$iconset/icon_32x32@2x.png" >/dev/null
  sips -z 128 128 "$png" --out "$iconset/icon_128x128.png" >/dev/null
  sips -z 256 256 "$png" --out "$iconset/icon_128x128@2x.png" >/dev/null
  sips -z 256 256 "$png" --out "$iconset/icon_256x256.png" >/dev/null
  sips -z 512 512 "$png" --out "$iconset/icon_256x256@2x.png" >/dev/null
  sips -z 512 512 "$png" --out "$iconset/icon_512x512.png" >/dev/null
  cp "$png" "$iconset/icon_512x512@2x.png"

  iconutil -c icns "$iconset" -o "$resources/codex.icns"
  rm -rf "$iconset"
}

write_plist "$C1_APP_NAME" "$C1_BUNDLE_ID"
write_plist "$C2_APP_NAME" "$C2_BUNDLE_ID"
write_launcher "$C1_APP_NAME" "scripts/launch-codex-business-desktop.sh"
write_launcher "$C2_APP_NAME" "scripts/launch-codex-david-desktop.sh"

C1_SVG="/tmp/codex-c1-icon.svg"
C2_SVG="/tmp/codex-c2-icon.svg"
write_svg "$C1_SVG" "1" "#1058a6" "#0e9688" "#0a3c78"
write_svg "$C2_SVG" "2" "#6237a8" "#d6566a" "#692478"
build_icon "$C1_APP_NAME" "$C1_SVG"
build_icon "$C2_APP_NAME" "$C2_SVG"

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f \
  "$APPS_DIR/$C1_APP_NAME.app" \
  "$APPS_DIR/$C2_APP_NAME.app" >/dev/null 2>&1 || true

echo "Installed:"
echo "  $APPS_DIR/$C1_APP_NAME.app"
echo "  $APPS_DIR/$C2_APP_NAME.app"
echo
echo "Drag both apps to your Dock, then sign into each profile separately."
