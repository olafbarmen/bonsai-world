//
//  SchedulesListSheet.swift
//  Bonsai World
//
//  Manage recurring CareSchedules — open a row to Edit details; pause/resume
//  or delete from the list.
//

import SwiftUI

struct SchedulesListSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService

    @State private var editSubject: EditTaskSheet.Subject?

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
                                onOpen: {
                                    editSubject = .schedule(schedule)
                                },
                                onToggleActive: { isActive in
                                    _ = try? taskService.setSchedule(schedule.id, isActive: isActive)
                                },
                                onDelete: {
                                    _ = try? taskService.deleteSchedule(id: schedule.id)
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
            .sheet(item: $editSubject) { subject in
                EditTaskSheet(subject: subject) {
                    editSubject = nil
                }
            }
        }
        .frame(minWidth: 480, minHeight: 420)
    }
}
