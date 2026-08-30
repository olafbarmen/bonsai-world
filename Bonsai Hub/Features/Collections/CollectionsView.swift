//
//  CollectionsView.swift
//  Bonsai World
//
//  Collections module master list — My Collections / Smart Collections / Former Trees.
//  Member counts resolve against the global Tree repository via TreeService.
//

import SwiftUI

struct CollectionsView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService

    private var smartCollections: [Collection] {
        treeService.smartCollections
    }

    private var formerTreeCollections: [Collection] {
        treeService.formerTreeCollections
    }

    private var manualCollections: [Collection] {
        treeService.manualCollections
    }

    private var hasAnyCollection: Bool {
        !smartCollections.isEmpty || !formerTreeCollections.isEmpty || !manualCollections.isEmpty
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
                    formerTreeCollections: formerTreeCollections,
                    manualCollections: manualCollections,
                    selection: $appState.selectedCollectionID,
                    treeCount: {
                        treeService.treeCount(
                            inCollection: $0.id,
                            disposalMethods: referenceData.disposalMethods,
                            liveMembers: taskService.liveSmartCollectionMembers()
                        )
                    }
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

    /// Prefers last opened; otherwise first My Collection; then Smart; then Former Trees.
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
    let referenceStore = ReferencePreviewData()
    let treeService = TreeService.preview(previewData: preview)
    let referenceData = ReferenceDataService(previewData: referenceStore)
    let workService = WorkService(referenceData: referenceData)
    let taskService = TaskService(
        referenceData: referenceData,
        workService: workService,
        treeService: treeService,
        botanicalService: BotanicalService(store: referenceStore)
    )
    return CollectionsView()
        .environment(AppState())
        .environment(treeService)
        .environment(referenceData)
        .environment(taskService)
}
