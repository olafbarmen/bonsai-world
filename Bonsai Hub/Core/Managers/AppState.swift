//
//  AppState.swift
//  Bonsai World
//

import Foundation
import Observation

@Observable
@MainActor
final class AppState {
    /// Global sidebar destination (Architecture Version 2 leaf route).
    var selectedSection: AppRoute? = .dashboard

    /// Selected location within the Locations module (master/detail).
    var selectedLocationID: UUID?

    /// Selected collection within the Collections module (master/detail).
    var selectedCollectionID: UUID?

    /// Last Collection the grower opened — survives leaving the Collections route.
    var lastOpenedCollectionID: UUID?

    /// Selected tree for Tree Detail (Collections member drill-in or Trees module).
    var selectedTreeID: UUID?

    /// Selected Work Type within the Workshop / Work route (master/detail foundation).
    var selectedWorkTypeID: UUID?

    /// Tree Detail View / Edit mode — drives Trees context Quick Actions.
    var treeDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// Collection Detail View / Edit mode — drives Collections context Quick Actions.
    var collectionDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// One-shot Quick Action request for the active Tree Detail.
    var pendingTreeQuickAction: TreeQuickActionRequest?

    /// One-shot Quick Action request for the active Collection Detail.
    var pendingCollectionQuickAction: CollectionQuickActionRequest?

    /// Location editor sheet: `nil` when dismissed.
    var locationEditor: EditorMode?

    /// Collection create sheet: `nil` when dismissed.
    var collectionEditor: EditorMode?

    /// Tree create sheet: `nil` when dismissed.
    var treeEditor: EditorMode?

    /// Optional Collections to preselect in New Tree (cleared when the sheet dismisses).
    var newTreePreselectedCollectionIDs: Set<UUID> = []

    /// Collection → Add Tree sheet.
    var isCollectionAddTreePresented = false

    /// Settings content selection (e.g. Reference Data).
    var selectedSettingsPane: SettingsPane?

    /// One-shot Locations map focus (e.g. Tree → Show on Map).
    var pendingLocationMapFocusID: UUID?

    /// Non-nil when this window is a **Tree Workspace** for exactly one Tree.
    /// The content area shows that Tree only — never the Library tree browser.
    /// `nil` in the Library window.
    var treeWorkspaceTreeID: UUID?

    /// Whether this window is a dedicated Tree Workspace (one Tree, not a browser).
    var isTreeWorkspaceWindow: Bool { treeWorkspaceTreeID != nil }

    /// Fresh navigation state for a Tree Workspace window focused on one Tree.
    /// Shares no UI state with other windows — only library services are shared.
    static func makeTreeWorkspace(treeID: UUID) -> AppState {
        let state = AppState()
        state.treeWorkspaceTreeID = treeID
        state.selectedSection = .gardenTrees
        state.selectedTreeID = treeID
        return state
    }

    func selectSection(_ section: AppRoute?) {
        selectedSection = section
        handleSelectedSectionChange(section)
    }

    /// Clears module-local selections after ``selectedSection`` changes.
    ///
    /// Use from sidebar-driven `onChange` via a deferred `Task` so AppState is not
    /// mutated during the same view update that wrote ``selectedSection``.
    func handleSelectedSectionChange(_ section: AppRoute?) {
        clearSelections(except: section)
        if section == .settings, selectedSettingsPane == nil {
            selectedSettingsPane = .userProfile
        }
    }

    /// Opens Locations Map and zooms to the Location pin (Tree inherits map position from Location).
    func showLocationOnMap(locationID: UUID) {
        selectedLocationID = locationID
        pendingLocationMapFocusID = locationID
        selectSection(.locationsMap)
    }

    /// Opens Tree Detail from a Garden map Tree marker.
    func showTreeFromMap(treeID: UUID) {
        selectedTreeID = treeID
        selectSection(.gardenTrees)
    }

    func clearPendingLocationMapFocus() {
        pendingLocationMapFocusID = nil
    }

    func presentNewLocation() {
        selectedSection = .locationsPlaces
        locationEditor = .create
    }

    func presentEditLocation(id: UUID) {
        locationEditor = .edit(id)
    }

    func dismissLocationEditor() {
        locationEditor = nil
    }

    func presentNewCollection() {
        selectedSection = .gardenCollections
        selectedTreeID = nil
        collectionEditor = .create
    }

    func dismissCollectionEditor() {
        collectionEditor = nil
    }

    func presentNewTree(preselectedCollectionIDs: Set<UUID> = []) {
        newTreePreselectedCollectionIDs = preselectedCollectionIDs
        if preselectedCollectionIDs.isEmpty {
            selectedSection = .gardenTrees
            selectedCollectionID = nil
        }
        treeEditor = .create
    }

    /// Opens New Tree with the given Collection already selected (Collection → Create New Tree).
    func presentNewTree(inCollection collectionID: UUID) {
        presentNewTree(preselectedCollectionIDs: [collectionID])
    }

    func dismissTreeEditor() {
        treeEditor = nil
        newTreePreselectedCollectionIDs = []
    }

    /// Opens Add Tree for the currently selected Manual Collection.
    func presentAddTreeToSelectedCollection() {
        guard selectedCollectionID != nil else { return }
        selectedSection = .gardenCollections
        isCollectionAddTreePresented = true
    }

    func dismissCollectionAddTree() {
        isCollectionAddTreePresented = false
    }

    func requestTreeQuickAction(_ command: TreeQuickActionCommand) {
        pendingTreeQuickAction = TreeQuickActionRequest(command: command)
    }

    func clearPendingTreeQuickAction() {
        pendingTreeQuickAction = nil
    }

    func requestCollectionQuickAction(_ command: CollectionQuickActionCommand) {
        pendingCollectionQuickAction = CollectionQuickActionRequest(command: command)
    }

    func clearPendingCollectionQuickAction() {
        pendingCollectionQuickAction = nil
    }

    private func clearSelections(except section: AppRoute?) {
        let module = section?.module

        if module != .locations {
            selectedLocationID = nil
            pendingLocationMapFocusID = nil
        }
        if section != .gardenCollections {
            selectedCollectionID = nil
            collectionDetailInteractionMode = .viewing
            pendingCollectionQuickAction = nil
        }
        // Tree Detail may be shown from Collections (drill-in) or Trees.
        // Changing sidebar section always resets drill-in; Trees can re-select later.
        if section != .gardenTrees {
            selectedTreeID = nil
            treeDetailInteractionMode = .viewing
            pendingTreeQuickAction = nil
        }
        if section != .workshopWork {
            selectedWorkTypeID = nil
        }
        if section == .gardenCollections {
            selectedTreeID = nil
            treeDetailInteractionMode = .viewing
            pendingTreeQuickAction = nil
        }
        if module != .settings {
            selectedSettingsPane = nil
        }

        // Tree Workspace windows always re-focus their single Tree when returning to Trees.
        if section == .gardenTrees, let workspaceTreeID = treeWorkspaceTreeID {
            selectedTreeID = workspaceTreeID
        }
    }
}
