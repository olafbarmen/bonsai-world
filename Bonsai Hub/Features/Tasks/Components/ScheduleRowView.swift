//
//  ScheduleRowView.swift
//  Bonsai World
//
//  One CareSchedule row in the Manage Schedules list — cadence, season, tree(s),
//  an active toggle (pause/resume), and delete.
//

import SwiftUI

struct ScheduleRowView: View {
    let schedule: CareSchedule
    let workTypeName: String
    let targetSummary: String
    let onToggleActive: (Bool) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: 2) {
                Text(schedule.title)
                    .font(FaloTypography.body)
                Text("\(workTypeName) · \(targetSummary)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: FaloSpacing.xSmall) {
                    Text(schedule.recurrence.summary)
                    if let window = schedule.seasonalWindow {
                        Text("· \(window.summary)")
                    }
                }
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            }

            Spacer(minLength: FaloSpacing.medium)

            Toggle(
                "Active",
                isOn: Binding(
                    get: { schedule.isActive },
                    set: { onToggleActive($0) }
                )
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .controlSize(.small)
        }
        .padding(.vertical, FaloSpacing.small)
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive, action: onDelete)
        }
    }
}
