//
//  LocationEditorView.swift
//  Bonsai World
//
//  Quick Action / Locations module entry for Location create/edit.
//  Uses the same Reference Data Location editor and save path.
//

import SwiftUI

struct LocationEditorView: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(UserProfileStore.self) private var profile
    @Environment(AppState.self) private var appState

    let mode: EditorMode

    @State private var draft: LocationReferenceDraft?

    var body: some View {
        Group {
            if let draft {
                LocationReferenceEditorSheet(draft: draft)
            } else {
                ProgressView()
                    .frame(minWidth: 440, minHeight: 420)
            }
        }
        .task(id: mode.id) {
            loadDraft()
        }
    }

    private func loadDraft() {
        // Prefer the Garden currently being browsed in the Locations map so
        // "New Location" lands where the user is looking, falling back to
        // the default Garden when nothing is being browsed (e.g. Quick Actions).
        let targetGardenID = appState.selectedGardenID ?? profile.defaultGarden?.id
        switch mode {
        case .create:
            draft = manager.blankLocationDraft(gardenID: targetGardenID)
        case .edit(let id):
            draft = manager.locationDraft(for: id)
                ?? manager.blankLocationDraft(gardenID: targetGardenID)
        }
    }
}

#Preview("Create") {
    let store = ReferencePreviewData()
    return LocationEditorView(mode: .create)
        .environment(ReferenceDataManager(store: store))
        .environment(UserProfileStore())
        .environment(AppState())
}
