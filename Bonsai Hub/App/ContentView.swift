//
//  ContentView.swift
//  Bonsai World
//
//  Architecture Version 3 — routes existing features and placeholders.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService
    @Environment(ImageService.self) private var imageService
    @Environment(PotService.self) private var potService
    @Environment(YamadoriService.self) private var yamadoriService

    /// Dashboard uses a two-column shell (sidebar + workspace).
    private var isDashboardSelected: Bool {
        appState.selectedSection == .dashboard
    }

    /// Media → Images — sidebar + grid + inspector (Image Workspace windows omit the inspector).
    private var isMediaImagesSelected: Bool {
        appState.selectedSection == .mediaImages
    }

    /// Trees in the Library uses sidebar + list/detail split (Tree Overview).
    /// Shaping uses the same shell — Tree Detail Shaping segment.
    private var isTreesSectionSelected: Bool {
        appState.selectedSection == .gardenTrees || appState.selectedSection == .shaping
    }

    /// Nursery → Yamadori uses sidebar + full-width workspace (Trees-style).
    private var isYamadoriSectionSelected: Bool {
        appState.selectedSection == .nurseryYamadori
    }

    /// Tasks horizons — sidebar + full-width workspace (no detail column).
    private var isTasksSectionSelected: Bool {
        switch appState.selectedSection {
        case .tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear:
            true
        default:
            false
        }
    }

    /// Knowledge → Bonsai Handbook — sidebar + full-width reading view.
    private var isKnowledgeHandbookSelected: Bool {
        appState.selectedSection == .knowledgeHandbook
    }

    /// Knowledge → Fertilizer Guides — sidebar + full-width reading view.
    private var isKnowledgeFertilizerGuidesSelected: Bool {
        appState.selectedSection == .knowledgeFertilizerGuides
    }

    /// Knowledge → Seed Stratification — sidebar + full-width reading view.
    private var isKnowledgeSeedStratificationSelected: Bool {
        appState.selectedSection == .knowledgeSeedStratification
    }

    /// Knowledge → Species Library — sidebar + inset list/detail workspace (Trees-style chrome).
    private var isKnowledgeSpeciesLibrarySelected: Bool {
        appState.selectedSection == .knowledgeSpeciesLibrary
    }

    /// Nursery → Seeds — sidebar + full-width Seeds workspace.
    private var isNurserySeedsSelected: Bool {
        appState.selectedSection == .nurserySeeds
    }

    private var isNurseryCuttingsSelected: Bool {
        appState.selectedSection == .nurseryCuttings
    }

    private var isNurseryAirLayersSelected: Bool {
        appState.selectedSection == .nurseryAirLayers
    }

    private var isNurseryGraftingSelected: Bool {
        appState.selectedSection == .nurseryGrafting
    }

    private var isNurseryFieldTreeSelected: Bool {
        appState.selectedSection == .nurseryFieldTree
    }

    /// Care module — one sidebar row; page picker on CareWorkspaceView (BV1).
    private var isCareSectionSelected: Bool {
        appState.selectedSection?.module == .care
    }

    private var isLocationsGardensSelected: Bool {
        appState.selectedSection == .locationsGardens
    }

    private var selectedMediaLibraryKind: MediaLibraryKind? {
        switch appState.selectedSection {
        case .mediaDocuments: .document
        case .mediaVideo: .video
        case .mediaNotes: .note
        case .mediaAudio: .audio
        default: nil
        }
    }

    private var selectedKnowledgeResourceKind: KnowledgeResourceKind? {
        switch appState.selectedSection {
        case .knowledgeQuickGuides: .quickGuide
        case .knowledgeFAQ: .faq
        case .knowledgeCourses: .course
        case .knowledgeVideos: .videoTutorial
        case .knowledgeExternalLinks: .externalLink
        default: nil
        }
    }

    private var selectedSimpleCatalogKind: SimpleCatalogKind? {
        SimpleCatalogKind.allCases.first { $0.route == appState.selectedSection }
    }

    private var isSocialSharedTreesSelected: Bool {
        appState.selectedSection == .socialSharedTrees
    }

    var body: some View {
        @Bindable var appState = appState

        // One persistent NavigationSplitView for the whole app. Recreating it per
        // section (or swapping two- vs three-column shells) leaves a stale toolbar
        // tracking separator after visiting Pots / Collections / Settings / etc.
        NavigationSplitView {
            SidebarView()
        } detail: {
            splitDetail { twoColumnWorkspace }
        }
        .bonsaiWorldChrome()
        .sheet(item: $appState.locationEditor) { mode in
            LocationEditorView(mode: mode)
        }
        .sheet(item: $appState.collectionEditor) { _ in
            CollectionEditorView()
        }
        .sheet(item: $appState.treeEditor) { _ in
            NewTreeView()
                .environment(appState)
                .environment(appSettings)
                .environment(treeService)
                .environment(referenceData)
        }
        .sheet(item: $appState.potEditor) { _ in
            NewPotView()
                .environment(appState)
                .environment(appSettings)
                .environment(potService)
                .environment(referenceData)
        }
        .sheet(item: $appState.soilStockEditor) { _ in
            AddSoilStockView()
        }
        .sheet(item: $appState.inventoryStockEditorKind) { kind in
            AddInventoryStockView(kind: kind)
        }
        .sheet(isPresented: $appState.isSoilStocktakePresented) {
            SoilStocktakeView()
        }
        .sheet(item: $appState.yamadoriEditor) { _ in
            NewYamadoriView()
                .environment(appState)
                .environment(yamadoriService)
                .environment(referenceData)
        }
        .sheet(isPresented: $appState.isCopyExistingTreePresented) {
            CopyExistingTreeSheet()
                .environment(appState)
                .environment(treeService)
                .environment(referenceData)
        }
        .sheet(isPresented: $appState.isSearchPresented) {
            SearchSheet()
                .environment(appState)
                .environment(treeService)
                .environment(referenceData)
                .environment(taskService)
                .environment(imageService)
        }
        .onChange(of: appState.selectedSection) { _, newValue in
            // Sidebar already wrote `selectedSection`. Defer dependent clears so we
            // do not mutate AppState during the List selection view update.
            Task { @MainActor in
                appState.handleSelectedSectionChange(newValue)
            }
        }
    }

    /// Detail destination inside the persistent two-column `NavigationSplitView`.
    @ViewBuilder
    private var twoColumnWorkspace: some View {
        if isDashboardSelected {
            DashboardView()
        } else if isMediaImagesSelected {
            mediaImagesContent
        } else if isTreesSectionSelected {
            treesContent
        } else if isYamadoriSectionSelected {
            yamadoriContent
        } else if isTasksSectionSelected {
            tasksContent
        } else if isKnowledgeHandbookSelected {
            BonsaiHandbookView()
        } else if isKnowledgeFertilizerGuidesSelected {
            FertilizerGuidesView()
        } else if isKnowledgeSeedStratificationSelected {
            SeedStratificationView()
        } else if isKnowledgeSpeciesLibrarySelected {
            speciesLibraryContent
        } else if isNurserySeedsSelected {
            SeedWorkspaceView(
                selectedTab: Binding(
                    get: { appState.selectedSeedWorkspaceTab },
                    set: { appState.selectedSeedWorkspaceTab = $0 }
                )
            )
        } else if isNurseryCuttingsSelected {
            NurseryPropagationWorkspaceView(kind: .cutting)
        } else if isNurseryAirLayersSelected {
            NurseryPropagationWorkspaceView(kind: .airLayer)
        } else if isNurseryGraftingSelected {
            // Grafting removed from Nursery — AppState redirects to Tasks.
            Color.clear
                .onAppear { appState.selectSection(.tasksToday) }
        } else if isNurseryFieldTreeSelected {
            NurseryPropagationWorkspaceView(kind: .fieldTree)
        } else if appState.selectedSection == .inventoryStockReport {
            StockReportView()
        } else if isCareSectionSelected {
            careContent
        } else if isLocationsGardensSelected {
            GardensWorkspaceView()
        } else if let mediaKind = selectedMediaLibraryKind {
            MediaLibraryWorkspaceView(kind: mediaKind)
        } else if let knowledgeKind = selectedKnowledgeResourceKind {
            KnowledgeResourceWorkspaceView(kind: knowledgeKind)
        } else if let catalogKind = selectedSimpleCatalogKind {
            SimpleCatalogWorkspaceView(kind: catalogKind)
        } else if isSocialSharedTreesSelected {
            SocialSharedTreesWorkspaceView()
        } else {
            masterDetailWorkspace
        }
    }

    /// Former three-column modules (Pots, Collections, Settings, …) as list + detail
    /// inside the same two-column shell — no second `NavigationSplitView` teardown.
    @ViewBuilder
    private var masterDetailWorkspace: some View {
        HSplitView {
            contentColumn
                .frame(minWidth: 220, idealWidth: 320, maxWidth: 520)
            detailColumn
                .frame(minWidth: 400)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BonsaiWorldColors.canvas)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Library: Images browse. Image Workspace: one image fills the content area.
    @ViewBuilder
    private var mediaImagesContent: some View {
        if let imageID = appState.imageWorkspaceImageID {
            ImageWorkspaceView(imageID: imageID)
        } else {
            GalleryView()
        }
    }

    /// Same air beside the sidebar and at the trailing edge as Dashboard (``DashboardSpacing/pageInset``).
    /// Marks the environment so ``FaloAdaptiveDesktopWorkspace`` does not double-pad horizontally.
    ///
    /// Inset is applied *inside* a full-bleed column fill. Padding the column root itself
    /// shifts macOS’s sidebar tracking separator away from the green edge (gap then line).
    /// Plain padding (not leading ``safeAreaInset``) — inset overlays were clipping Tables.
    private func splitDetail<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack(alignment: .topLeading) {
            BonsaiWorldColors.canvas
            content()
                .padding(.horizontal, DashboardSpacing.pageInset)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.faloShellProvidesLeadingInset, true)
    }

    /// Species Library list + profile in one inset workspace — avoids the three-column title separator.
    @ViewBuilder
    private var speciesLibraryContent: some View {
        HSplitView {
            SpeciesLibraryView()
                .frame(minWidth: 280, idealWidth: 360, maxWidth: 480)
            SpeciesProfileDetailView()
                .frame(minWidth: 400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .bonsaiWorkspaceNavigationTitle("Species Library")
    }

    /// Library: list + embedded Overview. Tree Workspace: one Tree fills the content area.
    @ViewBuilder
    private var treesContent: some View {
        if let treeID = appState.treeWorkspaceTreeID {
            TreeDetailView(mode: .edit(treeID))
        } else {
            TreeWorkspaceView()
        }
    }

    /// Library: tabs + list/detail. Trip/Find Workspace: one record fills the content area.
    @ViewBuilder
    private var yamadoriContent: some View {
        if appState.yamadoriWorkspaceTripID != nil {
            YamadoriDetailView()
        } else if appState.yamadoriWorkspaceFindID != nil {
            YamadoriFindDetailView()
        } else {
            YamadoriWorkspaceView()
        }
    }

    /// Tasks — one sidebar destination; horizon picker is on the page (BJ1).
    @ViewBuilder
    private var tasksContent: some View {
        TasksWorkspaceView()
    }

    /// Care — one sidebar destination; page picker is on the page (BV1).
    @ViewBuilder
    private var careContent: some View {
        CareWorkspaceView()
    }

    @ViewBuilder
    private var contentColumn: some View {
        switch appState.selectedSection {
        case .dashboard:
            // Unreachable while `isDashboardSelected` uses the two-column shell.
            EmptyView()

        case .tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear:
            // Unreachable while `isTasksSectionSelected` uses the two-column shell.
            EmptyView()

        case .gardenTrees:
            // Unreachable while `isTreesSectionSelected` uses the Trees shell.
            EmptyView()
        case .gardenCollections:
            CollectionsView()
        case .mediaImages:
            // Unreachable while `isMediaImagesSelected` uses the two-column shell.
            EmptyView()

        case .mediaDocuments, .mediaNotes, .mediaVideo, .mediaAudio:
            // Unreachable while media catalog routes use the two-column shell.
            EmptyView()

        case .locationsGardens:
            // Unreachable while Gardens uses the two-column shell.
            EmptyView()
        case .locationsPlaces, .locationsMap:
            LocationsListView()

        case .workshopWork:
            WorkBrowserView()
        case .workshopCalendar, .workshopTasks:
            // Unreachable while Workshop catalog routes use the two-column shell.
            EmptyView()

        case .nurserySeeds:
            // Unreachable while `isNurserySeedsSelected` uses the two-column shell.
            EmptyView()
        case .nurseryCuttings, .nurseryAirLayers, .nurseryGrafting, .nurseryFieldTree:
            // Unreachable while nursery propagation routes use the two-column shell.
            EmptyView()
        case .nurseryYamadori:
            // Unreachable while `isYamadoriSectionSelected` uses the two-column shell.
            EmptyView()

        case .careToday, .careWatering, .careFertilizing, .careRepotting, .carePlacement,
             .careTreeHealth, .careSeasonal, .careWinter, .careSpring:
            // Unreachable while `isCareSectionSelected` uses CareWorkspaceView.
            EmptyView()
        case .designVision,
             .designStyle, .designFrontSelection, .designVirtual,
             .designBranchPlan, .designTrunkDevelopment, .designRamification,
             .designApex, .designDeadwood, .designTimeline, .shaping:
            // Unreachable — Shaping uses the Trees shell; legacy design routes are not in navigation.
            EmptyView()

        case .inventoryPots:
            PotListView()
        case .inventorySoil, .inventorySoilComponents, .inventorySoilMixes:
            SoilWorkspaceView(
                selectedTab: Binding(
                    get: { appState.selectedSoilWorkspaceTab },
                    set: { appState.selectedSoilWorkspaceTab = $0 }
                )
            )
        case .inventoryFertilizers, .inventoryWire, .inventoryTools, .inventoryChemicals, .inventoryConsumables:
            if let kind = InventoryStockKind.kind(for: appState.selectedSection ?? .inventoryFertilizers) {
                InventoryStockListView(kind: kind)
            }
        case .inventoryStockReport:
            // Unreachable while Stock Report uses the two-column shell.
            EmptyView()

        case .knowledgeQuickGuides, .knowledgeVideos, .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks:
            // Unreachable while knowledge resource routes use the two-column shell.
            EmptyView()
        case .knowledgeHandbook:
            // Unreachable while `isKnowledgeHandbookSelected` uses the two-column shell.
            EmptyView()
        case .knowledgePotGuidelines:
            // Redirected to Handbook → Pots & Containers in `AppState.handleSelectedSectionChange`.
            EmptyView()
        case .knowledgeSpeciesLibrary:
            // Unreachable while `isKnowledgeSpeciesLibrarySelected` uses the two-column shell.
            EmptyView()
        case .knowledgeSoilGuides:
            // Redirected to Handbook → Soil & Substrate in `AppState.handleSelectedSectionChange`.
            EmptyView()
        case .knowledgeFertilizerGuides:
            // Unreachable while `isKnowledgeFertilizerGuidesSelected` uses the two-column shell.
            EmptyView()
        case .knowledgeSeedStratification:
            // Unreachable while `isKnowledgeSeedStratificationSelected` uses the two-column shell.
            EmptyView()

        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports:
            // Unreachable while Economy catalog routes use the two-column shell.
            EmptyView()

        case .socialContacts, .socialLinks:
            // Unreachable while Social catalog routes use the two-column shell.
            EmptyView()
        case .socialSharedTrees:
            // Unreachable while Shared Trees uses the two-column shell.
            EmptyView()

        case .settings:
            SettingsView()

        case .none:
            ContentUnavailableView(
                "Select a Section",
                systemImage: "sidebar.left",
                description: Text("Choose an item in the sidebar.")
            )
        }
    }

    @ViewBuilder
    private var detailColumn: some View {
        switch appState.selectedSection {
        case .dashboard:
            EmptyView()
        case .gardenTrees:
            EmptyView()
        case .locationsPlaces, .locationsMap:
            LocationDetailView()
        case .gardenCollections:
            if let treeID = appState.selectedTreeID {
                TreeDetailView(mode: .edit(treeID), showsCollectionBackButton: true)
            } else {
                CollectionDetailView()
            }
        case .workshopWork:
            WorkTypeDetailView()
        case .inventoryPots:
            PotDetailView()
        case .inventorySoil, .inventorySoilComponents, .inventorySoilMixes:
            switch appState.selectedSoilWorkspaceTab {
            case .stock:
                SoilStockDetailView()
            case .mixes:
                SoilMixDetailView()
            }
        case .inventoryFertilizers, .inventoryWire, .inventoryTools, .inventoryChemicals, .inventoryConsumables:
            if let kind = InventoryStockKind.kind(for: appState.selectedSection ?? .inventoryFertilizers) {
                InventoryStockDetailView(kind: kind)
            }
        case .nurseryYamadori:
            EmptyView()
        case .knowledgeSpeciesLibrary:
            EmptyView()
        case .settings:
            settingsDetail
        default:
            ContentUnavailableView(
                "Detail",
                systemImage: "rectangle.split.2x1",
                description: Text("Select an item to see its details.")
            )
        }
    }

    @ViewBuilder
    private var settingsDetail: some View {
        switch appState.selectedSettingsPane {
        case .gettingStarted:
            GettingStartedView()
        case .userProfile:
            UserProfileView()
        case .regionalSettings:
            RegionalSettingsView()
        case .referenceData:
            ReferenceDataManagerView()
        case .potBrandsAndMakers:
            PotBrandsAndMakersView()
        case .appearance:
            AppearanceSettingsView()
        case .experience:
            ExperienceEditionSettingsView()
        case .notifications:
            NotificationsSettingsView()
        case .social:
            SocialSettingsView()
        case .libraryManagement:
            LibraryManagementView()
        case .seedStratificationKnowledge:
            SeedStratificationSettingsView()
        case .none:
            ContentUnavailableView(
                "Settings",
                systemImage: "gearshape",
                description: Text("Choose a settings pane.")
            )
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
        .environment(AppSettings())
        .environment(TreeListColumnConfiguration(visibleColumnIDs: TreeListColumnID.defaultOrder))
        .environment(PreviewData())
}
