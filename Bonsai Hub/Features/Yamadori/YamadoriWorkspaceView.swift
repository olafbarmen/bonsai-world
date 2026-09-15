//
//  YamadoriWorkspaceView.swift
//  Bonsai World
//
//  Nursery → Yamadori — Trees-style shell:
//  tabs + list on top (full width), detail below (VSplitView).
//

import SwiftUI

enum YamadoriWorkspaceTab: String, CaseIterable, Identifiable, Hashable, Sendable {
    case yamadories
    case uncollectedFindings
    case yamadoriTrees
    case transferredTrees

    var id: Self { self }

    var title: String {
        switch self {
        case .yamadories: "Yamadories"
        case .uncollectedFindings: "Uncollected Findings"
        case .yamadoriTrees: "Yamadori Trees"
        case .transferredTrees: "Transferred Trees"
        }
    }

    var showsTreeDetail: Bool {
        switch self {
        case .yamadoriTrees, .transferredTrees: true
        default: false
        }
    }
}

struct YamadoriWorkspaceView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 0) {
            Picker("Yamadori", selection: $appState.selectedYamadoriWorkspaceTab) {
                ForEach(YamadoriWorkspaceTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(FaloSpacing.medium)

            Divider()

            VSplitView {
                listPane
                    .frame(minHeight: 120, idealHeight: 240)

                detailPane
                    .frame(minHeight: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .faloWorkspaceCanvas()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Yamadori")
        .onChange(of: appState.selectedYamadoriWorkspaceTab) { _, newTab in
            clearSelection(for: newTab)
        }
    }

    @ViewBuilder
    private var listPane: some View {
        switch appState.selectedYamadoriWorkspaceTab {
        case .yamadories:
            YamadoriListView(embedded: true)
        case .uncollectedFindings:
            YamadoriUncollectedFindingsListView(embedded: true)
        case .yamadoriTrees:
            TreeListView(scope: .yamadoriNursery, embedded: true)
        case .transferredTrees:
            TreeListView(scope: .yamadoriTransferred, embedded: true)
        }
    }

    @ViewBuilder
    private var detailPane: some View {
        switch appState.selectedYamadoriWorkspaceTab {
        case .yamadories:
            if appState.selectedYamadoriID != nil {
                YamadoriDetailView()
            } else {
                emptyDetail(
                    title: "Select a Trip",
                    systemImage: "mountain.2",
                    description: "Choose a Yamadori trip in the list above."
                )
            }
        case .uncollectedFindings:
            if appState.selectedYamadoriFindID != nil {
                YamadoriFindDetailView()
            } else {
                emptyDetail(
                    title: "Select a Finding",
                    systemImage: "leaf",
                    description: "Choose a finding in the list above."
                )
            }
        case .yamadoriTrees, .transferredTrees:
            if let treeID = appState.selectedTreeID {
                TreeDetailView(mode: .edit(treeID), showsNavigationTitle: false)
            } else {
                emptyDetail(
                    title: "Select a Tree",
                    systemImage: "tree",
                    description: "Choose a tree in the list above."
                )
            }
        }
    }

    private func emptyDetail(title: String, systemImage: String, description: String) -> some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text(description)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func clearSelection(for tab: YamadoriWorkspaceTab) {
        if tab.showsTreeDetail {
            appState.selectedYamadoriID = nil
            appState.selectedYamadoriFindID = nil
            appState.yamadoriDetailInteractionMode = .viewing
            appState.pendingYamadoriQuickAction = nil
        } else {
            appState.selectedTreeID = nil
            appState.treeDetailInteractionMode = .viewing
            appState.pendingTreeQuickAction = nil
            if tab == .yamadories {
                appState.selectedYamadoriFindID = nil
            }
        }
    }
}

/// When embedded in ``YamadoriWorkspaceView``, skip own navigation chrome.
struct YamadoriEmbeddedListChrome: ViewModifier {
    var embedded: Bool
    var title: String

    func body(content: Content) -> some View {
        if embedded {
            content
        } else {
            content
                .navigationTitle(title)
                .navigationSplitViewColumnWidth(min: 320, ideal: 420, max: 640)
        }
    }
}
