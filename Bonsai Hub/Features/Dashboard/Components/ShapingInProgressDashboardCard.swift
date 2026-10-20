//
//  ShapingInProgressDashboardCard.swift
//  Bonsai World
//
//  Dashboard In Progress — Shaping areas marked In Progress. Tap opens Shaping.
//

import SwiftUI

struct ShapingInProgressDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private let rowLimit = 6

    private var rows: [InProgressArea] {
        let areaOrder = Dictionary(
            uniqueKeysWithValues: ShapingAreaID.allCases.enumerated().map { ($1, $0) }
        )
        return treeService.treesInCare.flatMap { tree -> [InProgressArea] in
            guard let areas = tree.shaping?.areas else { return [] }
            return areas.compactMap { key, record in
                guard record.status == .inProgress, let area = ShapingAreaID(rawValue: key) else { return nil }
                return InProgressArea(
                    treeID: tree.id,
                    treeName: tree.bonsaiName,
                    area: area,
                    nextAction: record.nextAction.trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        }
        .sorted { lhs, rhs in
            let byName = lhs.treeName.localizedStandardCompare(rhs.treeName)
            if byName != .orderedSame { return byName == .orderedAscending }
            return (areaOrder[lhs.area] ?? 0) < (areaOrder[rhs.area] ?? 0)
        }
        .prefix(rowLimit)
        .map { $0 }
    }

    var body: some View {
        DashboardCard(id: .shapingInProgress, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if rows.isEmpty {
                DashboardEmptyMessage(text: "No areas In Progress")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(rows) { row in
                        DashboardCardTapButton {
                            appState.showTreeShaping(treeID: row.treeID)
                        } label: {
                            DashboardMetricRow(
                                title: row.area.title,
                                detail: detail(for: row),
                                compact: true
                            )
                        }
                    }
                }
            }
        }
    }

    private func detail(for row: InProgressArea) -> String {
        if row.nextAction.isEmpty { return row.treeName }
        if row.treeName.isEmpty { return row.nextAction }
        return "\(row.treeName) · \(row.nextAction)"
    }
}

private struct InProgressArea: Identifiable {
    let treeID: UUID
    let treeName: String
    let area: ShapingAreaID
    let nextAction: String

    var id: String { "\(treeID.uuidString)|\(area.rawValue)" }
}
