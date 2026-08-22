//
//  ContentView.swift
//  Bonsai World
//
//  Architecture Version 2 — routes existing features and placeholders.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData

    /// Dashboard is the only module that uses a two-column shell (sidebar + workspace).
    private var isDashboardSelected: Bool {
        appState.selectedSection == .dashboard
    }

    /// Trees in the Library uses sidebar + list/detail split (Tree Overview).
    /// A Tree Workspace window uses sidebar + full-area Tree Detail for one Tree.
    private var isTreesSectionSelected: Bool {
        appState.selectedSection == .gardenTrees
    }

    var body: some View {
        @Bindable var appState = appState

        Group {
            if isDashboardSelected {
                // Sidebar + Dashboard only — no Detail column.
                NavigationSplitView {
                    SidebarView()
                } detail: {
                    DashboardView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.windowBackground)
                }
            } else if isTreesSectionSelected {
                NavigationSplitView {
                    SidebarView()
                } detail: {
                    treesContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.windowBackground)
                }
            } else {
                // Original three-column layout for every other module.
                NavigationSplitView {
                    SidebarView()
                } content: {
                    contentColumn
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.windowBackground)
                } detail: {
                    detailColumn
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.windowBackground)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(WorldIdentity.appName)
                    .font(FaloTypography.headline)
            }
        }
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
        .onChange(of: appState.selectedSection) { _, newValue in
            // Sidebar already wrote `selectedSection`. Defer dependent clears so we
            // do not mutate AppState during the List selection view update.
            Task { @MainActor in
                appState.handleSelectedSectionChange(newValue)
            }
        }
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

    @ViewBuilder
    private var contentColumn: some View {
        switch appState.selectedSection {
        case .dashboard:
            // Unreachable while `isDashboardSelected` uses the two-column shell.
            EmptyView()

        case .gardenTrees:
            // Unreachable while `isTreesSectionSelected` uses the Trees shell.
            EmptyView()
        case .gardenCollections:
            CollectionsView()
        case .gardenGallery:
            ModulePlaceholderView(
                title: "Gallery",
                systemImage: "photo.on.rectangle",
                purpose: "Visual memory of the collection — under Garden.",
                items: ["Tree photos", "Timeline images", "Exhibition shots"]
            )

        case .locationsGardens:
            ModulePlaceholderView(
                title: "Gardens",
                systemImage: "house.lodge",
                purpose: "Physical properties where trees grow. Garden definitions remain the framing layer for Locations.",
                items: ["Address framing", "Garden Position", "Climate context"]
            )
        case .locationsPlaces, .locationsMap:
            LocationsListView()

        case .workshopWork:
            WorkBrowserView()
        case .workshopCalendar:
            ModulePlaceholderView(
                title: "Calendar",
                systemImage: "calendar",
                purpose: "Workshop schedule for practical bonsai work.",
                items: ["Work events", "Seasonal windows", "Reminders"]
            )
        case .workshopTasks:
            ModulePlaceholderView(
                title: "Tasks",
                systemImage: "checklist",
                purpose: "Actionable Workshop tasks tied to trees and work types.",
                items: ["Due work", "Batch tasks", "Follow-ups"]
            )

        case .nurserySeeds:
            nurseryPlaceholder("Seeds", "leaf.circle", "Seed sowing and germination tracking.")
        case .nurseryCuttings:
            nurseryPlaceholder("Cuttings", "scissors", "Cutting propagation and rooting.")
        case .nurseryAirLayers:
            nurseryPlaceholder("Air Layers", "arrow.triangle.branch", "Air layer projects and development.")
        case .nurseryGrafting:
            nurseryPlaceholder("Grafting", "arrow.triangle.merge", "Grafting projects and aftercare.")
        case .nurseryYamadori:
            nurseryPlaceholder("Yamadori", "mountain.2", "Collected material and recovery.")
        case .nurseryDevelopment:
            nurseryPlaceholder(
                "Development",
                "chart.line.uptrend.xyaxis",
                "Young tree development formerly under Propagation — trunk building, ramification, refinement."
            )

        case .careToday:
            carePlaceholder("Today", "Daily care overview and recommendations.")
        case .careWatering:
            carePlaceholder("Watering", "Watering guidance from Growing Intelligence.")
        case .careFertilizing:
            carePlaceholder("Fertilizing", "Fertilizing guidance from Growing Intelligence.")
        case .carePlacement:
            carePlaceholder("Placement", "Placement and microclimate guidance.")
        case .careTreeHealth:
            carePlaceholder("Tree Health", "Health signals and recovery cues.")
        case .careSeasonal:
            carePlaceholder("Seasonal Care", "Season-aware care recommendations.")
        case .careWinter:
            carePlaceholder("Winter Care", "Winter protection and winter wash guidance.")

        case .designVision:
            designPlaceholder("Vision", "Long-term artistic intention for a tree.")
        case .designStyle:
            designPlaceholder("Style", "Style classification and planning.")
        case .designFrontSelection:
            designPlaceholder("Front Selection", "Choosing and refining the front.")
        case .designVirtual:
            designPlaceholder("Virtual Design", "Digital design exploration.")
        case .designBranchPlan:
            designPlaceholder("Branch Plan", "Primary and secondary branch planning.")
        case .designTrunkDevelopment:
            designPlaceholder("Trunk Development", "Trunk movement and taper planning.")
        case .designRamification:
            designPlaceholder("Ramification", "Fine branching development plans.")
        case .designApex:
            designPlaceholder("Apex", "Apex design and refinement.")
        case .designDeadwood:
            designPlaceholder("Deadwood", "Jin, shari, and deadwood design.")
        case .designTimeline:
            designPlaceholder("Timeline", "Multi-year design milestones.")

        case .inventoryPots:
            inventoryPlaceholder("Pots", "Pot inventory — single source of truth.")
        case .inventorySoil:
            inventoryPlaceholder("Soil", "Bulk soil stock.")
        case .inventorySoilComponents:
            inventoryPlaceholder("Soil Components", "Individual soil ingredients.")
        case .inventorySoilMixes:
            inventoryPlaceholder("Soil Mixes", "Named mixes composed of components.")
        case .inventoryFertilizers:
            inventoryPlaceholder("Fertilizers", "Fertilizer stock.")
        case .inventoryWire:
            inventoryPlaceholder("Wire", "Wiring stock by gauge and material.")
        case .inventoryTools:
            inventoryPlaceholder("Tools", "Tools inventory.")
        case .inventoryChemicals:
            inventoryPlaceholder("Chemicals", "Treatments and chemicals.")
        case .inventoryConsumables:
            inventoryPlaceholder("Consumables", "Other consumable supplies.")

        case .knowledgeQuickGuides:
            knowledgePlaceholder("Quick Guides", "Short practical guides.")
        case .knowledgeHandbook:
            knowledgePlaceholder("Bonsai Handbook", "Structured handbook content.")
        case .knowledgeSpeciesLibrary:
            knowledgePlaceholder("Species Library", "Species care and characteristics.")
        case .knowledgeSoilGuides:
            knowledgePlaceholder("Soil Guides", "Soil education.")
        case .knowledgeFertilizerGuides:
            knowledgePlaceholder("Fertilizer Guides", "Fertilizer education.")
        case .knowledgeVideos:
            knowledgePlaceholder("Video Tutorials", "Video learning resources.")
        case .knowledgeCourses:
            knowledgePlaceholder("Courses", "Structured courses.")
        case .knowledgeFAQ:
            knowledgePlaceholder("FAQ", "Frequently asked questions.")
        case .knowledgeExternalLinks:
            knowledgePlaceholder("External Links", "Curated external references.")

        case .economyPurchases:
            economyPlaceholder("Purchases", "Purchase records.")
        case .economySales:
            economyPlaceholder("Sales", "Sales records.")
        case .economyExpenses:
            economyPlaceholder("Expenses", "Expense tracking.")
        case .economyIncome:
            economyPlaceholder("Income", "Income tracking.")
        case .economyTreeValue:
            economyPlaceholder("Tree Value", "Estimated tree values.")
        case .economyPotValue:
            economyPlaceholder("Pot Value", "Estimated pot values.")
        case .economyInventoryValue:
            economyPlaceholder("Inventory Value", "Stock valuation.")
        case .economyReports:
            economyPlaceholder("Reports", "Financial reports.")

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
        case .userProfile:
            UserProfileView()
        case .regionalSettings:
            RegionalSettingsView()
        case .referenceData:
            ReferenceDataManagerView()
        case .appearance:
            AppearanceSettingsView()
        case .notifications:
            ModulePlaceholderView(
                title: "Notifications",
                systemImage: "bell",
                purpose: "Notification preferences for care and workshop reminders."
            )
        case .backup:
            ModulePlaceholderView(
                title: "Backup",
                systemImage: "externaldrive",
                purpose: "Backup and restore of the grower’s library."
            )
        case .none:
            ContentUnavailableView(
                "Settings",
                systemImage: "gearshape",
                description: Text("Choose a settings pane.")
            )
        }
    }

    private func nurseryPlaceholder(_ title: String, _ image: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: image,
            purpose: purpose + " Moved from Propagation into Nursery."
        )
    }

    private func carePlaceholder(_ title: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: "drop",
            purpose: purpose + " Recommendations will come from Growing Intelligence — not implemented yet."
        )
    }

    private func designPlaceholder(_ title: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: "pencil.and.outline",
            purpose: purpose + " Design tools are not implemented yet."
        )
    }

    private func inventoryPlaceholder(_ title: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: "shippingbox",
            purpose: purpose + " Stock management is not implemented yet."
        )
    }

    private func knowledgePlaceholder(_ title: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: "book",
            purpose: purpose + " Content is not added yet."
        )
    }

    private func economyPlaceholder(_ title: String, _ purpose: String) -> ModulePlaceholderView {
        ModulePlaceholderView(
            title: title,
            systemImage: "sterlingsign.circle",
            purpose: purpose + " Calculations are not implemented yet."
        )
    }
}

#Preview {
    ContentView()
        .environment(AppState())
        .environment(AppSettings())
        .environment(TreeListColumnConfiguration(visibleColumnIDs: TreeListColumnID.defaultOrder))
        .environment(PreviewData())
}
