//
//  CollectionsView.swift
//  Bonsai World
//
//  Collections module master list — sectioned Smart / My Collections.
//  Member counts resolve against the global Tree repository via TreeService.
//

import SwiftUI

struct CollectionsView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService

    private var smartCollections: [Collection] {
        treeService.smartCollections
    }

    private var manualCollections: [Collection] {
        treeService.manualCollections
    }

    private var hasAnyCollection: Bool {
        !smartCollections.isEmpty || !manualCollections.isEmpty
    }

    var body: some View {
        @Bindable var appState = appState

        Group {
            if !hasAnyCollection {
                FeaturedEmptyState(
                    title: "No Collections yet",
                    systemImage: "square.stack.3d.up",
                    description: "Use Quick Actions → New Collection to create a group for favorites, species studies, or an exhibition."
                )
                .background(.windowBackground)
            } else {
                CollectionsList(
                    smartCollections: smartCollections,
                    manualCollections: manualCollections,
                    selection: $appState.selectedCollectionID,
                    treeCount: { treeService.treeCount(inCollection: $0.id) }
                )
            }
        }
        .navigationTitle("Collections")
        .navigationSplitViewColumnWidth(min: 220, ideal: 300)
        .onAppear {
            scheduleDefaultSelection()
        }
        .onChange(of: appState.selectedSection) { _, section in
            if section == .gardenCollections {
                scheduleDefaultSelection()
            }
        }
        .onChange(of: treeService.collections.map(\.id)) { _, _ in
            scheduleDefaultSelection()
        }
        .onChange(of: appState.selectedCollectionID) { _, newValue in
            // Defer cascading selection updates off the List selection update cycle.
            Task { @MainActor in
                appState.selectedTreeID = nil
                if let newValue {
                    appState.lastOpenedCollectionID = newValue
                }
            }
        }
    }

    /// Prefers the first Smart Collection; otherwise last opened; otherwise first Manual.
    private func scheduleDefaultSelection() {
        Task { @MainActor in
            ensureDefaultSelection()
        }
    }

    private func ensureDefaultSelection() {
        let ids = Set(treeService.collections.map(\.id))
        if let selected = appState.selectedCollectionID, ids.contains(selected) {
            return
        }
        let next = treeService.defaultCollectionID(
            lastOpened: appState.lastOpenedCollectionID
        )
        guard appState.selectedCollectionID != next else { return }
        appState.selectedCollectionID = next
    }
}

#Preview {
    let preview = PreviewData()
    return CollectionsView()
        .environment(AppState())
        .environment(TreeService.preview(previewData: preview))
}
