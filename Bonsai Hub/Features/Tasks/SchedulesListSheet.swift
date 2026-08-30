//
//  SchedulesListSheet.swift
//  Bonsai World
//
//  Manage recurring CareSchedules — pause/resume or delete. Editing a
//  schedule's cadence isn't supported yet; delete and recreate via
//  AddTaskSheet's "Repeats" toggle instead.
//

import SwiftUI

struct SchedulesListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService

    private var schedules: [CareSchedule] {
        taskService.schedules.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
    }

    var body: some View {
        NavigationStack {
            Group {
                if schedules.isEmpty {
                    ContentUnavailableView(
                        "No Recurring Schedules",
                        systemImage: "repeat",
                        description: Text("Turn on Repeats when creating a Task to set one up.")
                    )
                } else {
                    List {
                        ForEach(schedules) { schedule in
                            ScheduleRowView(
                                schedule: schedule,
                                workTypeName: taskService.workType(id: schedule.workTypeID)?.name ?? "Task",
                                targetSummary: taskService.targetDescription(schedule.target),
                                onToggleActive: { isActive in
                                    try? taskService.setSchedule(schedule.id, isActive: isActive)
                                },
                                onDelete: {
                                    try? taskService.deleteSchedule(id: schedule.id)
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Recurring Schedules")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(minWidth: 480, minHeight: 420)
    }
}
