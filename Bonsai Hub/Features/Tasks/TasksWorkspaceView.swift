//
//  TasksWorkspaceView.swift
//  Bonsai World
//
//  Tasks workspace — real, persisted CareTasks merged with computed due
//  occurrences of recurring CareSchedules, grouped by horizon. Schedule
//  occurrences always complete in one action (every detail was fixed when
//  the Schedule was created); one-off Tasks follow Blueprint §5.9 — instant
//  for routine, high-frequency Work Types, full Add Work form otherwise.
//
//  Every completion (single or bulk) surfaces a dismissible Undo banner
//  rather than completing silently or forcing a modal dialog — deleting the
//  WorkRecord(s) it wrote is enough to reverse it (see
//  `TaskService.undoCompletion(_:)`).
//

import SwiftUI

struct TasksWorkspaceView: View {
    let horizon: TasksHorizon

    @Environment(TaskService.self) private var taskService
    @State private var isAddTaskPresented = false
    @State private var isManageSchedulesPresented = false
    @State private var completingTask: CareTask?
    @State private var detailOccurrence: TaskOccurrence?
    @State private var errorMessage: String?
    @State private var completionOutcome: CompletionOutcome?

    private struct CompletionOutcome: Identifiable {
        let id = UUID()
        let message: String
        let results: [TaskService.OccurrenceCompletionResult]
    }

    private var occurrences: [TaskOccurrence] {
        taskService.pendingOccurrences(due: horizon)
    }

    var body: some View {
        FaloAdaptiveDesktopWorkspace(profile: .dashboard) {
            TasksWorkspaceContent(
                horizon: horizon,
                occurrences: occurrences,
                onComplete: attemptComplete,
                onOpenDetail: { detailOccurrence = $0 }
            )
        }
        .background(.windowBackground)
        .navigationTitle(horizon.title)
        .toolbar {
            ToolbarItem {
                Button {
                    isManageSchedulesPresented = true
                } label: {
                    Label("Manage Schedules", systemImage: "repeat")
                }
                .labelStyle(.titleAndIcon)
                .help("View, pause, or delete recurring schedules")
            }
            ToolbarItem {
                Button {
                    completeAllInstantly()
                } label: {
                    Label("Complete All", systemImage: "checkmark.circle")
                }
                .labelStyle(.titleAndIcon)
                .help("Complete every task due \(horizon.title.lowercased()) that doesn't need details")
                .disabled(occurrences.isEmpty)
            }
            ToolbarItem {
                Button {
                    isAddTaskPresented = true
                } label: {
                    Label("New Task", systemImage: "plus")
                }
                .labelStyle(.titleAndIcon)
                .help("Schedule a new task")
            }
        }
        .sheet(isPresented: $isAddTaskPresented) {
            AddTaskSheet()
        }
        .sheet(isPresented: $isManageSchedulesPresented) {
            SchedulesListSheet()
        }
        .sheet(item: $completingTask) { task in
            if let treeID = task.treeIDs.first {
                AddWorkSheet(treeID: treeID, initialWorkTypeID: task.workTypeID, scheduleID: task.id) { record in
                    try? taskService.completeTask(task, resultingWorkRecordID: record.id)
                }
            }
        }
        .sheet(item: $detailOccurrence) { occurrence in
            TaskDetailSheet(occurrence: occurrence, onComplete: { attemptComplete(occurrence) })
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
        .overlay(alignment: .bottom) {
            if let outcome = completionOutcome {
                UndoBannerView(
                    message: outcome.message,
                    onUndo: {
                        for result in outcome.results {
                            taskService.undoCompletion(result)
                        }
                        completionOutcome = nil
                    },
                    onDismiss: { completionOutcome = nil }
                )
                .padding(FaloSpacing.large)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .task(id: outcome.id) {
                    try? await Task.sleep(for: .seconds(8))
                    if completionOutcome?.id == outcome.id {
                        completionOutcome = nil
                    }
                }
            }
        }
        .animation(.default, value: completionOutcome?.id)
    }

    private func attemptComplete(_ occurrence: TaskOccurrence) {
        guard occurrence.isInstant else {
            if case .task(let task) = occurrence.source {
                completingTask = task
            }
            return
        }
        do {
            let result = try taskService.completeOccurrenceInstantly(occurrence)
            completionOutcome = CompletionOutcome(message: completionMessage(for: result), results: [result])
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// "Completed X." for a one-off Task, or — for a recurring Schedule —
    /// "Completed X. Next due …" so completing just this occurrence never
    /// reads as cancelling the whole rule; it only pushes the next due date
    /// forward by the recurrence interval.
    private func completionMessage(for result: TaskService.OccurrenceCompletionResult) -> String {
        guard let nextDueDate = result.nextDueDate else {
            return "Completed “\(result.occurrenceTitle)”."
        }
        let dateText = nextDueDate.formatted(date: .abbreviated, time: .omitted)
        if let dayPart = result.nextDueDayPart {
            return "Completed “\(result.occurrenceTitle)”. Next due \(dayPart.title.lowercased()), \(dateText)."
        }
        return "Completed “\(result.occurrenceTitle)”. Next due \(dateText)."
    }

    private func completeAllInstantly() {
        let instantOccurrences = occurrences.filter(\.isInstant)
        let skipped = occurrences.count - instantOccurrences.count

        var results: [TaskService.OccurrenceCompletionResult] = []
        for occurrence in instantOccurrences {
            if let result = try? taskService.completeOccurrenceInstantly(occurrence) {
                results.append(result)
            }
        }

        let message: String
        if let onlyResult = results.first, results.count == 1, skipped == 0 {
            message = completionMessage(for: onlyResult)
        } else if skipped > 0 {
            message = "Completed \(results.count) of \(occurrences.count) — \(skipped) need\(skipped == 1 ? "s" : "") details. Use Complete… to finish \(skipped == 1 ? "it" : "them")."
        } else {
            message = "Completed \(results.count) task\(results.count == 1 ? "" : "s")."
        }
        completionOutcome = CompletionOutcome(message: message, results: results)
    }
}

// MARK: - Undo banner

private struct UndoBannerView: View {
    let message: String
    let onUndo: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: FaloSpacing.medium) {
            Text(message)
                .font(FaloTypography.body)
                .foregroundStyle(.primary)

            Spacer(minLength: FaloSpacing.medium)

            Button("Undo", action: onUndo)
                .buttonStyle(.borderless)
                .fontWeight(.semibold)

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Dismiss")
        }
        .padding(.horizontal, FaloSpacing.large)
        .padding(.vertical, FaloSpacing.medium)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .strokeBorder(.separator)
        )
        .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
        .frame(maxWidth: 480)
    }
}

