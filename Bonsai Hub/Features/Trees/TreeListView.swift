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

/// Which tree population a list presents.
enum TreeListScope: Hashable, Sendable {
    case garden
    case yamadoriNursery
    case yamadoriTransferred

    var navigationTitle: String {
        switch self {
        case .garden: "Trees"
        case .yamadoriNursery: "Yamadori Trees"
        case .yamadoriTransferred: "Transferred Trees"
        }
    }

    var inCareSectionTitle: String {
        switch self {
        case .garden: "My Trees"
        case .yamadoriNursery: "Yamadori Trees"
        case .yamadoriTransferred: "Transferred Trees"
        }
    }

    var formerSectionTitle: String? {
        switch self {
        case .garden: "Former Trees"
        case .yamadoriNursery: "Former Yamadori Trees"
        case .yamadoriTransferred: nil
        }
    }

    var formerSectionSubtitle: String? {
        switch self {
        case .garden: "Sold, gifted, died, or lost — history kept"
        case .yamadoriNursery: "Disposed before moving to My Trees"
        case .yamadoriTransferred: nil
        }
    }

    var emptyInCareMessage: String {
        switch self {
        case .garden: "No trees in My Trees."
        case .yamadoriNursery: "No Yamadori Trees yet. Mark a Find as Collected to add one."
        case .yamadoriTransferred: "No transferred Yamadori trees yet."
        }
    }

    var emptyStateTitle: String {
        switch self {
        case .garden: "No Trees"
        case .yamadoriNursery: "No Yamadori Trees"
        case .yamadoriTransferred: "No Transferred Trees"
        }
    }

    var emptyStateDescription: String {
        switch self {
        case .garden: "Use Add Tree in Context Tools to add your first tree."
        case .yamadoriNursery: "Collect a Find to register it as a Yamadori Tree."
        case .yamadoriTransferred: "Move a Yamadori Tree to My Trees to see it here."
        }
    }
}

private struct TreeListNavigationChrome: ViewModifier {
    var embedded: Bool
    var title: String

    func body(content: Content) -> some View {
        if embedded {
            content
        } else {
            content.bonsaiWorkspaceNavigationTitle(title)
        }
    }
}

