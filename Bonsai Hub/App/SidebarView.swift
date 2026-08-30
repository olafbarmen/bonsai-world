//
//  SidebarView.swift
//  Bonsai World
//
//  Architecture Version 3 — workflow-first sidebar (Tasks, Garden + Locations, Shaping).
//  Visual hierarchy: Section → Module → Subpage (typography & spacing only).
//  User actions live in Quick Actions only (no duplicate toolbars).
//

import SwiftUI

struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(\.openWindow) private var openWindow
    @State private var expandedModules: Set<AppModule> = [
        .tasks, .garden, .media, .nursery
    ]

    private let sidebarWidth: CGFloat = 220

    var body: some View {
        @Bindable var appState = appState

        List(selection: $appState.selectedSection) {
            Section {
                ForEach(AppModule.primaryWorkspaceModules) { module in
                    moduleNavigation(module)
                }

                Divider()
                    .padding(.vertical, FaloSpacing.xSmall)

                ForEach(AppModule.libraryWorkspaceModules) { module in
                    moduleNavigation(module)
                }
            } header: {
                SidebarSectionHeader(title: "Workspace")
            }

            if appState.isImageWorkspaceWindow {
                QuickActionsView(
                    sectionTitle: "Image Tools",
                    globalActions: [],
                    contextActions: ImageWorkspaceToolsCatalog.actions(
                        for: ImageWorkspaceExperienceLevel.current
                    ),
                    onAction: handleImageWorkspaceTool
                )
            } else {
                QuickActionsView(
                    globalActions: GlobalQuickActionsCatalog.actions,
                    contextActions: ContextQuickActionsCatalog.actions(
                        for: appState.selectedSection,
                        treesContext: ContextQuickActionsCatalog.TreesContext(
                            selectedTreeID: appState.selectedTreeID,
                            interactionMode: appState.treeDetailInteractionMode,
                            isInCare: appState.selectedTreeID.flatMap {
                                treeService.getTree(id: $0)?.isInCare
                            } ?? true,
                            isFavorite: appState.selectedTreeID.map {
                                treeService.isFavoriteTree($0)
                            } ?? false
                        ),
                        collectionsContext: ContextQuickActionsCatalog.CollectionsContext(
                            selectedCollectionID: appState.selectedCollectionID,
                            selectedCollectionIsManual: appState.selectedCollectionID.flatMap {
                                treeService.collection(id: $0)?.isManual
                            } ?? false,
                            interactionMode: appState.collectionDetailInteractionMode
                        ),
                        mediaSelectedImageID: appState.selectedMediaImageID
                    ),
                    onAction: handleQuickAction
                )
            }

            Section {
                ForEach(AppModule.toolsModules) { module in
                    moduleNavigation(module)
                }
            } header: {
                SidebarSectionHeader(
                    title: "Tools",
                    topPadding: FaloSpacing.xxLarge
                )
            }
        }
        .listStyle(.sidebar)
        .faloScrollSurface()
        .background(.windowBackground)
        .navigationTitle(WorldIdentity.appName)
        .navigationSplitViewColumnWidth(min: 180, ideal: sidebarWidth, max: 280)
        .onChange(of: appState.selectedSection) { _, newValue in
            if let module = newValue?.module, module.showsChildNavigation {
                expandedModules.insert(module)
            }
        }
    }

    @ViewBuilder
    private func moduleNavigation(_ module: AppModule) -> some View {
        let routes = module.routes
        if module.showsChildNavigation {
            DisclosureGroup(isExpanded: expansionBinding(for: module)) {
                ForEach(routes) { route in
                    navigationRow(
                        route,
                        title: route.title,
                        systemImage: nil,
                        level: .subpage
                    )
                }
            } label: {
                moduleLabel(title: module.title, systemImage: module.systemImage)
            }
            .listRowInsets(SidebarChrome.moduleInsets)
        } else if let route = routes.first {
            navigationRow(
                route,
                title: module.title,
                systemImage: module.systemImage,
                level: .module
            )
        }
    }

    private func moduleLabel(title: String, systemImage: String) -> some View {
        Label {
            Text(title)
                .font(SidebarChrome.moduleFont)
                .foregroundStyle(.primary)
        } icon: {
            Image(systemName: systemImage)
                .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary.opacity(0.75))
                .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func expansionBinding(for module: AppModule) -> Binding<Bool> {
        Binding(
            get: {
                expandedModules.contains(module)
                    || appState.selectedSection?.module == module
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

    private func handleQuickAction(_ definition: ActionDefinition) {
        switch definition.id {
        case GlobalQuickActionsCatalog.newTreeID:
            appState.presentNewTree()
        case GlobalQuickActionsCatalog.copyExistingTreeID:
            appState.presentCopyExistingTree()
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
            appState.requestCollectionQuickAction(.editCollection)
        case ContextQuickActionsCatalog.finishCollectionEditID:
            appState.requestCollectionQuickAction(.finish)
        case ContextQuickActionsCatalog.editTreeID:
            appState.requestTreeQuickAction(.editTree)
        case ContextQuickActionsCatalog.addImageID:
            appState.requestTreeQuickAction(.addImage)
        case ContextQuickActionsCatalog.addMeasurementID:
            appState.requestTreeQuickAction(.addMeasurement)
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
        default:
            break
        }
    }

    private func handleImageWorkspaceTool(_ definition: ActionDefinition) {
        switch definition.id {
        case ImageWorkspaceToolsCatalog.importID:
            appState.requestImageQuickAction(.importPhotos)
        case ImageWorkspaceToolsCatalog.attachToTreeID:
            appState.requestImageQuickAction(.attachToTree)
        case ImageWorkspaceToolsCatalog.cropID:
            appState.requestImageQuickAction(.crop)
        case ImageWorkspaceToolsCatalog.rotateID:
            appState.requestImageQuickAction(.rotate)
        case ImageWorkspaceToolsCatalog.setPrimaryID:
            appState.requestImageQuickAction(.setPrimary)
        case ImageWorkspaceToolsCatalog.setFeaturedID:
            appState.requestImageQuickAction(.setFeatured)
        case ImageWorkspaceToolsCatalog.compareID:
            appState.requestImageQuickAction(.compare)
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
        Group {
            if route == .tasksOverdue {
                overdueRow
            } else if let systemImage {
                Label {
                    Text(title)
                        .font(level.titleFont)
                        .foregroundStyle(level.titleColor)
                } icon: {
                    Image(systemName: systemImage)
                        .font(.system(size: SidebarChrome.iconSize, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary.opacity(0.75))
                        .frame(width: SidebarChrome.iconFrame, height: SidebarChrome.iconFrame, alignment: .center)
                }
            } else {
                Text(title)
                    .font(level.titleFont)
                    .foregroundStyle(level.titleColor)
            }
        }
        .padding(.vertical, level.verticalPadding)
        .tag(route)
        .listRowInsets(level.rowInsets)
    }

    private var overdueRow: some View {
        let count = taskService.pendingOccurrences(due: .overdue).count
        return HStack {
            Text("Overdue")
                .font(SidebarNavLevel.subpage.titleFont)
                .foregroundStyle(count > 0 ? Color.orange : SidebarNavLevel.subpage.titleColor)
            Spacer(minLength: FaloSpacing.xSmall)
            if count > 0 {
                Text("\(count)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(Capsule().fill(Color.orange))
                    .accessibilityLabel("\(count) overdue")
            }
        }
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
        case .module: .primary
        case .subpage: .secondary
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

    static let iconSize: CGFloat = 13
    static let iconFrame: CGFloat = 20

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

#Preview {
    NavigationSplitView {
        SidebarView()
    } detail: {
        Text("Preview")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .environment(AppState())
    .frame(width: 720, height: 560)
}
