//
//  TreeListView.swift
//  Bonsai World
//
//  My Trees — field list of canonical Tree records.
//

import SwiftUI

struct TreeListView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    @State private var searchText = ""
    @State private var isSearchPresented = false
    @State private var isShowingNewTree = false
    @State private var pendingCreatedTreeID: UUID?
    @State private var treePendingDelete: UUID?
    @State private var confirmDeleteTree = false
    /// Mac default is Botanical Name. Bonsai Name is the code.
    @State private var nameSort: TreeNameSort = .botanicalName

    private enum TreeNameSort: String, CaseIterable, Identifiable {
        case botanicalName
        case bonsaiName

        var id: String { rawValue }

        var title: String {
            switch self {
            case .botanicalName: "Botanical Name"
            case .bonsaiName: "Bonsai Name"
            }
        }
    }

    private var displayedTrees: [Tree] {
        matchingSearch(library.myTrees)
            .sorted { lhs, rhs in
                let left = sortKey(lhs)
                let right = sortKey(rhs)
                let order = left.localizedStandardCompare(right)
                if order != .orderedSame { return order == .orderedAscending }
                return MobileTreePresentation.bonsaiNameLine(for: lhs)
                    .localizedStandardCompare(MobileTreePresentation.bonsaiNameLine(for: rhs))
                    == .orderedAscending
            }
    }

    private func sortKey(_ tree: Tree) -> String {
        switch nameSort {
        case .botanicalName:
            let botanical = MobileTreePresentation.botanicalLine(for: tree)
            return botanical.isEmpty ? MobileTreePresentation.title(for: tree) : botanical
        case .bonsaiName:
            return MobileTreePresentation.bonsaiNameLine(for: tree)
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
        .searchable(text: $searchText, isPresented: $isSearchPresented, prompt: "Search")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isSearchPresented = true
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    ForEach(TreeNameSort.allCases) { sort in
                        Button(sort.title) {
                            nameSort = sort
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .accessibilityLabel(nameSort.title)
            }
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
    }

    private var deleteTreeDialogTitle: String {
        guard let id = treePendingDelete, let tree = library.tree(id: id) else {
            return "Delete this tree?"
        }
        return "Delete \(MobileTreePresentation.title(for: tree))?"
    }

    private var treeList: some View {
        List {
            Section {
                if displayedTrees.isEmpty {
                    Text("No trees")
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

    /// Same tree fields as Mac Search: Botanical Name, Bonsai Name, nickname, notes.
    private func matchingSearch(_ trees: [Tree]) -> [Tree] {
        let needle = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return trees }
        return trees.filter { tree in
            tree.botanicalName.localizedStandardContains(needle)
                || tree.bonsaiName.localizedStandardContains(needle)
                || tree.nickname.localizedStandardContains(needle)
                || tree.notes.localizedStandardContains(needle)
        }
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
