//
//  TaskDetailSheet.swift
//  Bonsai World
//
//  Full detail for one TaskOccurrence — tapped from the Tasks workspace or a
//  Tree's "Upcoming Tasks" card. Shows the complete instructions (not
//  truncated the way a list row is), what it applies to, its cadence when
//  recurring, and a shortcut to the Tree it's for. View-only for now — no
//  edit/delete yet; Complete reuses the same instant/form-required path as
//  the row it was opened from.
//

import SwiftUI

struct TaskDetailSheet: View {
    let occurrence: TaskOccurrence
    /// Same completion entry point as `TaskRowView` — dispatches to instant
    /// completion or opens the full Add Work form, depending on Work Type.
    var onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService
    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private var workType: WorkType? {
        taskService.workType(id: occurrence.workTypeID)
    }

    private var schedule: CareSchedule? {
        guard case .schedule(let scheduleID) = occurrence.source else { return nil }
        return taskService.schedules.first { $0.id == scheduleID }
    }

    private var oneOffTask: CareTask? {
        guard case .task(let task) = occurrence.source else { return nil }
        return task
    }

    private var notes: String {
        let raw = schedule?.notes ?? oneOffTask?.notes ?? ""
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var tree: Tree? {
        treeService.getTree(id: occurrence.treeID)
    }

    /// Other trees this same one-off Task also covers, if any — a Task can
    /// target several trees at once even though this occurrence is for one.
    private var otherTreeNames: [String] {
        guard let oneOffTask, oneOffTask.treeIDs.count > 1 else { return [] }
        return oneOffTask.treeIDs
            .filter { $0 != occurrence.treeID }
            .compactMap { treeService.getTree(id: $0)?.bonsaiName }
            .sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        HStack(spacing: FaloSpacing.xSmall) {
                            if occurrence.isRecurring {
                                Image(systemName: "repeat")
                                    .foregroundStyle(.secondary)
                            }
                            Text(occurrence.title)
                                .font(FaloTypography.headline)
                        }
                        if let workType {
                            Text("\(workType.name) · \(workType.category.title)")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                Section("Applies to") {
                    HStack {
                        Text(tree?.bonsaiName ?? "Unknown tree")
                        Spacer()
                        Button("Open Tree") {
                            dismiss()
                            appState.showTreeFromMap(treeID: occurrence.treeID)
                        }
                        .buttonStyle(.borderless)
                    }
                    if !otherTreeNames.isEmpty {
                        Text("Also applies to \(otherTreeNames.joined(separator: ", ")) — completing this finishes it for all of them at once.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    if let schedule {
                        Text(taskService.targetDescription(schedule.target))
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Due") {
                    LabeledContent("Date") {
                        Text(occurrence.dueDate, style: .date)
                    }
                    if let dayPart = occurrence.dayPart {
                        LabeledContent("Time of day") {
                            Text(dayPart.title)
                        }
                    }
                }

                if let schedule {
                    Section("Repeats") {
                        Text(schedule.recurrence.summary)
                        if let window = schedule.seasonalWindow {
                            Text("Active \(window.summary)")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Instructions") {
                    if notes.isEmpty {
                        Text("No additional instructions.")
                            .foregroundStyle(.secondary)
                    } else {
                        Text(notes)
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(occurrence.isInstant ? "Complete" : "Complete…") {
                        onComplete()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(minWidth: 460, minHeight: 480)
    }
}
