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
    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

    @State private var sortOrder: [KeyPathComparator<TreeListRow>] = [
        KeyPathComparator(\.botanicalName, comparator: .localizedStandard)
    ]

    var body: some View {
        Group {
            if treeService.trees.isEmpty {
                emptyState
            } else {
                listsScroll
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
        .navigationTitle("Trees")
    }

    /// One scroll, two inset lists. Gray window chrome sits in the gap between them.
    private var listsScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                listBlock(title: "My Trees", subtitle: nil, rows: sortedInCareRows)
                if !formerRows.isEmpty {
                    listBlock(
                        title: "Former Trees",
                        subtitle: "Sold, gifted, died, or lost — history kept",
                        rows: sortedFormerRows
                    )
                }
            }
            .padding(.top, FaloSpacing.small)
            .padding(.bottom, FaloSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }

    @ViewBuilder
    private func listBlock(title: String, subtitle: String?, rows: [TreeListRow]) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(FaloTypography.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                if let subtitle {
                    Text(subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, FaloSpacing.medium)
            .accessibilityAddTraits(.isHeader)

            if rows.isEmpty {
                Text("No trees in My Trees.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, FaloSpacing.medium)
                    .padding(.bottom, FaloSpacing.small)
            } else {
                treesTable(rows)
                    .frame(height: tableHeight(for: rows.count))
            }
        }
    }

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let headerHeight: CGFloat = 30
        let rowHeight: CGFloat = 60
        return headerHeight + CGFloat(rowCount) * rowHeight
    }

    private func treesTable(_ rows: [TreeListRow]) -> some View {
        Table(rows, selection: selectionBinding, sortOrder: $sortOrder) {
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
        .environment(imageService)
        .frame(maxWidth: .infinity)
        .scrollDisabled(true)
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
    @TableColumnBuilder<TreeListRow, KeyPathComparator<TreeListRow>>
    private func tableColumn(at index: Int) -> some TableColumnContent<TreeListRow, KeyPathComparator<TreeListRow>> {
        if index < columnConfiguration.visibleColumnIDs.count {
            sortableColumn(columnConfiguration.visibleColumnIDs[index])
        }
    }

    @TableColumnBuilder<TreeListRow, KeyPathComparator<TreeListRow>>
    private func sortableColumn(_ columnID: TreeListColumnID) -> some TableColumnContent<TreeListRow, KeyPathComparator<TreeListRow>> {
        switch columnID {
        case .botanicalName:
            TableColumn(columnID.title, value: \TreeListRow.botanicalName, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .style:
            TableColumn(columnID.title, value: \TreeListRow.styleName, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .treeStatus:
            TableColumn(columnID.title, value: \TreeListRow.treeStatusName, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .location:
            TableColumn(columnID.title, value: \TreeListRow.locationName, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .pot:
            TableColumn(columnID.title, value: \TreeListRow.potName, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .acquisition:
            TableColumn(columnID.title, value: \TreeListRow.acquisitionYear) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        case .lastRepot:
            TableColumn(columnID.title, value: \TreeListRow.lastRepotLabel, comparator: .localizedStandard) { row in
                columnCell(columnID, row: row)
            }
            .width(min: columnID.minimumWidth, max: .infinity)
        }
    }

    @ViewBuilder
    private func columnCell(_ columnID: TreeListColumnID, row: TreeListRow) -> some View {
        TreeListColumnCell(
            columnID: columnID,
            tree: row.tree,
            referenceData: referenceData
        )
        .opacity(row.tree.isInCare ? 1 : 0.72)
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

    private var inCareRows: [TreeListRow] {
        treeService.treesInCare.map { TreeListRow(tree: $0, referenceData: referenceData) }
    }

    private var formerRows: [TreeListRow] {
        treeService.treesFormer.map { TreeListRow(tree: $0, referenceData: referenceData) }
    }

    /// Table updates `sortOrder` on header click but does not reorder rows itself.
    private var sortedInCareRows: [TreeListRow] {
        inCareRows.sorted(using: sortOrder)
    }

    private var sortedFormerRows: [TreeListRow] {
        formerRows.sorted(using: sortOrder)
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Trees", systemImage: "tree")
        } description: {
            Text("Use Add Tree in Quick Actions to add your first tree.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Sortable row

/// Display strings used for header sort. Acquisition year uses `Int.max` when unset so blanks sort last.
private struct TreeListRow: Identifiable {
    let tree: Tree
    let botanicalName: String
    let styleName: String
    let treeStatusName: String
    let locationName: String
    let potName: String
    let acquisitionYear: Int
    let lastRepotLabel: String

    var id: Tree.ID { tree.id }

    @MainActor
    init(tree: Tree, referenceData: ReferenceDataService) {
        self.tree = tree
        botanicalName = FaloDisplayValue.text(tree.botanicalName)
        if let id = tree.styleID, let name = referenceData.style(id: id)?.name {
            styleName = name
        } else {
            styleName = FaloDisplayValue.empty
        }
        if let id = tree.treeStatusID, let name = referenceData.treeStatus(id: id)?.name {
            treeStatusName = name
        } else {
            treeStatusName = FaloDisplayValue.empty
        }
        locationName = FaloDisplayValue.text(referenceData.location(id: tree.locationID)?.name)
        if let id = tree.potTypeID, let name = referenceData.potType(id: id)?.name {
            potName = name
        } else {
            potName = FaloDisplayValue.empty
        }
        if let date = tree.acquisitionDate {
            acquisitionYear = Calendar.current.component(.year, from: date)
        } else {
            acquisitionYear = Int.max
        }
        lastRepotLabel = "Never"
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

// MARK: - Identity cell (thumbnail + two compact lines)

private struct TreeIdentityCell: View {
    let tree: Tree

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            TreeListThumbnail(imageID: tree.listImageID)

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
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var botanicalLine: String {
        FaloDisplayValue.text(tree.botanicalName)
    }

    private var bonsaiNameLine: String {
        let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? FaloDisplayValue.empty : name
    }

    private var accessibilityLabel: String {
        let photo = tree.listImageID == nil ? "No photo" : "Has photo"
        return "\(botanicalLine), \(bonsaiNameLine), \(photo)"
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
        .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
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
        .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
}
