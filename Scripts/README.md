# Development scripts

Helpers for **building and launching** Bonsai World during development. These are not part of the application.

## Launch (required)

**Never** locate the app with DerivedData wildcards or alphabetical `head -1` picks:

```bash
# FORBIDDEN — can open an obsolete Debug build
ls -d ~/Library/Developer/Xcode/DerivedData/Bonsai_Hub-*/Build/Products/Debug/"Bonsai Hub.app" | head -1
open "$(…)"
```

**Always** resolve via `xcodebuild -showBuildSettings` (same project/scheme/configuration as the build):

| Script | Purpose |
|--------|---------|
| `Scripts/resolve_debug_app.sh` | Print the absolute path of the active `Bonsai Hub.app` |
| `Scripts/launch_debug_app.sh` | Quit running Bonsai Hub, open the active build product |
| `Scripts/build_and_launch.sh` | `xcodebuild` then `launch_debug_app.sh` |
| `Scripts/purge_stale_bonsai_derived_data.sh` | List/delete other `Bonsai_Hub-*` DerivedData folders |

### Typical use

```bash
# Build + launch the product just compiled
./Scripts/build_and_launch.sh

# Launch whatever the current scheme settings point at (must already be built)
./Scripts/launch_debug_app.sh

# Optional: pin DerivedData (build and resolve must use the same path)
DERIVED_DATA_PATH="/path/to/DerivedData" ./Scripts/build_and_launch.sh

# Remove obsolete DerivedData copies (dry-run, then --yes)
./Scripts/purge_stale_bonsai_derived_data.sh
./Scripts/purge_stale_bonsai_derived_data.sh --yes
```

`DEVELOPER_DIR` defaults to `/Applications/Xcode.app/Contents/Developer`.