// MARK: - Adaptive content

private struct TasksWorkspaceContent: View {
    let horizon: TasksHorizon
    let occurrences: [TaskOccurrence]
    let onComplete: (TaskOccurrence) -> Void
    let onOpenDetail: (TaskOccurrence) -> Void

    @Environment(TaskService.self) private var taskService
    @Environment(TreeService.self) private var treeService
    @Environment(\.faloAdaptiveContentWidth) private var contentWidth
    @State private var isWateringExpanded = false

    private var wateringOccurrences: [TaskOccurrence] {
        occurrences
            .filter { taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
            .sorted(by: sortByTreeNameThenDueDate)
    }

    private var otherOccurrences: [TaskOccurrence] {
        occurrences.filter { !taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            Text(horizon == .overdue ? "Overdue Tasks" : "Pending Tasks")
                .font(FaloTypography.headline)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if horizon == .overdue, !occurrences.isEmpty {
                Text("These still need doing — watering that was missed is not listed here (it cannot be done late).")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.orange)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, FaloSpacing.xSmall)
            }

            if occurrences.isEmpty {
                Text(horizon == .overdue ? "Nothing overdue." : "Nothing due.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, FaloSpacing.medium)
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    if !otherOccurrences.isEmpty {
                        occurrenceList(otherOccurrences)
                    }

                    if !wateringOccurrences.isEmpty {
                        DisclosureGroup(isExpanded: $isWateringExpanded) {
                            occurrenceList(wateringOccurrences)
                                .padding(.top, FaloSpacing.xSmall)
                        } label: {
                            HStack(spacing: FaloSpacing.xSmall) {
                                Image(systemName: "drop")
                                    .foregroundStyle(.secondary)
                                Text("Watering")
                                    .font(FaloTypography.body)
                                    .foregroundStyle(.primary)
                                Text("\(wateringOccurrences.count)")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 1)
                                    .background(Capsule().fill(Color.secondary.opacity(0.7)))
                            }
                        }
                        .tint(.secondary)
                    }
                }
            }
        }
        .padding(DashboardSpacing.cardPadding)
        .frame(width: contentWidth, alignment: .topLeading)
        .dashboardCardChrome()
    }

    private func occurrenceList(_ items: [TaskOccurrence]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items) { occurrence in
                TaskRowView(
                    occurrence: occurrence,
                    workTypeName: taskService.workType(id: occurrence.workTypeID)?.name ?? "Task",
                    treeName: treeName(for: occurrence.treeID),
                    onComplete: { onComplete(occurrence) },
                    onOpenDetail: { onOpenDetail(occurrence) }
                )

                if occurrence.id != items.last?.id {
                    Divider()
                }
            }
        }
    }

    private func treeName(for treeID: UUID) -> String {
        treeService.trees.first { $0.id == treeID }?.bonsaiName ?? "—"
    }

    private func sortByTreeNameThenDueDate(_ lhs: TaskOccurrence, _ rhs: TaskOccurrence) -> Bool {
        let left = treeName(for: lhs.treeID)
        let right = treeName(for: rhs.treeID)
        let nameOrder = left.localizedStandardCompare(right)
        if nameOrder != .orderedSame { return nameOrder == .orderedAscending }
        return lhs.dueDate < rhs.dueDate
    }
}

#Preview("Today") {
    NavigationStack {
        TasksWorkspaceView(horizon: .today)
    }
    .frame(width: 1100, height: 720)
}
