# TestFlight (macOS) — Bonsai Hub

Goal: invite testers and push updates without a public Mac App Store listing.

**Bundle ID:** `no.olafbarmen.Bonsai-Hub`  
**Team:** `9WV5826D66`  
**iCloud container (entitlements):** `iCloud.no.olafbarmen.BonsaiWorld`

In-app Sparkle updates are **not** used with TestFlight. TestFlight delivers updates.

---

## What the agent cannot do alone

These require your Apple ID (2FA) in the browser / Xcode:

1. Create the app record in App Store Connect  
2. Create or download **Apple Distribution** + Mac App Store provisioning  
3. Upload the archive (Transporter / Xcode Organizer)  
4. Invite testers and fill “What to Test”

Local machine status when this doc was written: only **Apple Development** identities were installed — Archive for TestFlight will fail until Distribution signing is set up.

---

## One-time setup (you)

### A. App Store Connect

1. Open [App Store Connect](https://appstoreconnect.apple.com) → **My Apps** → **+** → **New App**
2. Platform: **macOS**
3. Name: e.g. `Bonsai World` (display name; can differ from Xcode target)
4. Bundle ID: select / register `no.olafbarmen.Bonsai-Hub`
5. SKU: e.g. `bonsai-hub-mac` (internal; not shown to testers)
6. User Access: Full Access (unless you use roles)

You do **not** need to submit for App Review / sale. TestFlight is enough.

### B. Developer identifiers

1. [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list)
2. App ID `no.olafbarmen.Bonsai-Hub` must have **App Sandbox** and **iCloud** (Documents) enabled
3. iCloud container `iCloud.no.olafbarmen.BonsaiWorld` must exist and be linked to that App ID

### C. Signing in Xcode (first TestFlight archive)

1. Open `Bonsai Hub.xcodeproj`
2. Select target **Bonsai Hub** → **Signing & Capabilities**
3. For **Release** (and Archive):
   - Prefer **Automatically manage signing** with team `9WV5826D66`, **or**
   - Manual: identity **Apple Distribution**, profile **Mac App Store** for this bundle ID
4. Xcode → Settings → Accounts: ensure you are signed in and have downloaded certificates
5. If prompted, allow Xcode to create a **Distribution** certificate

Dev day-to-day can stay on the existing **Bonsai Hub Mac Dev** profile; only Archive/Release for upload needs Distribution.

### D. Version numbers

Before each upload:

| Field | Meaning | Example |
| --- | --- | --- |
| `MARKETING_VERSION` | User-visible version | `0.9.0` or `1.0` |
| `CURRENT_PROJECT_VERSION` | Build number (must increase every upload) | `1`, then `2`, … |

Both are in the **Bonsai Hub** target Build Settings (also in `project.pbxproj`).

---

## Upload a build

1. Scheme: **Bonsai Hub**, destination: **Any Mac** (or My Mac for archive)
2. **Product → Archive**
3. Organizer → **Distribute App** → **App Store Connect** → **Upload**
4. Wait until the build appears under the app → **TestFlight** (processing can take 5–30+ minutes)
5. Add build to a group → fill **What to Test**
6. **Internal testing:** App Store Connect users on the team (fastest)  
   **External testing:** email invites; first build may need short **Beta App Review**

Testers: install **TestFlight** from the Mac App Store → accept invite → Install.

---

## Later updates (during the test round)

1. Bump `CURRENT_PROJECT_VERSION` (required)
2. Archive → Upload again
3. Add the new build to the same TestFlight group  
   Testers get the update in TestFlight — no Sparkle, no data wipe (library lives outside the `.app`)

---

## Smoke checklist before inviting others

- [ ] Fresh install from TestFlight opens
- [ ] Create / open a library package
- [ ] Add a tree + photo
- [ ] iCloud library path works if you expect testers to use it (same Apple ID / container)
- [ ] Known gaps listed in “What to Test” (e.g. Audio stub, Media depth)

---

## Optional: App Store Connect API (for later automation)

To let scripts upload without interactive Xcode:

1. App Store Connect → Users and Access → **Integrations** → App Store Connect API → create a key  
2. Download `AuthKey_XXXX.p8` once; store outside the repo  
3. Then `xcodebuild` + `xcrun notarytool` / Transporter / `fastlane pilot` can be wired in `Scripts/`

Do **not** commit `.p8` keys to git.
