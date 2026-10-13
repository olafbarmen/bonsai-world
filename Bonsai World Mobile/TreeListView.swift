//
//  TreeListView.swift
//  Bonsai World
//
//  My Trees — field list of canonical Tree records.
//

import SwiftUI

private enum TreeSoilMixFilter: Hashable {
    case all
    case none
    case mix(UUID)
}

private enum TreeHealthFilter: Hashable {
    case all
    case attention
    case status(TreeHealthStatus)
}

struct TreeListView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    /// When true, opens with Health filter set to Attention (Home Attention → See all).
    var initialAttentionOnly: Bool = false

    @State private var soilMixFilter: TreeSoilMixFilter = .all
    @State private var healthFilter: TreeHealthFilter = .all
    @State private var didApplyInitialHealthFilter = false
    @State private var isShowingNewTree = false
    @State private var pendingCreatedTreeID: UUID?
    @State private var treePendingDelete: UUID?
    @State private var confirmDeleteTree = false

    private var displayedTrees: [Tree] {
        filteredTrees(library.myTrees)
            .sorted {
                MobileTreePresentation.bonsaiNameLine(for: $0)
                    .localizedStandardCompare(MobileTreePresentation.bonsaiNameLine(for: $1))
                    == .orderedAscending
            }
    }

    var body: some View {
        Group {
            if library.myTrees.isEmpty {
                ContentUnavailableView {
                    Label("No trees", systemImage: "leaf")
                } description: {
                    Text("Add a tree to start your collection.")
                } actions: {
                    Button("New Tree") {
                        isShowingNewTree = true
                    }
                    .accessibilityLabel("New Tree")
                }
            } else {
                treeList
            }
        }
        .navigationTitle("My Trees")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Tree") {
                    isShowingNewTree = true
                }
                .accessibilityLabel("New Tree")
            }
        }
        .sheet(isPresented: $isShowingNewTree, onDismiss: {
            if let id = pendingCreatedTreeID {
                pendingCreatedTreeID = nil
                openMobileTree(id)
            }
        }) {
            NewTreeView { id in
                pendingCreatedTreeID = id
            }
        }
        .confirmationDialog(
            deleteTreeDialogTitle,
            isPresented: $confirmDeleteTree,
            titleVisibility: .visible
        ) {
            Button("Delete Tree", role: .destructive) {
                if let id = treePendingDelete {
                    library.deleteTree(id: id)
                }
                treePendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                treePendingDelete = nil
            }
        } message: {
            Text("Photos, work history, and tasks for this tree are removed. This cannot be undone.")
        }
        .onAppear {
            guard !didApplyInitialHealthFilter else { return }
            if initialAttentionOnly {
                healthFilter = .attention
            }
            didApplyInitialHealthFilter = true
        }
    }

    private var deleteTreeDialogTitle: String {
        guard let id = treePendingDelete, let tree = library.tree(id: id) else {
            return "Delete this tree?"
        }
        return "Delete \(MobileTreePresentation.title(for: tree))?"
    }

    private var treeList: some View {
        let attention = library.treesNeedingAttention
        return List {
            Section {
                Button {
                    if healthFilter == .attention {
                        healthFilter = .all
                    } else {
                        guard !attention.isEmpty else { return }
                        healthFilter = .attention
                    }
                } label: {
                    HStack {
                        Text(attentionCaption(attention.count))
                            .font(FaloTypography.caption)
                            .foregroundStyle(
                                attention.isEmpty
                                    ? BonsaiWorldColors.textTertiary
                                    : BonsaiWorldColors.statusAttention
                            )
                        Spacer(minLength: 0)
                        if healthFilter == .attention {
                            Text("Clear")
                                .font(FaloTypography.caption.weight(.semibold))
                                .foregroundStyle(BonsaiWorldColors.accent)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(attention.isEmpty && healthFilter != .attention)
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel(attentionCaption(attention.count))
                .accessibilityHint(
                    healthFilter == .attention
                        ? "Clears the attention filter"
                        : (attention.isEmpty ? "" : "Filters the list to trees that need attention")
                )
            }

            Section {
                Picker("Soil Mix", selection: $soilMixFilter) {
                    Text("All").tag(TreeSoilMixFilter.all)
                    Text("None").tag(TreeSoilMixFilter.none)
                    ForEach(library.orderedSoilMixes) { mix in
                        Text(mix.name).tag(TreeSoilMixFilter.mix(mix.id))
                    }
                }
                .accessibilityLabel("Soil Mix filter")

                Picker("Health", selection: $healthFilter) {
                    Text("All").tag(TreeHealthFilter.all)
                    Text("Attention").tag(TreeHealthFilter.attention)
                    ForEach(TreeHealthStatus.allCases) { status in
                        Text(status.title).tag(TreeHealthFilter.status(status))
                    }
                }
                .accessibilityLabel("Health filter")
            } header: {
                Text("Filter")
            }

            Section {
                if displayedTrees.isEmpty {
                    Text(emptyFilterMessage)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                } else {
                    ForEach(displayedTrees) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            TreeRowView(tree: tree)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Delete", role: .destructive) {
                                treePendingDelete = tree.id
                                confirmDeleteTree = true
                            }
                            .accessibilityLabel("Delete Tree")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private func attentionCaption(_ count: Int) -> String {
        if count == 0 { return "No trees need attention" }
        if count == 1 { return "1 needs attention" }
        return "\(count) need attention"
    }

    private var emptyFilterMessage: String {
        if soilMixFilter != .all || healthFilter != .all {
            return "No trees match these filters."
        }
        return "No trees"
    }

    private func filteredTrees(_ trees: [Tree]) -> [Tree] {
        var result = trees
        switch soilMixFilter {
        case .all:
            break
        case .none:
            result = result.filter { $0.soilMixID == nil }
        case .mix(let id):
            result = result.filter { $0.soilMixID == id }
        }
        switch healthFilter {
        case .all:
            break
        case .attention:
            result = result.filter {
                $0.healthStatus == .needsAttention || $0.healthStatus == .recovering
            }
        case .status(let status):
            result = result.filter { $0.healthStatus == status }
        }
        return result
    }
}

private struct TreeRowView: View {
    @Environment(DemoLibrary.self) private var library
    let tree: Tree

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            MobileTreeImage(tree: tree, style: .list)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(MobileTreePresentation.title(for: tree))
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)

                if !MobileTreePresentation.subtitle(for: tree).isEmpty {
                    Text(MobileTreePresentation.subtitle(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                if let locationName {
                    Text(locationName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }

                if let mixName = soilMixName {
                    Text(mixName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }

                Text(lastRepotCaption)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)

                if shouldShowBonsaiName {
                    Text(MobileTreePresentation.bonsaiNameLine(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }

                MobileHealthBadge(status: tree.healthStatus)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private var lastRepotCaption: String {
        if let date = library.lastRepotDate(for: tree.id) {
            return "Last repot · \(date.formatted(date: .abbreviated, time: .omitted))"
        }
        return "Last repot · Never"
    }

    private var locationName: String? {
        guard let name = library.locationName(for: tree.locationID)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty
        else { return nil }
        return name
    }

    private var soilMixName: String? {
        guard let mixID = tree.soilMixID,
              let name = library.soilMix(id: mixID)?.name.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty
        else { return nil }
        return name
    }

    private var shouldShowBonsaiName: Bool {
        let code = MobileTreePresentation.bonsaiNameLine(for: tree)
        guard !code.isEmpty else { return false }
        return MobileTreePresentation.title(for: tree) != code
            && MobileTreePresentation.subtitle(for: tree) != code
    }
}

#Preview {
    NavigationStack {
        TreeListView()
    }
    .environment(DemoLibrary.preview)
}
