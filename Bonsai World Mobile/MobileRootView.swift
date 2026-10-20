//
//  MobileRootView.swift
//  Bonsai World
//

import SwiftUI

/// Presentation routes for iOS NavigationStacks. Not a domain model.
enum MobileRoute: Hashable {
    case myTrees
    case tasks
    case yamadori
    case yamadoriTrip(UUID)
    case yamadoriFind(UUID)
    case seeds
    case seedBatch(UUID)
    case propagation
    case soil
    case soilMix(UUID)
    case inventory(lowOnly: Bool)
    case inventoryItem(UUID)
    case pots
    case pot(UUID)
    case gardens
    case garden(UUID)
    case editGarden(UUID)
    case locations
    case location(UUID)
    case editLocation(UUID)
    case collections
    case collection(UUID)
    case editCollection(UUID)
    case tree(UUID)
    case editTree(UUID)
    case handbook
    case handbookChapter(BonsaiHandbookChapter)
    case handbookLesson(BonsaiHandbookChapter, String)
    case speciesLibrary
    case speciesProfile(UUID)
    case fertilizerGuides
    case seedStratification
    case careCalendar
    case careCalendarEntry(String)
    case knowledgeShelf(MobileKnowledgeShelf)
    case images
    case work
}

enum MobileRootTab: Hashable {
    case home
    case tasks
    case more
}

struct MobileRootView: View {
    @Environment(DemoLibrary.self) private var library
    @State private var selectedTab: MobileRootTab = .home
    @State private var homePath: [MobileRoute] = []
    @State private var tasksPath: [MobileRoute] = []
    @State private var morePath: [MobileRoute] = []
    @State private var isShowingSettings = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $homePath) {
                MobileHomeView()
                    .navigationDestination(for: MobileRoute.self) { route in
                        mobileDestination(route, path: $homePath)
                    }
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(MobileRootTab.home)

            NavigationStack(path: $tasksPath) {
                TaskListView()
                    .navigationDestination(for: MobileRoute.self) { route in
                        mobileDestination(route, path: $tasksPath)
                    }
            }
            .tabItem { Label("Tasks", systemImage: "checklist") }
            .badge(tasksBadgeCount)
            .accessibilityValue(tasksBadgeCount > 0 ? "\(tasksBadgeCount) overdue" : "None overdue")
            .tag(MobileRootTab.tasks)

            NavigationStack(path: $morePath) {
                MobileMoreView {
                    isShowingSettings = true
                }
                .navigationDestination(for: MobileRoute.self) { route in
                    mobileDestination(route, path: $morePath)
                }
            }
            .tabItem { Label("More", systemImage: "ellipsis.circle") }
            .tag(MobileRootTab.more)
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbarColorScheme(.light, for: .tabBar)
        .environment(\.appendMobileRoute, appendRoute)
        .environment(\.openMobileTree, openTree)
        .sheet(isPresented: $isShowingSettings) {
            MobileSettingsView()
                .environment(library)
        }
    }

    private var tasksBadgeCount: Int {
        library.pendingTasks(due: .overdue).count
    }

    private func openTree(_ treeID: UUID) {
        selectedTab = .home
        homePath = [.myTrees, .tree(treeID)]
    }

    private func appendRoute(_ route: MobileRoute) {
        switch route {
        case .tree(let id):
            openTree(id)
        case .myTrees:
            selectedTab = .home
            homePath = [.myTrees]
        case .tasks:
            selectedTab = .tasks
            tasksPath = []
        case .editTree(let id):
            selectedTab = .home
            if homePath.contains(.tree(id)) {
                homePath.append(.editTree(id))
            } else {
                homePath = [.myTrees, .tree(id), .editTree(id)]
            }
        default:
            switch selectedTab {
            case .home:
                homePath.append(route)
            case .tasks:
                tasksPath.append(route)
            case .more:
                morePath.append(route)
            }
        }
    }

    @ViewBuilder
    private func mobileDestination(_ route: MobileRoute, path: Binding<[MobileRoute]>) -> some View {
        switch route {
        case .myTrees:
            TreeListView()
        case .tasks:
            TaskListView()
        case .yamadori:
            YamadoriListView { tripID in
                path.wrappedValue.append(.yamadoriTrip(tripID))
            }
        case .yamadoriTrip(let tripID):
            YamadoriTripProfileView(tripID: tripID) { findID in
                path.wrappedValue.append(.yamadoriFind(findID))
            }
        case .yamadoriFind(let findID):
            YamadoriFindProfileView(findID: findID) { treeID in
                openTree(treeID)
            }
        case .seeds:
            SeedBatchListView { batchID in
                path.wrappedValue.append(.seedBatch(batchID))
            }
        case .seedBatch(let batchID):
            SeedBatchProfileView(batchID: batchID)
        case .propagation:
            PropagationHubView()
        case .soil:
            SoilMixListView { mixID in
                path.wrappedValue.append(.soilMix(mixID))
            }
        case .soilMix(let mixID):
            SoilMixProfileView(mixID: mixID)
        case .inventory(let lowOnly):
            InventoryListView(initialLowOnly: lowOnly) { itemID in
                path.wrappedValue.append(.inventoryItem(itemID))
            }
        case .inventoryItem(let itemID):
            InventoryItemProfileView(itemID: itemID)
        case .pots:
            PotListView { potID in
                path.wrappedValue.append(.pot(potID))
            }
        case .pot(let potID):
            PotProfileView(potID: potID)
        case .gardens:
            GardenListView { gardenID in
                path.wrappedValue.append(.garden(gardenID))
            }
        case .garden(let gardenID):
            GardenProfileView(gardenID: gardenID)
        case .editGarden(let gardenID):
            EditGardenView(gardenID: gardenID)
        case .locations:
            LocationListView { locationID in
                path.wrappedValue.append(.location(locationID))
            }
        case .location(let locationID):
            LocationProfileView(locationID: locationID)
        case .editLocation(let locationID):
            EditLocationView(locationID: locationID)
        case .collections:
            CollectionListView { collectionID in
                path.wrappedValue.append(.collection(collectionID))
            }
        case .collection(let collectionID):
            CollectionProfileView(collectionID: collectionID)
        case .editCollection(let collectionID):
            EditCollectionView(collectionID: collectionID)
        case .tree(let treeID):
            if library.tree(id: treeID) != nil {
                TreeProfileView(treeID: treeID)
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        case .editTree(let treeID):
            EditTreeView(treeID: treeID)
        case .handbook:
            MobileHandbookChapterListView()
        case .handbookChapter(let chapter):
            MobileHandbookLessonListView(chapter: chapter)
        case .handbookLesson(let chapter, let lessonID):
            MobileHandbookLessonView(chapter: chapter, lessonID: lessonID)
        case .speciesLibrary:
            MobileSpeciesLibraryView()
        case .speciesProfile(let profileID):
            MobileSpeciesProfileView(profileID: profileID)
        case .fertilizerGuides:
            MobileFertilizerGuidesView()
        case .seedStratification:
            MobileSeedStratificationView()
        case .careCalendar:
            MobileCareCalendarListView()
        case .careCalendarEntry(let entryID):
            MobileCareCalendarEntryView(entryID: entryID)
        case .knowledgeShelf(let shelf):
            MobileKnowledgeShelfView(shelf: shelf)
        case .images:
            MobileImagesBrowseView()
        case .work:
            MobileWorkBrowseView()
        }
    }
}

#Preview {
    MobileRootView()
        .environment(DemoLibrary.preview)
}
