//
//  CareTodayView.swift
//  Bonsai World
//
//  Care → Today — due tasks overview.
//  Hidden from sidebar (Tasks → Today owns the day list). Route kept for deep links.
//

import SwiftUI

struct CareTodayView: View {
    @Environment(TaskService.self) private var taskService

    private var dueToday: [TaskOccurrence] {
        taskService.pendingOccurrences(due: .today)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Today")
                        .font(FaloTypography.headline)
                    CareHonestyLine(text: CareHonesty.todayTrackingLine)
                    Text("\(dueToday.count) tasks due today")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: "Due Today") {
                    if dueToday.isEmpty {
                        Text("Nothing due today.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(dueToday) { occurrence in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(occurrence.title)
                                    .font(FaloCardTypography.fieldValue)
                                Text(occurrence.dueDate.formatted(date: .abbreviated, time: .shortened))
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Today")
    }
}
