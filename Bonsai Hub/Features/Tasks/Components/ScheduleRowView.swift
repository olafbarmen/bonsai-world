//
//  ScheduleRowView.swift
//  Bonsai World
//
//  One CareSchedule row in the Manage Schedules list — tap to Edit; cadence,
//  season, tree(s), active toggle (pause/resume), and delete.
//

import SwiftUI

struct ScheduleRowView: View {
    let schedule: CareSchedule
    let workTypeName: String
    let targetSummary: String
    let onOpen: () -> Void
    let onToggleActive: (Bool) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Button(action: onOpen) {
                HStack(alignment: .top, spacing: FaloSpacing.small) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(schedule.title)
                            .font(FaloTypography.body)
                            .foregroundStyle(.primary)
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
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

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
        .contextMenu {
            Button("Edit…", action: onOpen)
            Button("Delete", role: .destructive, action: onDelete)
        }
    }
}
