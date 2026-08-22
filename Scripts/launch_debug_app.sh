#!/usr/bin/env bash
# Launch the Bonsai Hub.app that belongs to the active xcodebuild product.
# Does not glob DerivedData; does not pick "first folder alphabetically".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=resolve_debug_app.sh
APP="$("$ROOT/Scripts/resolve_debug_app.sh")"

if [[ ! -d "$APP" ]]; then
  echo "error: build product missing:" >&2
  echo "  $APP" >&2
  echo "hint: run Scripts/build_and_launch.sh to compile, then launch." >&2
  exit 1
fi

# Quit any running Bonsai Hub so a stale instance cannot stay frontmost.
osascript -e 'tell application "System Events" to (name of processes) contains "Bonsai Hub"' 2>/dev/null | grep -q true \
  && osascript -e 'tell application "Bonsai Hub" to quit' 2>/dev/null || true

# Brief pause so quit can complete before reopen.
sleep 0.5

echo "Launching: $APP"
open "$APP"
