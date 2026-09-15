//
//  RecentWorkDashboardCard.swift
//  Bonsai World
//
//  Dashboard Recent Work — live Work history. Read-only; tap opens the Tree.
//

import SwiftUI

struct RecentWorkDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(WorkService.self) private var workService
    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private let rowLimit = 6

    private var recent: [WorkRecord] {
        workService.recentRecords(limit: rowLimit)
    }

    var body: some View {
        DashboardCard(id: .recentWork, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if recent.isEmpty {
                DashboardEmptyMessage(text: "No recent work")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(recent) { record in
                        DashboardCardTapButton {
                            if let treeID = record.treeIDs.first {
                                appState.showTreeFromMap(treeID: treeID)
                            }
                        } label: {
                            DashboardMetricRow(
                                title: workTitle(for: record),
                                detail: [treeNames(for: record), relativeDay(record.performedAt)]
                                    .filter { !$0.isEmpty }
                                    .joined(separator: " · "),
                                compact: true
                            )
                        }
                    }
                }
            }
        }
    }

    private func workTitle(for record: WorkRecord) -> String {
        workService.workType(id: record.workTypeID)?.name ?? "Work"
    }

    private func treeNames(for record: WorkRecord) -> String {
        let names = record.treeIDs.compactMap { treeService.getTree(id: $0)?.bonsaiName }
        if names.isEmpty { return "" }
        return names.joined(separator: ", ")
    }

    private func relativeDay(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