struct TreeListView: View {
    var scope: TreeListScope = .garden
    var embedded: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeListColumnConfiguration.self) private var columnConfiguration
    @Environment(ImageService.self) private var imageService
    @Environment(PotService.self) private var potService
    @Environment(WorkService.self) private var workService
    @Environment(\.openWindow) private var openWindow

    @State private var sortState = TreeListSortState()
    /// Local selection — Table must not bind directly to `@Environment(AppState)` (recycles rows without environment during fast scroll).
    @State private var tableSelection: Set<Tree.ID> = []

    var body: some View {
        Group {
            if scopedInCareTrees.isEmpty, scopedFormerTrees.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    if showsOverviewFilterChip {
                        overviewFilterChipBar
                    }
                    emptyState
                }
            } else {
                listsScroll
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .modifier(TreeListNavigationChrome(embedded: embedded, title: scope.navigationTitle))
    }

    private var sortOrder: Binding<[KeyPathComparator<TreeListRow>]> {
        Binding(
            get: { sortState.sortOrder },
            set: { sortState.sortOrder = $0 }
        )
    }

    private var showsOverviewFilterChip: Bool {
        scope == .garden && appState.treesOverviewFilter != .none
    }

    private var overviewFilterChipBar: some View {
        FilterChipBar {
            FilterChip(
                title: appState.treesOverviewFilter.chipTitle ?? "Filter",
                isSelected: true,
                systemImage: appState.treesOverviewFilter.chipSystemImage
            ) {
                appState.clearTreesOverviewFilter()
            }
        }
        .padding(.horizontal, FaloSpacing.small)
    }

    /// One scroll, two inset lists. Warm canvas fills the gap between them.
    private var listsScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                if showsOverviewFilterChip {
                    overviewFilterChipBar
                }

                listBlock(
                    title: scope.inCareSectionTitle,
                    subtitle: nil,
                    rows: sortedInCareRows,
                    emptyMessage: scope.emptyInCareMessage
                )
                if let formerTitle = scope.formerSectionTitle,
                   !formerRows.isEmpty,
                   appState.treesOverviewFilter == .none {
                    listBlock(
                        title: formerTitle,
                        subtitle: scope.formerSectionSubtitle,
                        rows: sortedFormerRows,
                        emptyMessage: nil
                    )
                }
            }
            .padding(.top, FaloSpacing.small)
            .padding(.bottom, FaloSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .onAppear {
            syncTableSelectionFromAppState()
        }
        .onChange(of: appState.selectedTreeID) { _, _ in
            syncTableSelectionFromAppState()
        }
        .onChange(of: tableSelection) { _, newValue in
            let nextID = newValue.first
            guard appState.selectedTreeID != nextID else { return }
            appState.selectedTreeID = nextID
        }
    }

    @ViewBuilder
    private func listBlock(
        title: String,
        subtitle: String?,
        rows: [TreeListRow],
        emptyMessage: String? = nil
    ) -> some View {
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

            if rows.isEmpty, let emptyMessage {
                Text(emptyMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, FaloSpacing.medium)
                    .padding(.bottom, FaloSpacing.small)
            } else if !rows.isEmpty {
                horizontallyScrollableTreesTable(rows)
            }
        }
    }

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let headerHeight: CGFloat = 30
        let rowHeight: CGFloat = 60
        return headerHeight + CGFloat(rowCount) * rowHeight
    }

    private static func tableMinimumWidth(for columns: [TreeListColumnID]) -> CGFloat {
        columns.reduce(CGFloat(24)) { $0 + $1.minimumWidth }
    }

    /// Vertical list scroll stays outer; this enables sideways reading when columns exceed width.
    private func horizontallyScrollableTreesTable(_ rows: [TreeListRow]) -> some View {
        let minWidth = Self.tableMinimumWidth(for: columnConfiguration.visibleColumnIDs)
        let height = tableHeight(for: rows.count)
        return GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                treesTable(rows)
                    .frame(width: max(geo.size.width, minWidth), height: height)
            }
        }
        .frame(height: height)
    }

    private func treesTable(_ rows: [TreeListRow]) -> some View {
        let visibleColumns = columnConfiguration.visibleColumnIDs
        return Table(rows, selection: $tableSelection, sortOrder: sortOrder) {
            // Indexed optionals (not ForEach) so column order follows configuration
            // without TableColumnBuilder / ForEach overload ambiguity.
            tableColumn(at: 0, visibleColumns: visibleColumns)
            tableColumn(at: 1, visibleColumns: visibleColumns)
            tableColumn(at: 2, visibleColumns: visibleColumns)
            tableColumn(at: 3, visibleColumns: visibleColumns)
            tableColumn(at: 4, visibleColumns: visibleColumns)
            tableColumn(at: 5, visibleColumns: visibleColumns)
            tableColumn(at: 6, visibleColumns: visibleColumns)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: false))
        .faloWarmTableZebraRows()
        .environment(imageService)
        .scrollDisabled(true)
        .contextMenu(forSelectionType: Tree.ID.self) { selection in
            if selection.count == 1, let id = selection.first,
               let tree = treeService.getTree(id: id) {
                treeContextMenu(for: tree)
            }
        } primaryAction: { selection in
            // Double-click opens Tree Workspace (Blueprint §5.2.2).
            openTreeWorkspace(for: selection)
        }
    }

    @ViewBuilder
    private func treeContextMenu(for tree: Tree) -> some View {
        Button("Open Tree Workspace") {
            openTreeWorkspace(for: [tree.id])
        }
        if tree.isInCare {
            Button("Edit Tree") {
                performTreeQuickAction(.editTree, treeID: tree.id)
            }
            Button("Duplicate Tree Info") {
                performTreeQuickAction(.duplicateTree, treeID: tree.id)
            }
        }
        if !tree.isInCare {
            Button("Return to My Trees") {
                performTreeQuickAction(.returnToCare, treeID: tree.id)
            }
        }
        if treeService.isFavoriteTree(tree.id) {
            Button("Remove from Favorite Trees") {
                appState.selectedTreeID = tree.id
                treeService.setFavoriteTree(tree.id, isFavorite: false)
            }
        } else {
            Button("Add to Favorite Trees") {
                appState.selectedTreeID = tree.id
                treeService.setFavoriteTree(tree.id, isFavorite: true)
            }
        }
        if tree.isInCare {
            Divider()
            Button("Add Work") {
                performTreeQuickAction(.addActivity, treeID: tree.id)
            }
            Button("Add Measurement") {
                performTreeQuickAction(.addMeasurement, treeID: tree.id)
            }
            Button("Add Photo") {
                performTreeQuickAction(.addImage, treeID: tree.id)
            }
            Button("Add Journal") {
                performTreeQuickAction(.addJournal, treeID: tree.id)
            }
        }
        Divider()
        Button("View Tree History") {
            performTreeQuickAction(.viewTreeHistory, treeID: tree.id)
        }
        Button("Show on Map") {
            performTreeQuickAction(.showOnMap, treeID: tree.id)
        }
        Button("View Photos") {
            performTreeQuickAction(.viewImages, treeID: tree.id)
        }
        Divider()
        Button("Delete Tree", role: .destructive) {
            performTreeQuickAction(.deleteTree, treeID: tree.id)
        }
    }

    /// Selects the tree, then the same Quick Action path as the sidebar.
    private func performTreeQuickAction(_ command: TreeQuickActionCommand, treeID: UUID) {
        appState.selectedTreeID = treeID
        appState.requestTreeQuickAction(command)
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
    private func tableColumn(
        at index: Int,
        visibleColumns: [TreeListColumnID]
    ) -> some TableColumnContent<TreeListRow, KeyPathComparator<TreeListRow>> {
        if index < visibleColumns.count {
            sortableColumn(visibleColumns[index])
        }
    }

    private func syncTableSelectionFromAppState() {
        let next = appState.selectedTreeID.map { Set([$0]) } ?? []
        guard tableSelection != next else { return }
        tableSelection = next
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
            TableColumn(columnID.title, value: \TreeListRow.treeStageName, comparator: .localizedStandard) { row in
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
        if columnID == .pot {
            Text(row.potName)
                .font(FaloTypography.body)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(row.tree.isInCare ? 1 : 0.72)
        } else if columnID == .lastRepot {
            Text(row.lastRepotLabel)
                .font(FaloTypography.body)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(row.tree.isInCare ? 1 : 0.72)
                .accessibilityLabel(row.lastRepotLabel == FaloDisplayValue.empty
                    ? "Last Repot, none recorded"
                    : "Last Repot, \(row.lastRepotLabel)")
        } else {
            TreeListColumnCell(
                columnID: columnID,
                tree: row.tree,
                referenceData: referenceData,
                imageService: imageService
            )
            .opacity(row.tree.isInCare ? 1 : 0.72)
        }
    }

    private var inCareRows: [TreeListRow] {
        _ = workService.revision
        return scopedInCareTrees.map {
            TreeListRow(
                tree: $0,
                referenceData: referenceData,
                potService: potService,
                workService: workService
            )
        }
    }

    private var formerRows: [TreeListRow] {
        _ = workService.revision
        return scopedFormerTrees.map {
            TreeListRow(
                tree: $0,
                referenceData: referenceData,
                potService: potService,
                workService: workService
            )
        }
    }

    private var scopedInCareTrees: [Tree] {
        let base: [Tree]
        switch scope {
        case .garden:
            base = treeService.treesInCare.filter { !$0.yamadoriNursery }
        case .yamadoriNursery:
            base = treeService.treesInCare.filter(\.yamadoriNursery)
        case .yamadoriTransferred:
            base = treeService.treesInCare.filter {
                $0.sourceYamadoriID != nil && !$0.yamadoriNursery
            }
        }
        guard scope == .garden else { return base }
        switch appState.treesOverviewFilter {
        case .none:
            return base
        case .developmentStage:
            let stageIDs = DashboardCollectionSummary.developmentStageIDs(in: referenceData.treeStages)
            return base.filter { DashboardCollectionSummary.isDevelopmentTree($0, developmentStageIDs: stageIDs) }
        case .withoutPhoto:
            return base.filter(DashboardCollectionSummary.lacksPhoto)
        case .withoutStatus:
            return base.filter(DashboardCollectionSummary.lacksTreeStage)
        case .withoutSpecies:
            return base.filter(DashboardCollectionSummary.lacksSpecies)
        }
    }

    private var scopedFormerTrees: [Tree] {
        switch scope {
        case .garden:
            treeService.treesFormer
        case .yamadoriNursery:
            treeService.treesFormer.filter { $0.sourceYamadoriID != nil && $0.yamadoriNursery }
        case .yamadoriTransferred:
            []
        }
    }

    /// Table updates `sortOrder` on header click but does not reorder rows itself.
    private var sortedInCareRows: [TreeListRow] {
        if sortState.sortOrder.isEmpty {
            return inCareRows.sorted {
                $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
            }
        }
        return inCareRows.sorted(using: sortState.sortOrder)
    }

    private var sortedFormerRows: [TreeListRow] {
        if sortState.sortOrder.isEmpty {
            return formerRows.sorted {
                $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
            }
        }
        return formerRows.sorted(using: sortState.sortOrder)
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label(overviewEmptyTitle, systemImage: "tree")
        } description: {
            Text(overviewEmptyDescription)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var overviewEmptyTitle: String {
        switch appState.treesOverviewFilter {
        case .none: scope.emptyStateTitle
        case .developmentStage: "No Development Trees"
        case .withoutPhoto: "No Trees Without a Photo"
        case .withoutStatus: "No Trees Without Status"
        case .withoutSpecies: "No Trees Without Species"
        }
    }

    private var overviewEmptyDescription: String {
        switch appState.treesOverviewFilter {
        case .none:
            scope.emptyStateDescription
        case .developmentStage:
            "No trees in care match the Development Tree Stage. Clear the filter to see all trees."
        case .withoutPhoto, .withoutStatus, .withoutSpecies:
            "No trees match this Library filter. Clear the filter to see all trees."
        }
    }
}

// MARK: - Sortable row

@MainActor
private final class TreeListSortState: @unchecked Sendable {
    var sortOrder: [KeyPathComparator<TreeListRow>] = []
}

/// Display strings used for header sort. Acquisition year uses `Int.max` when unset so blanks sort last.
private struct TreeListRow: Identifiable, Sendable {
    let tree: Tree
    let botanicalName: String
    let styleName: String
    let treeStageName: String
    let locationName: String
    let potName: String
    let acquisitionYear: Int
    let lastRepotLabel: String

    var id: Tree.ID { tree.id }

    @MainActor
    init(
        tree: Tree,
        referenceData: ReferenceDataService,
        potService: PotService,
        workService: WorkService
    ) {
        self.tree = tree
        botanicalName = FaloDisplayValue.text(tree.botanicalName)
        if let id = tree.styleID, let name = referenceData.style(id: id)?.name {
            styleName = name
        } else {
            styleName = FaloDisplayValue.empty
        }
        if let id = tree.treeStageID, let name = referenceData.treeStage(id: id)?.name {
            treeStageName = name
        } else {
            treeStageName = FaloDisplayValue.empty
        }
        locationName = FaloDisplayValue.text(referenceData.location(id: tree.locationID)?.name)
        potName = Self.resolvePotName(tree: tree, referenceData: referenceData, potService: potService)
        if let date = tree.acquisitionDate {
            acquisitionYear = Calendar.current.component(.year, from: date)
        } else {
            acquisitionYear = Int.max
        }
        if let date = workService.lastCompletedRepottingDate(for: tree.id) {
            lastRepotLabel = date.formatted(date: .abbreviated, time: .omitted)
        } else {
            lastRepotLabel = FaloDisplayValue.empty
        }
    }

    @MainActor
    private static func resolvePotName(
        tree: Tree,
        referenceData: ReferenceDataService,
        potService: PotService
    ) -> String {
        TreeCurrentPotDisplay.resolve(
            tree: tree,
            potService: potService,
            referenceData: referenceData
        ).title ?? FaloDisplayValue.empty
    }
}

// MARK: - Column cell

private struct TreeListColumnCell: View {
    let columnID: TreeListColumnID
    let tree: Tree
    let referenceData: ReferenceDataService
    let imageService: ImageService

    var body: some View {
        switch columnID {
        case .botanicalName:
            TreeIdentityCell(tree: tree, imageService: imageService)
        case .style:
            plainText(styleName)
        case .treeStatus:
            plainText(treeStageName)
        case .location:
            plainText(locationName)
        case .acquisition:
            Text(acquisitionYear)
                .font(FaloTypography.body)
                .monospacedDigit()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        case .pot, .lastRepot:
            // Rendered by ``TreeListView/columnCell`` using ``TreeListRow`` values.
            EmptyView()
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

    private var treeStageName: String {
        guard let id = tree.treeStageID,
              let stage = referenceData.treeStage(id: id)
        else {
            return FaloDisplayValue.empty
        }
        return stage.name
    }

    private var locationName: String {
        FaloDisplayValue.text(referenceData.location(id: tree.locationID)?.name)
    }

    private var acquisitionYear: String {
        guard let date = tree.acquisitionDate else {
            return FaloDisplayValue.empty
        }
        let year = Calendar.current.component(.year, from: date)
        return String(year)
    }
}

// MARK: - Identity cell (thumbnail + two compact lines)

private struct TreeIdentityCell: View {
    let tree: Tree
    let imageService: ImageService

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)

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
