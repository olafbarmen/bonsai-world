//
//  NurseryVegetativeListView.swift
//  Bonsai World
//
//  Cuttings / Air Layers / Grafting — Table list matching Garden → Trees
//  (inset, warm zebra). Single-click selects; double-click opens a window.
//

import SwiftUI

struct NurseryVegetativeListView: View {
    let kind: NurseryPropagationKind

    @Environment(AppState.self) private var appState
    @Environment(NurseryPropagationService.self) private var service
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(\.openWindow) private var openWindow

    @State private var tableSelection: Set<UUID> = []
    @State private var sortOrder: [KeyPathComparator<NurseryVegetativeListRow>] = [
        .init(\.botanicalName, comparator: .localizedStandard)
    ]

    private var selectedProjectID: UUID? {
        appState.selectedNurseryPropagationProjectID(for: kind)
    }

    private var activeRows: [NurseryVegetativeListRow] {
        service.activeProjects(kind: kind).map(makeRow)
    }

    private var archivedRows: [NurseryVegetativeListRow] {
        service.projects(kind: kind).filter { !$0.isActive }.map(makeRow)
    }

    private var sortedActiveRows: [NurseryVegetativeListRow] {
        sorted(activeRows)
    }

    private var sortedArchivedRows: [NurseryVegetativeListRow] {
        sorted(archivedRows)
    }

    private var parentColumnTitle: String {
        kind == .airLayer ? "Mother plant" : "Parent tree"
    }

    var body: some View {
        Group {
            if activeRows.isEmpty && archivedRows.isEmpty {
                ContentUnavailableView(
                    "No \(kind.title)",
                    systemImage: kind.systemImage,
                    description: Text("Use Context Tools → New \(kind.singularTitle) to start one.")
                )
            } else {
                listScroll
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { syncSelectionFromAppState() }
        .onChange(of: selectedProjectID) { _, _ in
            syncSelectionFromAppState()
        }
        .onChange(of: tableSelection) { _, newValue in
            let nextID = newValue.first
            guard selectedProjectID != nextID else { return }
            appState.setSelectedNurseryPropagationProjectID(nextID, for: kind)
        }
    }

    private var listScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                listBlock(
                    title: "Active \(kind.title)",
                    rows: sortedActiveRows,
                    emptyMessage: "No active \(kind.title.lowercased())."
                )
                if !archivedRows.isEmpty {
                    listBlock(
                        title: "Completed & Archived",
                        rows: sortedArchivedRows,
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
    private func listBlock(
        title: String,
        rows: [NurseryVegetativeListRow],
        emptyMessage: String?
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title)
                .font(FaloTypography.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, FaloSpacing.medium)
                .accessibilityAddTraits(.isHeader)

            if rows.isEmpty, let emptyMessage {
                Text(emptyMessage)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, FaloSpacing.medium)
            } else if !rows.isEmpty {
                horizontallyScrollableTable(rows)
            }
        }
    }

    private var tableMinimumWidth: CGFloat { 220 + 140 + 110 + 70 + 120 + 24 }

    private func horizontallyScrollableTable(_ rows: [NurseryVegetativeListRow]) -> some View {
        let height = tableHeight(for: rows.count)
        return GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                projectsTable(rows)
                    .frame(width: max(geo.size.width, tableMinimumWidth), height: height)
            }
        }
        .frame(height: height)
    }

    private func projectsTable(_ rows: [NurseryVegetativeListRow]) -> some View {
        Table(rows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn(kind.singularTitle, value: \.botanicalName, comparator: .localizedStandard) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.botanicalName)
                        .font(FaloTypography.body)
                        .lineLimit(1)
                    Text(row.projectCode)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 220, max: .infinity)

            TableColumn(parentColumnTitle, value: \.parentName, comparator: .localizedStandard) { row in
                Text(row.parentName.isEmpty ? "—" : row.parentName)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 140, max: .infinity)

            TableColumn("Stage", value: \.stageTitle, comparator: .localizedStandard) { row in
                Text(row.stageTitle)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 110, max: .infinity)

            TableColumn("Quantity", value: \.quantity) { row in
                Text("\(row.quantity)")
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 70, max: 90)

            TableColumn("Location", value: \.locationName, comparator: .localizedStandard) { row in
                Text(row.locationName.isEmpty ? "—" : row.locationName)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 120, max: .infinity)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: false))
        .faloWarmTableZebraRows()
        .scrollDisabled(true)
        .contextMenu(forSelectionType: UUID.self) { selection in
            if selection.count == 1, let id = selection.first {
                Button("Open in New Window") {
                    openProjectWindow(projectID: id)
                }
            }
        } primaryAction: { selection in
            guard let id = selection.first else { return }
            openProjectWindow(projectID: id)
        }
    }

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let headerHeight: CGFloat = 30
        let rowHeight: CGFloat = 52
        return headerHeight + CGFloat(rowCount) * rowHeight
    }

    private func sorted(_ rows: [NurseryVegetativeListRow]) -> [NurseryVegetativeListRow] {
        if sortOrder.isEmpty {
            return rows.sorted {
                $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
            }
        }
        return rows.sorted(using: sortOrder)
    }

    private func makeRow(_ project: NurseryPropagationProject) -> NurseryVegetativeListRow {
        let parent: String = {
            guard let parentID = project.parentTreeID,
                  let tree = treeService.getTree(id: parentID) else { return "" }
            return tree.bonsaiName.isEmpty ? tree.botanicalName : tree.bonsaiName
        }()
        let location: String = {
            guard let locationID = project.locationID,
                  let loc = referenceData.location(id: locationID) else { return "" }
            return loc.name
        }()
        return NurseryVegetativeListRow(
            id: project.id,
            botanicalName: project.botanicalName,
            projectCode: project.projectCode,
            parentName: parent,
            stageTitle: project.stage.title(for: kind),
            quantity: project.quantity,
            locationName: location
        )
    }

    private func syncSelectionFromAppState() {
        if let id = selectedProjectID {
            tableSelection = [id]
        } else {
            tableSelection = []
        }
    }

    private func openProjectWindow(projectID: UUID) {
        appState.setSelectedNurseryPropagationProjectID(projectID, for: kind)
        openWindow(
            id: NurseryPropagationWorkspaceWindowContext.windowID,
            value: NurseryPropagationWorkspaceWindowContext(kind: kind, projectID: projectID)
        )
    }
}

private struct NurseryVegetativeListRow: Identifiable, Sendable {
    var id: UUID
    var botanicalName: String
    var projectCode: String
    var parentName: String
    var stageTitle: String
    var quantity: Int
    var locationName: String
}
