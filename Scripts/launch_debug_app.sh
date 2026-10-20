#!/usr/bin/env bash
# Launch the Bonsai Hub.app that belongs to the active xcodebuild product.
# Does not glob DerivedData; does not pick "first folder alphabetically".
#
# Debug and TestFlight share the same bundle id. Prefer launching the .app via
# `open -n` in the console user's Aqua session, then force that PID frontmost.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$("$ROOT/Scripts/resolve_debug_app.sh")"

if [[ ! -d "$APP" ]]; then
  echo "error: build product missing:" >&2
  echo "  $APP" >&2
  echo "hint: run Scripts/build_and_launch.sh to compile, then launch." >&2
  exit 1
fi

EXECUTABLE="$APP/Contents/MacOS/Bonsai Hub"
if [[ ! -e "$EXECUTABLE" ]]; then
  echo "error: missing executable:" >&2
  echo "  $EXECUTABLE" >&2
  exit 1
fi

# Quit every "Bonsai Hub" process (Debug and TestFlight share the name).
pkill -x "Bonsai Hub" 2>/dev/null || true
sleep 0.7

echo "Launching Debug app:"
echo "  $APP"

UID_NUM="$(id -u)"
# Launch in the logged-in user's GUI session (avoids invisible agent-session processes).
if launchctl asuser "$UID_NUM" /usr/bin/open -n "$APP" 2>/dev/null; then
  :
else
  /usr/bin/open -n "$APP"
fi

sleep 1.5
DEBUG_PID="$(pgrep -f "$APP/Contents/MacOS" | head -n 1 || true)"
if [[ -z "${DEBUG_PID}" ]]; then
  echo "error: Debug app did not stay running." >&2
  exit 1
fi

echo "PID $DEBUG_PID — bringing window forward as «Bonsai Hub (Dev)»"
osascript <<EOF
tell application "System Events"
  if exists process "Bonsai Hub" then
    tell process "Bonsai Hub"
      set visible to true
      set frontmost to true
    end tell
  end if
end tell
EOF

echo "OK: look for window / Dock title «Bonsai Hub (Dev)» (not TestFlight)."
