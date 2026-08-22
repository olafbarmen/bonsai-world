#!/usr/bin/env bash
# Remove obsolete Bonsai_Hub-* DerivedData folders that are not the active build product.
# Prevents Launch Services / Dock / accidental open from resurfacing July-era shells.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORCE=0
if [[ "${1:-}" == "--yes" ]]; then
  FORCE=1
fi

APP="$("$ROOT/Scripts/resolve_debug_app.sh")"
# …/DerivedData/Bonsai_Hub-<hash>/Build/Products/Debug/Bonsai Hub.app
active_dd="$(cd "$(dirname "$APP")/../../.." && pwd)"

echo "Active DerivedData (kept): $active_dd"
echo

shopt -s nullglob
stale=()
for dir in "$HOME/Library/Developer/Xcode/DerivedData"/Bonsai_Hub-*; do
  [[ -d "$dir" ]] || continue
  if [[ "$dir" == "$active_dd" ]]; then
    continue
  fi
  stale+=("$dir")
done

if ((${#stale[@]} == 0)); then
  echo "No stale Bonsai_Hub DerivedData folders found."
  exit 0
fi

echo "Stale DerivedData folders:"
for dir in "${stale[@]}"; do
  echo "  $dir"
done
echo

if (( FORCE == 0 )); then
  echo "Dry run. Re-run with --yes to delete the folders listed above."
  exit 0
fi

for dir in "${stale[@]}"; do
  echo "Removing $dir"
  rm -rf "$dir"
done
echo "Done."
