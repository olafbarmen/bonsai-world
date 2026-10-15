//
//  SidebarView.swift
//  Bonsai World
//
//  Architecture Version 3 — workflow-first sidebar (Tasks, Garden + Locations, Shaping).
//  Visual hierarchy: Section → Module → Subpage (typography & spacing only).
//  User actions live in Context Tools only (no duplicate toolbars).
//

import AppKit
import SwiftUI

struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(PotService.self) private var potService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(UserProfileStore.self) private var profile
    @Environment(ImageService.self) private var imageService
    @Environment(GalleryService.self) private var galleryService
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.openWindow) private var openWindow
    /// Modules with a disclosure start expanded — same rule for every Workspace group.
    @State private var expandedModules: Set<AppModule> = Set(
        AppModule.workspaceModules.filter(\.showsChildNavigation)
    )

    private let sidebarWidth: CGFloat = 220
    private static let contextToolsMaxHeightFraction: CGFloat = 0.5

    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 0) {
            sidebarBranding
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FaloSpacing.medium)
                .padding(.vertical, FaloSpacing.xxxLarge)

            Divider()
                .opacity(0.35)

            // Middle only (Workspace list + Context Tools). Tools may use at most
            // half of *this* region — not half of the whole column with brand/profile.
            GeometryReader { mid in
                let toolsCap = mid.size.height * Self.contextToolsMaxHeightFraction

                VStack(spacing: 0) {
                    List(selection: $appState.selectedSection) {
                        Section {
                            ForEach(AppModule.primaryWorkspaceModules) { module in
                                moduleNavigation(module)
                            }
                        } header: {
                            SidebarSectionHeader(title: "Workspace", topPadding: FaloSpacing.small)
                        }

                        Section {
                            ForEach(AppModule.libraryWorkspaceModules) { module in
                                moduleNavigation(module)
                            }
                        } header: {
                            SidebarSectionHeader(title: "Library", topPadding: FaloSpacing.xxLarge)
                        }
                    }
                    .listStyle(.sidebar)
                    .faloScrollSurface()
                    .scrollContentBackground(.hidden)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .layoutPriority(1)

                    Divider()
                        .opacity(0.35)

                    pinnedContextTools(maxHeight: toolsCap)
                }
                .frame(width: mid.size.width, height: mid.size.height, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .layoutPriority(1)

            Divider()
                .opacity(0.35)

            // Fixed below Context Tools — labeled Settings, always visible.
            pinnedSettingsRow
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FaloSpacing.medium)
                .padding(.top, FaloSpacing.medium)
                .padding(.bottom, FaloSpacing.small)

            Divider()
                .opacity(0.35)

            // Profile stays below Settings — name + garden only.
            sidebarProfileFooter
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, FaloSpacing.medium)
                .padding(.vertical, FaloSpacing.xxxLarge)
        }
        .background(BonsaiWorldColors.sidebar)
        .tint(BonsaiWorldColors.sidebarAccent)
        .navigationSplitViewColumnWidth(min: 180, ideal: sidebarWidth, max: 280)
        .onChange(of: appState.selectedSection) { _, newValue in
            if let module = newValue?.module, module.showsChildNavigation {
                expandedModules.insert(module)
            }
        }
    }

    @ViewBuilder
    private func pinnedContextTools(maxHeight: CGFloat) -> some View {
        if appState.isImageWorkspaceWindow {
            let _ = appSettings.experienceEdition
            let canSetPrimary = appState.imageWorkspaceImageID
                .flatMap { galleryService.entry(for: $0)?.treeID } != nil
            QuickActionsView(
                sectionTitle: "Image Tools",
                globalActions: [],
                contextActions: ImageWorkspaceToolsCatalog.actions(
                    for: ImageWorkspaceExperienceLevel.current,
                    canSetPrimary: canSetPrimary
                ),
                maxHeight: maxHeight,
                onAction: handleImageWorkspaceTool
            )
        } else {
            let sectionActions = ContextQuickActionsCatalog.actions(
                for: appState.selectedSection,
                treesContext: ContextQuickActionsCatalog.TreesContext(
                    selectedTreeID: appState.selectedTreeID,
                    interactionMode: appState.treeDetailInteractionMode,
                    isInCare: appState.selectedTreeID.flatMap {
                        treeService.getTree(id: $0)?.isInCare
                    } ?? true,
                    isFavorite: appState.selectedTreeID.map {
                        treeService.isFavoriteTree($0)
                    } ?? false,
                    isTreeWorkspaceWindow: appState.isTreeWorkspaceWindow
                ),
                collectionsContext: ContextQuickActionsCatalog.CollectionsContext(
                    selectedCollectionID: appState.selectedCollectionID,
                    selectedCollectionIsManual: appState.selectedCollectionID.flatMap {
                        treeService.collection(id: $0)?.isManual
                    } ?? false,
                    interactionMode: appState.collectionDetailInteractionMode
                ),
                potsContext: ContextQuickActionsCatalog.PotsContext(
                    selectedPotID: appState.selectedPotID,
                    interactionMode: appState.potDetailInteractionMode,
                    status: appState.selectedPotID.flatMap { potService.getPot(id: $0)?.status }
                ),
                yamadoriContext: ContextQuickActionsCatalog.YamadoriContext(
                    selectedYamadoriID: appState.selectedYamadoriID,
                    selectedYamadoriFindID: appState.selectedYamadoriFindID,
                    interactionMode: appState.yamadoriDetailInteractionMode,
                    status: appState.selectedYamadoriFindID.flatMap {
                        yamadoriService.getFind(id: $0)?.status
                    }
                ),
                fieldTreeContext: ContextQuickActionsCatalog.FieldTreeContext(
                    selectedProjectID: appState.selectedFieldTreeProjectID,
                    interactionMode: appState.fieldTreeDetailInteractionMode
                ),
                vegetativeContext: {
                    let kind: NurseryPropagationKind? = switch appState.selectedSection {
                    case .nurseryCuttings: .cutting
                    case .nurseryAirLayers: .airLayer
                    case .nurseryGrafting: .grafting
                    default: nil
                    }
                    guard let kind else { return .none }
                    return ContextQuickActionsCatalog.VegetativePropagationContext(
                        selectedProjectID: appState.selectedNurseryPropagationProjectID(for: kind),
                        interactionMode: appState.nurseryPropagationDetailInteractionMode,
                        singularTitle: kind.singularTitle
                    )
                }(),
                seedsContext: {
                    let batch = appState.selectedSeedBatchID.flatMap { seedBatchService.batch(id: $0) }
                    return ContextQuickActionsCatalog.SeedsContext(
                        selectedBatchID: batch?.id,
                        stage: batch?.stage,
                        canCreateTrees: batch.map {
                            $0.stage == .developing
                                || $0.stage == .seedling
                                || $0.selectedTreeCount > $0.createdTreeIDs.count
                        } ?? false
                    )
                }(),
                mediaSelectedImageID: appState.selectedMediaImageID
            )
            // Search is cross-module; creates (Add Tree / Pot / Yamadori) come only from
            // sectionActions — never a separate global create block.
            QuickActionsView(
                sectionTitle: "Context Tools",
                globalActions: [],
                contextActions: GlobalQuickActionsCatalog.actions + sectionActions,
                maxHeight: maxHeight,
                onAction: handleQuickAction
            )
            .id(appState.selectedSection)
        }
    }

    private var sidebarBranding: some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 30, weight: .regular))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(BonsaiWorldColors.sidebarAccent)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(WorldIdentity.appName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
                    .lineLimit(1)

                Text(appSettings.experienceEdition.menuTitle)
                    .font(SidebarChrome.subpageFont)
                    .foregroundStyle(BonsaiWorldColors.sidebarTextSecondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel("\(WorldIdentity.appName), \(appSettings.experienceEdition.menuTitle)")
    }

    private var sidebarProfileFooter: some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            profileAvatar

            VStack(alignment: .leading, spacing: 1) {
                Text(profileDisplayName)
                    .font(SidebarChrome.moduleFont)
                    .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
                    .lineLimit(1)
                Text(profileGardenName)
                    .font(SidebarChrome.subpageFont)
                    .foregroundStyle(BonsaiWorldColors.sidebarTextSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(profileDisplayName), \(profileGardenName)")
    }

    /// Fixed Settings row — always below Context Tools and above the profile footer.
    private var pinnedSettingsRow: some View {
        let isSelected = appState.selectedSection == .settings
        return Button {
            appState.selectSection(.settings)
        } label: {
            moduleLabel(title: AppModule.settings.title, systemImage: AppModule.settings.systemImage)
                .padding(.horizontal, FaloSpacing.xSmall)
                .background {
                    SidebarRowBackground(isSelected: isSelected)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Settings")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// Profile mark — library image when ``UserProfileStore/profileImageID`` is set; otherwise SF Symbol.
    private var profileAvatar: some View {
        SidebarProfileAvatar(
            imageID: profile.profileImageID,
            imageService: imageService,
            size: SidebarChrome.profileAvatarSize
        )
    }

    private var profileDisplayName: String {
        FaloDisplayValue.text(profile.name)
    }

    private var profileGardenName: String {
        FaloDisplayValue.text(profile.defaultGarden?.name)
    }

    @ViewBuilder
    private func moduleNavigation(_ module: AppModule) -> some View {
        let routes = module.routes
        if module.showsChildNavigation {
            let isExpanded = expansionBinding(for: module)
            Button {
                isExpanded.wrappedValue.toggle()
            } label: {
                HStack(spacing: FaloSpacing.xSmall) {
                    Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
                        .frame(width: 12, alignment: .center)
                        .accessibilityHidden(true)
                    moduleLabel(title: module.title, systemImage: module.systemImage)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(module.title)
            .accessibilityValue(isExpanded.wrappedValue ? "Expanded" : "Collapsed")
            .listRowInsets(SidebarChrome.moduleInsets)
            .listRowBackground(
                SidebarRowBackground(
                    isSelected: appState.selectedSection?.module == module
                        && !(module.showsChildNavigation)
                )
            )

            if isExpanded.wrappedValue {
                ForEach(routes) { route in
                    navigationRow(
                        route,
                        title: route.title,
                        systemImage: nil,
                        level: .subpage
                    )
                }
            }
        } else if let route = routes.first {
            if module == .tasks {
                tasksModuleRow(route: route)
            } else if module == .care {
                careModuleRow(route: route)
            } else {
                navigationRow(
                    route,
                    title: module.title,
                    systemImage: module.systemImage,
                    level: .module
                )
            }
        }
    }

    /// Single Tasks row — overdue count badge; horizons live on the Tasks page (BJ1).
    private func tasksModuleRow(route: AppRoute) -> some View {
        let overdueCount = taskService.pendingOccurrences(due: .overdue).count
        let isSelected = appState.selectedSection?.module == .tasks
        return HStack(spacing: FaloSpacing.small) {
            Image(systemName: AppModule.tasks.systemImage)
                .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(BonsaiWorldColors.sidebarAccent)
                .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
            Text(AppModule.tasks.title)
                .font(SidebarChrome.moduleFont)
                .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
            Spacer(minLength: FaloSpacing.xSmall)
            if overdueCount > 0 {
                Text("\(overdueCount)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(Capsule().fill(BonsaiWorldColors.statusAttention))
                    .accessibilityLabel("\(overdueCount) overdue")
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .contentShape(Rectangle())
        .tag(route)
        .listRowInsets(SidebarChrome.moduleInsets)
        .listRowBackground(SidebarRowBackground(isSelected: isSelected))
        .accessibilityLabel("Tasks")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// Single Care row — pages live on the Care workspace picker (BV1).
    private func careModuleRow(route: AppRoute) -> some View {
        let isSelected = appState.selectedSection?.module == .care
        return HStack(spacing: FaloSpacing.small) {
            Image(systemName: AppModule.care.systemImage)
                .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(BonsaiWorldColors.sidebarAccent)
                .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
            Text(AppModule.care.title)
                .font(SidebarChrome.moduleFont)
                .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
            Spacer(minLength: 0)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .contentShape(Rectangle())
        .tag(route)
        .listRowInsets(SidebarChrome.moduleInsets)
        .listRowBackground(SidebarRowBackground(isSelected: isSelected))
        .accessibilityLabel("Care")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func moduleLabel(title: String, systemImage: String) -> some View {
        // HStack (not Label) so Dark Theme colors are not overridden by system Label styling.
        HStack(spacing: FaloSpacing.small) {
            Image(systemName: systemImage)
                .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(BonsaiWorldColors.sidebarAccent)
                .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
            Text(title)
                .font(SidebarChrome.moduleFont)
                .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
            Spacer(minLength: 0)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .contentShape(Rectangle())
    }

    private func expansionBinding(for module: AppModule) -> Binding<Bool> {
        Binding(
            get: {
                expandedModules.contains(module)
            },
            set: { expanded in
                if expanded {
                    expandedModules.insert(module)
                } else {
                    expandedModules.remove(module)
                }
            }
        )
    }

    private func requestSeedBatchQuickAction(_ command: SeedBatchQuickActionCommand) {
        appState.selectedSeedWorkspaceTab = .seedWork
        appState.requestSeedBatchQuickAction(command)
    }

    private func handleQuickAction(_ definition: ActionDefinition) {
        guard definition.kind == .action else { return }
        switch definition.id {
        case GlobalQuickActionsCatalog.newTreeID:
            appState.presentNewTree()
        case GlobalQuickActionsCatalog.copyExistingTreeID:
            appState.presentCopyExistingTree()
        case GlobalQuickActionsCatalog.newPotID:
            appState.presentNewPot()
        case GlobalQuickActionsCatalog.newYamadoriID:
            appState.presentNewYamadori()
        case GlobalQuickActionsCatalog.searchID:
            appState.presentSearch()
        case ContextQuickActionsCatalog.newLocationID:
            appState.presentNewLocation()
        case ContextQuickActionsCatalog.newCollectionID:
            appState.presentNewCollection()
        case ContextQuickActionsCatalog.addTreeToCollectionID:
            if let id = appState.selectedCollectionID,
               treeService.collection(id: id)?.isManual == true {
                appState.presentAddTreeToSelectedCollection()
            }
        case ContextQuickActionsCatalog.editCollectionID:
            if appState.selectedCollectionID.flatMap({ treeService.collection(id: $0)?.isManual }) == true {
                appState.requestCollectionQuickAction(.editCollection)
            }
        case ContextQuickActionsCatalog.deleteCollectionID:
            if appState.selectedCollectionID.flatMap({ treeService.collection(id: $0)?.isManual }) == true {
                appState.requestCollectionQuickAction(.deleteCollection)
            }
        case ContextQuickActionsCatalog.finishCollectionEditID:
            appState.requestCollectionQuickAction(.finish)
        case ContextQuickActionsCatalog.editTreeID:
            appState.requestTreeQuickAction(.editTree)
        case ContextQuickActionsCatalog.addActivityID:
            appState.requestTreeQuickAction(.addActivity)
        case ContextQuickActionsCatalog.addImageID:
            appState.requestTreeQuickAction(.addImage)
        case ContextQuickActionsCatalog.addMeasurementID:
            appState.requestTreeQuickAction(.addMeasurement)
        case ContextQuickActionsCatalog.addJournalID:
            appState.requestTreeQuickAction(.addJournal)
        case ContextQuickActionsCatalog.viewTreeHistoryID:
            appState.requestTreeQuickAction(.viewTreeHistory)
        case ContextQuickActionsCatalog.openTreeWorkspaceID:
            if let treeID = appState.selectedTreeID {
                openWindow(
                    id: TreeWorkspaceWindowContext.windowID,
                    value: TreeWorkspaceWindowContext(treeID: treeID)
                )
            }
        case ContextQuickActionsCatalog.showOnMapID:
            appState.requestTreeQuickAction(.showOnMap)
        case ContextQuickActionsCatalog.viewImagesID:
            appState.requestTreeQuickAction(.viewImages)
        case ContextQuickActionsCatalog.duplicateTreeID:
            appState.requestTreeQuickAction(.duplicateTree)
        case ContextQuickActionsCatalog.deleteTreeID:
            appState.requestTreeQuickAction(.deleteTree)
        case ContextQuickActionsCatalog.returnToCareID:
            appState.requestTreeQuickAction(.returnToCare)
        case ContextQuickActionsCatalog.addToFavoriteTreesID:
            if let id = appState.selectedTreeID {
                treeService.setFavoriteTree(id, isFavorite: true)
            }
        case ContextQuickActionsCatalog.removeFromFavoriteTreesID:
            if let id = appState.selectedTreeID {
                treeService.setFavoriteTree(id, isFavorite: false)
            }
        case ContextQuickActionsCatalog.cancelTreeEditID:
            appState.requestTreeQuickAction(.cancel)
        case ContextQuickActionsCatalog.cropPhotoID:
            if let imageID = appState.selectedMediaImageID {
                openWindow(
                    id: CropWorkspaceWindowContext.windowID,
                    value: CropWorkspaceWindowContext(imageID: imageID)
                )
            }
        case ContextQuickActionsCatalog.deleteImageID:
            appState.requestDeleteSelectedMediaImage()
        case ContextQuickActionsCatalog.importPhotosID:
            appState.presentImportImage()
        case ContextQuickActionsCatalog.nurseryNewItemID:
            switch appState.selectedSection {
            case .nurserySeeds:
                appState.presentNewSeedBatch()
            case .nurseryCuttings:
                appState.presentNewNurseryPropagation(kind: .cutting)
            case .nurseryAirLayers:
                appState.presentNewNurseryPropagation(kind: .airLayer)
            case .nurseryGrafting:
                appState.presentNewNurseryPropagation(kind: .grafting)
            case .nurseryFieldTree:
                appState.presentNewNurseryPropagation(kind: .fieldTree)
            default:
                break
            }
        case ContextQuickActionsCatalog.seedStartStratificationID:
            requestSeedBatchQuickAction(.startStratification)
        case ContextQuickActionsCatalog.seedShowAllBatchesID:
            appState.selectedSeedBatchID = nil
            appState.selectedSeedWorkspaceTab = .seedWork
        case ContextQuickActionsCatalog.seedSkipToReadyToSowID:
            requestSeedBatchQuickAction(.skipToReadyToSow)
        case ContextQuickActionsCatalog.seedCompleteCurrentPhaseID:
            requestSeedBatchQuickAction(.completeCurrentPhase)
        case ContextQuickActionsCatalog.seedExtendPhaseID:
            requestSeedBatchQuickAction(.extendPhase)
        case ContextQuickActionsCatalog.seedChangeTimeID:
            requestSeedBatchQuickAction(.changeTime)
        case ContextQuickActionsCatalog.seedRecordSowingID:
            requestSeedBatchQuickAction(.recordSowing)
        case ContextQuickActionsCatalog.seedRecordGerminationID:
            requestSeedBatchQuickAction(.recordGermination)
        case ContextQuickActionsCatalog.seedUpdateSurvivalID:
            requestSeedBatchQuickAction(.updateSurvival)
        case ContextQuickActionsCatalog.seedSeparateSeedlingsID:
            requestSeedBatchQuickAction(.separateSeedlings)
        case ContextQuickActionsCatalog.seedCreateTreesID:
            requestSeedBatchQuickAction(.createTrees)
        case ContextQuickActionsCatalog.seedMarkFailedID:
            requestSeedBatchQuickAction(.markFailed)
        case ContextQuickActionsCatalog.editFieldTreeID:
            appState.fieldTreeDetailInteractionMode = .editing
        case ContextQuickActionsCatalog.finishFieldTreeEditID:
            appState.fieldTreeDetailInteractionMode = .viewing
        case ContextQuickActionsCatalog.editNurseryPropagationID:
            appState.nurseryPropagationDetailInteractionMode = .editing
        case ContextQuickActionsCatalog.finishNurseryPropagationEditID:
            appState.nurseryPropagationDetailInteractionMode = .viewing
        case ContextQuickActionsCatalog.showAllNurseryProjectsID:
            switch appState.selectedSection {
            case .nurseryCuttings:
                appState.setSelectedNurseryPropagationProjectID(nil, for: .cutting)
            case .nurseryAirLayers:
                appState.setSelectedNurseryPropagationProjectID(nil, for: .airLayer)
            case .nurseryGrafting:
                appState.setSelectedNurseryPropagationProjectID(nil, for: .grafting)
            default:
                break
            }
            appState.nurseryPropagationDetailInteractionMode = .viewing
        case ContextQuickActionsCatalog.addFieldTreeTaskID:
            appState.wantsAddFieldTreeTask = true
        case ContextQuickActionsCatalog.editPotID:
            appState.requestPotQuickAction(.editPot)
        case ContextQuickActionsCatalog.addPotImageID:
            appState.requestPotQuickAction(.addImage)
        case ContextQuickActionsCatalog.markPotSoldID:
            appState.requestPotQuickAction(.markSold)
        case ContextQuickActionsCatalog.markPotBrokenID:
            appState.requestPotQuickAction(.markBroken)
        case ContextQuickActionsCatalog.markPotRetiredID:
            appState.requestPotQuickAction(.markRetired)
        case ContextQuickActionsCatalog.returnPotToAvailableID:
            appState.requestPotQuickAction(.returnToAvailable)
        case ContextQuickActionsCatalog.deletePotID:
            appState.requestPotQuickAction(.deletePot)
        case ContextQuickActionsCatalog.cancelPotEditID:
            appState.requestPotQuickAction(.cancel)
        case ContextQuickActionsCatalog.addSoilID:
            appState.presentAddSoil()
        case ContextQuickActionsCatalog.newSoilMixID:
            appState.selectedSection = .inventorySoil
            appState.selectedSoilWorkspaceTab = .mixes
            appState.wantsNewSoilMix = true
        case ContextQuickActionsCatalog.startSoilStocktakeID:
            appState.presentSoilStocktake()
        case ContextQuickActionsCatalog.stockReportID:
            let area: StockReportArea? = switch appState.selectedSection {
            case .inventorySoil, .inventorySoilComponents, .inventorySoilMixes: .soil
            case .inventoryPots: .pots
            case .inventoryWire: .wire
            case .inventoryTools: .tools
            case .inventoryChemicals: .chemicals
            case .inventoryConsumables: .consumables
            case .inventoryFertilizers: .fertilizers
            default: nil
            }
            appState.presentStockReport(focusing: area)
        case ContextQuickActionsCatalog.soilGuidesID:
            appState.openHandbook(chapter: .soilGuides)
        case ContextQuickActionsCatalog.addInventoryStockID:
            if let kind = appState.selectedSection.flatMap(InventoryStockKind.kind(for:)) {
                appState.presentAddInventoryStock(kind: kind)
            }
        case ContextQuickActionsCatalog.exportStockReportID:
            appState.wantsExportStockReport = true
        case ContextQuickActionsCatalog.newGardenID:
            appState.wantsNewGarden = true
            appState.selectSection(.locationsGardens)
        case ContextQuickActionsCatalog.newTaskID:
            appState.wantsNewTask = true
        case ContextQuickActionsCatalog.manageSchedulesID:
            appState.wantsManageSchedules = true
        case ContextQuickActionsCatalog.completeAllTasksID:
            appState.wantsCompleteAllTasks = true
        case ContextQuickActionsCatalog.addMediaLibraryItemID:
            switch appState.selectedSection {
            case .mediaDocuments: appState.wantsNewMediaLibraryKind = .document
            case .mediaNotes: appState.wantsNewMediaLibraryKind = .note
            case .mediaVideo: appState.wantsNewMediaLibraryKind = .video
            case .mediaAudio: appState.wantsNewMediaLibraryKind = .audio
            default: break
            }
        case ContextQuickActionsCatalog.addKnowledgeResourceID:
            switch appState.selectedSection {
            case .knowledgeQuickGuides: appState.wantsNewKnowledgeResourceKind = .quickGuide
            case .knowledgeFAQ: appState.wantsNewKnowledgeResourceKind = .faq
            case .knowledgeCourses: appState.wantsNewKnowledgeResourceKind = .course
            case .knowledgeVideos: appState.wantsNewKnowledgeResourceKind = .videoTutorial
            case .knowledgeExternalLinks: appState.wantsNewKnowledgeResourceKind = .externalLink
            default: break
            }
        case ContextQuickActionsCatalog.addSimpleCatalogEntryID:
            if let kind = SimpleCatalogKind.allCases.first(where: { $0.route == appState.selectedSection }) {
                appState.wantsNewSimpleCatalogKind = kind
            }
        case ContextQuickActionsCatalog.editYamadoriID:
            appState.requestYamadoriQuickAction(.editYamadori)
        case ContextQuickActionsCatalog.addYamadoriFindID:
            appState.requestYamadoriQuickAction(.addFind)
        case ContextQuickActionsCatalog.addYamadoriObservationID:
            appState.requestYamadoriQuickAction(.addObservation)
        case ContextQuickActionsCatalog.addYamadoriImageID:
            appState.requestYamadoriQuickAction(.addImage)
        case ContextQuickActionsCatalog.advanceYamadoriStatusID:
            appState.requestYamadoriQuickAction(.advanceStatus)
        case ContextQuickActionsCatalog.markYamadoriCollectedID:
            appState.requestYamadoriQuickAction(.markCollected)
        case ContextQuickActionsCatalog.transferYamadoriToTreeID:
            appState.requestYamadoriQuickAction(.transferToTree)
        case ContextQuickActionsCatalog.abandonYamadoriID:
            appState.requestYamadoriQuickAction(.abandon)
        case ContextQuickActionsCatalog.archiveYamadoriID:
            appState.requestYamadoriQuickAction(.archive)
        case ContextQuickActionsCatalog.deleteYamadoriID:
            appState.requestYamadoriQuickAction(.deleteYamadori)
        case ContextQuickActionsCatalog.cancelYamadoriEditID:
            appState.requestYamadoriQuickAction(.cancel)
        default:
            break
        }
    }

    private func handleImageWorkspaceTool(_ definition: ActionDefinition) {
        switch definition.id {
        case ImageWorkspaceToolsCatalog.importID:
            appState.requestImageQuickAction(.importPhotos)
        case ImageWorkspaceToolsCatalog.cropID:
            appState.requestImageQuickAction(.crop)
        case ImageWorkspaceToolsCatalog.rotateID:
            appState.requestImageQuickAction(.rotate)
        case ImageWorkspaceToolsCatalog.setPrimaryID:
            appState.requestImageQuickAction(.setPrimary)
        case ImageWorkspaceToolsCatalog.deleteID:
            appState.requestImageQuickAction(.delete)
        default:
            break
        }
    }

    private func navigationRow(
        _ route: AppRoute,
        title: String,
        systemImage: String?,
        level: SidebarNavLevel
    ) -> some View {
        let isSelected = appState.selectedSection == route
        return Group {
            if let systemImage {
                Label {
                    Text(title)
                        .font(level.titleFont)
                        .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarTextPrimary : level.titleColor)
                } icon: {
                    Image(systemName: systemImage)
                        .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(
                            isSelected
                                ? BonsaiWorldColors.sidebarAccent
                                : BonsaiWorldColors.sidebarAccent.opacity(0.85)
                        )
                        .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
                }
            } else {
                Text(title)
                    .font(level.titleFont)
                    .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarTextPrimary : level.titleColor)
            }
        }
        .padding(.vertical, level.verticalPadding)
        .tag(route)
        .listRowInsets(level.rowInsets)
        .listRowBackground(SidebarRowBackground(isSelected: isSelected))
    }
}

// MARK: - Sidebar visual hierarchy (styling only)

private enum SidebarNavLevel {
    case module
    case subpage

    var titleFont: Font {
        switch self {
        case .module: SidebarChrome.moduleFont
        case .subpage: SidebarChrome.subpageFont
        }
    }

    var titleColor: Color {
        switch self {
        case .module: BonsaiWorldColors.sidebarTextPrimary
        case .subpage: BonsaiWorldColors.sidebarTextSecondary
        }
    }

    var verticalPadding: CGFloat {
        switch self {
        case .module: FaloSpacing.xSmall
        case .subpage: 2
        }
    }

    var rowInsets: EdgeInsets {
        switch self {
        case .module: SidebarChrome.moduleInsets
        case .subpage: SidebarChrome.subpageInsets
        }
    }
}

private enum SidebarChrome {
    /// Level 2 — primary modules.
    static let moduleFont = Font.system(size: 13, weight: .semibold)
    /// Level 3 — subpages under a module.
    static let subpageFont = Font.system(size: 12, weight: .regular)

    static let iconSize: CGFloat = FaloIconSize.navigation
    static let iconFrame: CGFloat = 20
    /// Profile footer avatar — fits existing footer height (32–36 px target).
    static let profileAvatarSize: CGFloat = 36

    /// More air between modules; keeps groups readable.
    static let moduleInsets = EdgeInsets(
        top: FaloSpacing.small,
        leading: FaloSpacing.small,
        bottom: FaloSpacing.small,
        trailing: FaloSpacing.small
    )

    /// Tighter vertical rhythm; clearer indent under parent.
    static let subpageInsets = EdgeInsets(
        top: 2,
        leading: FaloSpacing.large + FaloSpacing.small,
        bottom: 2,
        trailing: FaloSpacing.small
    )
}

/// Circular profile avatar — display crop via ImageService; SF Symbol when no image.
private struct SidebarProfileAvatar: View {
    var imageID: UUID?
    let imageService: ImageService
    var size: CGFloat

    @State private var thumbnail: NSImage?

    var body: some View {
        let _ = imageService.presentationRevision
        Group {
            if let thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: size * 0.92, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(BonsaiWorldColors.accent.opacity(0.75))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .accessibilityHidden(true)
        .task(id: "\(imageID?.uuidString ?? "")-\(size)-\(imageService.presentationRevision)") {
            await loadThumbnail()
        }
    }

    private func loadThumbnail() async {
        guard let imageID else {
            thumbnail = nil
            return
        }
        let maxPixel = Int(size * 2.5)
        do {
            thumbnail = try await imageService.loadDisplayNSImage(
                for: imageID,
                context: .treeThumbnail,
                maxPixelSize: max(96, maxPixel)
            )
        } catch {
            thumbnail = nil
        }
    }
}

#Preview {
    NavigationSplitView {
        SidebarView()
    } detail: {
        Text("Preview")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .environment(AppState())
    .environment(UserProfileStore())
    .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
    .frame(width: 720, height: 560)
}
