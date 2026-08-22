#!/usr/bin/env bash
# Build Bonsai Hub with xcodebuild, then launch that exact build product.
# Build settings and launch path always come from the same xcodebuild invocation args.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"

PROJECT="${PROJECT:-$ROOT/Bonsai Hub.xcodeproj}"
SCHEME="${SCHEME:-Bonsai Hub}"
CONFIGURATION="${CONFIGURATION:-Debug}"
DESTINATION="${DESTINATION:-platform=macOS}"

echo "Building $SCHEME ($CONFIGURATION)…"
if [[ -n "${DERIVED_DATA_PATH:-}" ]]; then
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "$DESTINATION" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build
else
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "$DESTINATION" \
    build
fi

exec "$ROOT/Scripts/launch_debug_app.sh"
