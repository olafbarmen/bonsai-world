//
//  YamadoriUncollectedFindingsListView.swift
//  Bonsai World
//
//  Uncollected Finds — Table layout matching Garden → Trees.
//

import SwiftUI

struct YamadoriUncollectedFindingsListView: View {
    var embedded: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

    @State private var tableSelection: Set<YamadoriFind.ID> = []
    @State private var sortOrder: [KeyPathComparator<YamadoriFindListRow>] = [
        .init(\.code, comparator: .localizedStandard)
    ]

    private var activeRows: [YamadoriFindListRow] {
        yamadoriService.getAllFinds()
            .filter { $0.status.isUncollected }
            .map { YamadoriFindListRow(find: $0, tripName: tripName(for: $0), imageService: imageService) }
    }

    private var formerRows: [YamadoriFindListRow] {
        yamadoriService.getAllFinds()
            .filter { $0.status == .abandoned || $0.status == .archived }
            .map { YamadoriFindListRow(find: $0, tripName: tripName(for: $0), imageService: imageService) }
    }

    private var sortedActiveRows: [YamadoriFindListRow] {
        sorted(activeRows)
    }

    private var sortedFormerRows: [YamadoriFindListRow] {
        sorted(formerRows)
    }

    var body: some View {
        Group {
            if activeRows.isEmpty, formerRows.isEmpty {
                ContentUnavailableView(
                    "No Uncollected Findings",
                    systemImage: "leaf",
                    description: Text("Findings from Yamadori trips appear here until collected.")
                )
            } else {
                listScroll
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .modifier(YamadoriEmbeddedListChrome(embedded: embedded, title: "Uncollected Findings"))
        .onAppear { syncSelectionFromAppState() }
        .onChange(of: appState.selectedYamadoriFindID) { _, _ in syncSelectionFromAppState() }
        .onChange(of: tableSelection) { _, newValue in
            let nextID = newValue.first
            guard appState.selectedYamadoriFindID != nextID else { return }
            appState.selectedYamadoriFindID = nextID
            if let id = nextID, let find = yamadoriService.getFind(id: id) {
                appState.selectedYamadoriID = find.yamadoriID
            }
            appState.yamadoriDetailInteractionMode = .viewing
        }
    }

    private var listScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                findingsBlock(
                    title: "Uncollected Findings",
                    subtitle: nil,
                    rows: sortedActiveRows,
                    emptyMessage: "No uncollected findings."
                )
                if !formerRows.isEmpty {
                    findingsBlock(
                        title: "Former Findings",
                        subtitle: "Abandoned or archived before collection",
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
    }

    @ViewBuilder
    private func findingsBlock(
        title: String,
        subtitle: String?,
        rows: [YamadoriFindListRow],
        emptyMessage: String?
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
            } else if !rows.isEmpty {
                findingsTable(rows)
            }
        }
    }

    private func findingsTable(_ rows: [YamadoriFindListRow]) -> some View {
        let minWidth: CGFloat = 200 + 120 + 160 + 24
        let height = tableHeight(for: rows.count)
        return GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                findingsTableContent(rows)
                    .frame(width: max(geo.size.width, minWidth), height: height)
            }
        }
        .frame(height: height)
    }

    private func findingsTableContent(_ rows: [YamadoriFindListRow]) -> some View {
        Table(rows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn("Finding", value: \.displayName, comparator: .localizedStandard) { row in
                HStack(spacing: FaloSpacing.medium) {
                    TreeListThumbnail(
                        imageID: row.find.primaryImageID ?? row.find.imageIDs.first,
                        imageService: imageService
                    )
                    Text(row.displayName)
                        .font(FaloTypography.body)
                        .lineLimit(1)
                }
                .padding(.vertical, FaloSpacing.xSmall)
            }
            .width(min: 200, max: .infinity)

            TableColumn("Code", value: \.code, comparator: .localizedStandard) { row in
                Text(row.code)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 120, max: .infinity)

            TableColumn("Trip", value: \.tripName, comparator: .localizedStandard) { row in
                Text(row.tripName.isEmpty ? "—" : row.tripName)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 160, max: .infinity)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: false))
        .faloWarmTableZebraRows()
        .environment(imageService)
        .scrollDisabled(true)
        .contextMenu(forSelectionType: YamadoriFind.ID.self) { selection in
            if selection.count == 1, let id = selection.first,
               let find = yamadoriService.getFind(id: id) {
                Button("Open Find Workspace") {
                    openFindWorkspace(find)
                }
                Divider()
                Button("Delete Find", role: .destructive) {
                    appState.selectedYamadoriFindID = id
                    appState.selectedYamadoriID = find.yamadoriID
                    appState.requestYamadoriQuickAction(.deleteYamadori)
                }
            }
        } primaryAction: { selection in
            guard let id = selection.first,
                  let find = yamadoriService.getFind(id: id) else { return }
            openFindWorkspace(find)
        }
    }

    private func sorted(_ rows: [YamadoriFindListRow]) -> [YamadoriFindListRow] {
        if sortOrder.isEmpty {
            return rows.sorted {
                $0.code.localizedStandardCompare($1.code) == .orderedAscending
            }
        }
        return rows.sorted(using: sortOrder)
    }

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let headerHeight: CGFloat = 30
        let rowHeight: CGFloat = 60
        return headerHeight + CGFloat(rowCount) * rowHeight
    }

    private func syncSelectionFromAppState() {
        if let id = appState.selectedYamadoriFindID {
            tableSelection = [id]
        } else {
            tableSelection = []
        }
    }

    private func openFindWorkspace(_ find: YamadoriFind) {
        openWindow(
            id: YamadoriFindWorkspaceWindowContext.windowID,
            value: YamadoriFindWorkspaceWindowContext(findID: find.id, tripID: find.yamadoriID)
        )
    }

    private func tripName(for find: YamadoriFind) -> String {
        guard let trip = yamadoriService.getYamadori(id: find.yamadoriID) else { return "" }
        let trimmed = trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if !trip.locationDescription.isEmpty { return trip.locationDescription }
        return "Untitled trip"
    }
}

@MainActor
private struct YamadoriFindListRow: Identifiable {
    var id: UUID { find.id }
    let find: YamadoriFind
    let tripName: String
    let imageService: ImageService

    var displayName: String {
        let trimmed = find.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? find.yamadoriCode : trimmed
    }

    var code: String { find.yamadoriCode }
}
