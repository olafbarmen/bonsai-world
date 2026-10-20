//
//  YamadoriUncollectedFindingsListView.swift
//  Bonsai World
//
//  Uncollected Finds — same Table config as Garden → Trees (fills pane, scrolls itself).
//

import SwiftUI

struct YamadoriUncollectedFindingsListView: View {
    var embedded: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ImageService.self) private var imageService

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

    private var findingsTableMinimumWidth: CGFloat { 200 + 120 + 160 + 24 }

    var body: some View {
        Group {
            if activeRows.isEmpty, formerRows.isEmpty {
                ContentUnavailableView(
                    "No Uncollected Findings",
                    systemImage: "leaf",
                    description: Text("Findings from Yamadori trips appear here until collected.")
                )
            } else {
                listContent
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

    /// Same structure as Trees — Table fills remaining height.
    private var listContent: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            findingsBlock(
                title: "Uncollected Findings",
                subtitle: nil,
                rows: sortedActiveRows,
                emptyMessage: "No uncollected findings.",
                fillsHeight: formerRows.isEmpty
            )
            if !formerRows.isEmpty {
                findingsBlock(
                    title: "Former Findings",
                    subtitle: "Abandoned or archived before collection",
                    rows: sortedFormerRows,
                    emptyMessage: nil,
                    fillsHeight: true
                )
            }
        }
        .frame(minWidth: findingsTableMinimumWidth, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloScrollSurface()
        .environment(\.defaultMinListRowHeight, 56)
    }

    @ViewBuilder
    private func findingsBlock(
        title: String,
        subtitle: String?,
        rows: [YamadoriFindListRow],
        emptyMessage: String?,
        fillsHeight: Bool
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
            .padding(.top, FaloSpacing.small)
            .accessibilityAddTraits(.isHeader)

            if rows.isEmpty, let emptyMessage {
                Text(emptyMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, FaloSpacing.medium)
                    .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
            } else if !rows.isEmpty {
                findingsTable(rows)
                    .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: fillsHeight ? .infinity : nil, alignment: .topLeading)
    }

    private func findingsTable(_ rows: [YamadoriFindListRow]) -> some View {
        Table(rows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn("Finding", value: \.displayName, comparator: .localizedStandard) { row in
                HStack(alignment: .center, spacing: FaloSpacing.small) {
                    TreeListThumbnail(
                        imageID: row.find.primaryImageID ?? row.find.imageIDs.first,
                        imageService: imageService
                    )
                    Text(row.displayName)
                        .font(FaloTypography.body.weight(.semibold))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
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
        .tableStyle(.inset(alternatesRowBackgrounds: true))
        .environment(imageService)
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

    private func syncSelectionFromAppState() {
        if let id = appState.selectedYamadoriFindID {
            tableSelection = [id]
        } else {
            tableSelection = []
        }
    }

    private func openFindWorkspace(_ find: YamadoriFind) {
        appState.openYamadoriFindInPlace(findID: find.id, tripID: find.yamadoriID)
    }

    private func tripName(for find: YamadoriFind) -> String {
        guard let trip = yamadoriService.getYamadori(id: find.yamadoriID) else { return "" }
        return trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct YamadoriFindListRow: Identifiable {
    var id: UUID { find.id }
    let find: YamadoriFind
    let tripName: String
    let imageService: ImageService

    var displayName: String {
        let name = find.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? find.yamadoriCode : name
    }

    var code: String { find.yamadoriCode }
}
