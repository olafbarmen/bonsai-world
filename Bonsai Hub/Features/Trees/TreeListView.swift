//
//  TreeListView.swift
//  Bonsai World
//
//  Compact collection data grid for medium/large tree libraries.
//  Full-width rows — columns expand to fill available space.
//  Visibility/order driven by TreeListColumnConfiguration (Settings later).
//  Selection drives Tree Detail in the lower workspace pane.
//

import SwiftUI

struct TreeListView: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeListColumnConfiguration.self) private var columnConfiguration
    @Environment(\.openWindow) private var openWindow

    @State private var sort: TreeBrowserSort = .name

    var body: some View {
        Group {
            if treeService.trees.isEmpty {
                emptyState
            } else {
                table
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
        .navigationTitle("Trees")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Picker("Sort", selection: $sort) {
                    ForEach(TreeBrowserSort.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .help("Sort trees")
                .accessibilityLabel("Sort trees")
            }
        }
    }

    private var table: some View {
        Table(sortedTrees, selection: selectionBinding) {
            // Indexed optionals (not ForEach) so column order follows configuration
            // without TableColumnBuilder / ForEach overload ambiguity.
            tableColumn(at: 0)
            tableColumn(at: 1)
            tableColumn(at: 2)
            tableColumn(at: 3)
            tableColumn(at: 4)
            tableColumn(at: 5)
            tableColumn(at: 6)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: true))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloScrollSurface()
        .contextMenu(forSelectionType: Tree.ID.self) { selection in
            Button("Open Tree Workspace") {
                openTreeWorkspace(for: selection)
            }
            .disabled(selection.count != 1)
        } primaryAction: { selection in
            // Double-click opens Tree Workspace (Blueprint §5.2.2).
            openTreeWorkspace(for: selection)
        }
    }

    /// Opens a dedicated Tree Workspace window for a single selected Tree.
    private func openTreeWorkspace(for treeIDs: Set<Tree.ID>) {
        guard treeIDs.count == 1, let treeID = treeIDs.first else { return }
        appState.selectedTreeID = treeID
        openWindow(
            id: TreeWorkspaceWindowContext.windowID,
            value: TreeWorkspaceWindowContext(treeID: treeID)
        )
    }

    /// One slot per possible column; empty when fewer columns are visible.
    @TableColumnBuilder<Tree, Never>
    private func tableColumn(at index: Int) -> some TableColumnContent<Tree, Never> {
        if index < columnConfiguration.visibleColumnIDs.count {
            let columnID = columnConfiguration.visibleColumnIDs[index]
            TableColumn(columnID.title) { (tree: Tree) in
                TreeListColumnCell(
                    columnID: columnID,
                    tree: tree,
                    referenceData: referenceData
                )
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        }
    }

    /// Single-selection bridge to ``AppState.selectedTreeID``.
    private var selectionBinding: Binding<Set<Tree.ID>> {
        Binding(
            get: {
                if let id = appState.selectedTreeID {
                    return [id]
                }
                return []
            },
            set: { newValue in
                appState.selectedTreeID = newValue.first
            }
        )
    }

    private var sortedTrees: [Tree] {
        var trees = treeService.trees
        switch sort {
        case .name:
            trees.sort {
                TreePresentation.title(for: $0)
                    .localizedCaseInsensitiveCompare(TreePresentation.title(for: $1)) == .orderedAscending
            }
        case .species:
            trees.sort {
                let left = $0.botanicalName.isEmpty ? TreePresentation.title(for: $0) : $0.botanicalName
                let right = $1.botanicalName.isEmpty ? TreePresentation.title(for: $1) : $1.botanicalName
                return left.localizedCaseInsensitiveCompare(right) == .orderedAscending
            }
        case .recentlyUpdated:
            trees.sort { $0.modifiedDate > $1.modifiedDate }
        }
        return trees
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Trees", systemImage: "tree")
        } description: {
            Text("Use New Tree in Quick Actions to create your first tree.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Column cell

private struct TreeListColumnCell: View {
    let columnID: TreeListColumnID
    let tree: Tree
    let referenceData: ReferenceDataService

    var body: some View {
        switch columnID {
        case .botanicalName:
            TreeIdentityCell(tree: tree)
        case .style:
            plainText(styleName)
        case .treeStatus:
            plainText(treeStatusName)
        case .location:
            plainText(locationName)
        case .pot:
            plainText(potName)
        case .acquisition:
            Text(acquisitionYear)
                .font(FaloTypography.body)
                .monospacedDigit()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .lastRepot:
            plainText(lastRepotLabel)
        }
    }

    private func plainText(_ value: String) -> some View {
        Text(value)
            .font(FaloTypography.body)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var styleName: String {
        guard let id = tree.styleID, let style = referenceData.style(id: id) else {
            return FaloDisplayValue.empty
        }
        return style.name
    }

    private var treeStatusName: String {
        guard let id = tree.treeStatusID,
              let status = referenceData.treeStatus(id: id)
        else {
            return FaloDisplayValue.empty
        }
        return status.name
    }

    private var locationName: String {
        FaloDisplayValue.text(referenceData.location(id: tree.locationID)?.name)
    }

    private var potName: String {
        guard let id = tree.potTypeID, let pot = referenceData.potType(id: id) else {
            return FaloDisplayValue.empty
        }
        return pot.name
    }

    private var acquisitionYear: String {
        guard let date = tree.acquisitionDate else {
            return FaloDisplayValue.empty
        }
        let year = Calendar.current.component(.year, from: date)
        return String(year)
    }

    /// No last-repot field on Tree yet — present absence as Never.
    private var lastRepotLabel: String {
        "Never"
    }
}

// MARK: - Identity cell (exactly two compact lines)

private struct TreeIdentityCell: View {
    let tree: Tree

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(botanicalLine)
                .font(FaloTypography.body.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Text(bonsaiNameLine)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(botanicalLine), \(bonsaiNameLine)")
    }

    private var botanicalLine: String {
        FaloDisplayValue.text(tree.botanicalName)
    }

    private var bonsaiNameLine: String {
        let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? FaloDisplayValue.empty : name
    }
}

#Preview("With trees") {
    let preview = PreviewData()
    let treeService = TreeService.preview(previewData: preview)
    return TreeListView()
        .environment(AppState())
        .environment(treeService)
        .environment(ReferenceDataService(previewData: ReferencePreviewData()))
        .environment(TreeListColumnConfiguration(visibleColumnIDs: TreeListColumnID.defaultOrder))
        .frame(width: 960, height: 280)
}

#Preview("Empty") {
    let preview = PreviewData()
    preview.trees = []
    let treeService = TreeService.preview(previewData: preview)
    return TreeListView()
        .environment(AppState())
        .environment(treeService)
        .environment(ReferenceDataService(previewData: ReferencePreviewData()))
        .environment(TreeListColumnConfiguration(visibleColumnIDs: TreeListColumnID.defaultOrder))
}
