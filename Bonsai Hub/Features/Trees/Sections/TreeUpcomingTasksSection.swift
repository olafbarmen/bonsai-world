//
//  TreeUpcomingTasksSection.swift
//  Bonsai World
//
//  Tree Detail — Tasks card in the notes column. Overdue first (care that can
//  still be done late), then Upcoming. Missed watering never appears under
//  Overdue (`expiresIfMissed`). Compact rows; tap opens TaskDetailSheet.
//

import SwiftUI

struct TreeUpcomingTasksSection: View {
    let treeID: UUID

    @Environment(TaskService.self) private var taskService
    @State private var detailOccurrence: TaskOccurrence?
    @State private var completingTask: CareTask?
    @State private var errorMessage: String?
    @State private var isWateringExpanded = false

    private var overdue: [TaskOccurrence] {
        taskService.pendingOccurrences(due: .overdue)
            .filter { $0.treeID == treeID }
            .sorted { $0.dueDate < $1.dueDate }
    }

    private var upcoming: [TaskOccurrence] {
        let overdueIDs = Set(overdue.map(\.id))
        return taskService.pendingOccurrences(forTree: treeID)
            .filter { !overdueIDs.contains($0.id) }
            .sorted { $0.dueDate < $1.dueDate }
    }

    private var upcomingWatering: [TaskOccurrence] {
        upcoming.filter { taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
    }

    private var upcomingOther: [TaskOccurrence] {
        upcoming.filter { !taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
    }

    var body: some View {
        DetailCard(title: "Tasks") {
            if overdue.isEmpty, upcoming.isEmpty {
                Text("Nothing planned.")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    if !overdue.isEmpty {
                        taskGroup(title: "Overdue", occurrences: overdue, emphasize: true)
                    }
                    if !upcomingOther.isEmpty || !upcomingWatering.isEmpty {
                        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                            Text("UPCOMING")
                                .font(FaloCardTypography.sectionTitle)
                                .tracking(FaloCardTypography.sectionTitleTracking)
                                .foregroundStyle(.secondary)

                            if !upcomingOther.isEmpty {
                                occurrenceStack(upcomingOther, emphasize: false)
                            }

                            if !upcomingWatering.isEmpty {
                                DisclosureGroup(isExpanded: $isWateringExpanded) {
                                    occurrenceStack(upcomingWatering, emphasize: false)
                                } label: {
                                    HStack(spacing: FaloSpacing.xSmall) {
                                        Text("Watering")
                                            .font(FaloCardTypography.fieldValue)
                                        Text("\(upcomingWatering.count)")
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .tint(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $detailOccurrence) { occurrence in
            TaskDetailSheet(occurrence: occurrence, onComplete: { attemptComplete(occurrence) })
        }
        .sheet(item: $completingTask) { task in
            if let taskTreeID = task.treeIDs.first {
                AddWorkSheet(treeID: taskTreeID, initialWorkTypeID: task.workTypeID, scheduleID: task.id) { record in
                    try? taskService.completeTask(task, resultingWorkRecordID: record.id)
                }
            }
        }
        .alert(
            "Couldn't Complete Task",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { isPresented in if !isPresented { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func taskGroup(title: String, occurrences: [TaskOccurrence], emphasize: Bool) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title.uppercased())
                .font(FaloCardTypography.sectionTitle)
                .tracking(FaloCardTypography.sectionTitleTracking)
                .foregroundStyle(emphasize ? Color.orange : .secondary)

            VStack(spacing: 0) {
                occurrenceStack(occurrences, emphasize: emphasize)
            }
        }
    }

    private func occurrenceStack(_ occurrences: [TaskOccurrence], emphasize: Bool) -> some View {
        VStack(spacing: 0) {
            ForEach(occurrences) { occurrence in
                TreeTaskRow(
                    occurrence: occurrence,
                    emphasizeDate: emphasize,
                    onTap: { detailOccurrence = occurrence }
                )
                if occurrence.id != occurrences.last?.id {
                    Divider()
                }
            }
        }
    }

    private func attemptComplete(_ occurrence: TaskOccurrence) {
        guard occurrence.isInstant else {
            if case .task(let task) = occurrence.source {
                completingTask = task
            }
            return
        }
        do {
            _ = try taskService.completeOccurrenceInstantly(occurrence)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct TreeTaskRow: View {
    let occurrence: TaskOccurrence
    let emphasizeDate: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                if occurrence.isRecurring {
                    Image(systemName: "repeat")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
                Text(occurrence.title)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(occurrence.dueDate, style: .date)
                    .font(FaloTypography.caption)
                    .foregroundStyle(emphasizeDate ? Color.orange : .secondary)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, FaloSpacing.xSmall)
    }
}
