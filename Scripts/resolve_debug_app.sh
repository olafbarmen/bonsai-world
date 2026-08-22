#!/usr/bin/env bash
# Resolve the Debug (or CONFIGURATION) Bonsai Hub.app from xcodebuild settings.
# Never searches DerivedData with wildcards or alphabetical "first folder" picks.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export DEVELOPER_DIR="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"

PROJECT="${PROJECT:-$ROOT/Bonsai Hub.xcodeproj}"
SCHEME="${SCHEME:-Bonsai Hub}"
CONFIGURATION="${CONFIGURATION:-Debug}"
DESTINATION="${DESTINATION:-platform=macOS}"
PRODUCT_NAME="${PRODUCT_NAME:-Bonsai Hub.app}"

show_settings() {
  if [[ -n "${DERIVED_DATA_PATH:-}" ]]; then
    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration "$CONFIGURATION" \
      -destination "$DESTINATION" \
      -derivedDataPath "$DERIVED_DATA_PATH" \
      -showBuildSettings 2>/dev/null
  else
    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration "$CONFIGURATION" \
      -destination "$DESTINATION" \
      -showBuildSettings 2>/dev/null
  fi
}

settings="$(show_settings)"

# Prefer the application target block; fall back to any BUILT_PRODUCTS_DIR
# that pairs with FULL_PRODUCT_NAME = Bonsai Hub.app.
built_products_dir=""
full_product_name=""
in_app_target=0

while IFS= read -r line; do
  if [[ "$line" == *"Build settings for action"* && "$line" == *"target Bonsai Hub:"* ]]; then
    in_app_target=1
    continue
  fi
  if [[ "$line" == *"Build settings for action"* ]]; then
    in_app_target=0
    continue
  fi

  if [[ "$line" =~ ^[[:space:]]*BUILT_PRODUCTS_DIR[[:space:]]*=[[:space:]]*(.*)$ ]]; then
    candidate_dir="${BASH_REMATCH[1]}"
    if (( in_app_target )); then
      built_products_dir="$candidate_dir"
    elif [[ -z "$built_products_dir" ]]; then
      built_products_dir="$candidate_dir"
    fi
  fi

  if [[ "$line" =~ ^[[:space:]]*FULL_PRODUCT_NAME[[:space:]]*=[[:space:]]*(.*)$ ]]; then
    candidate_name="${BASH_REMATCH[1]}"
    if (( in_app_target )) || [[ "$candidate_name" == "$PRODUCT_NAME" ]]; then
      full_product_name="$candidate_name"
    fi
  fi
done <<< "$settings"

if [[ -z "$built_products_dir" ]]; then
  echo "error: could not resolve BUILT_PRODUCTS_DIR from xcodebuild -showBuildSettings" >&2
  echo "hint: open the project in Xcode once, or run Scripts/build_and_launch.sh" >&2
  exit 1
fi

if [[ -z "$full_product_name" ]]; then
  full_product_name="$PRODUCT_NAME"
fi

app_path="${built_products_dir%/}/$full_product_name"
printf '%s\n' "$app_path"
