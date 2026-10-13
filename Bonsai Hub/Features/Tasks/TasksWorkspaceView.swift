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

    @Environment(AppState.self) private var appState
    @Environment(TaskService.self) private var taskService
    @Environment(GreenhouseCareService.self) private var greenhouseCare
    @Environment(WinterCareService.self) private var winterCare
    @Environment(WeatherService.self) private var weatherService
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

    private var instantCompletableOccurrences: [TaskOccurrence] {
        occurrences.filter { $0.isInstant && $0.libraryInventoryKind == nil }
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
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(horizon.title)
        .onAppear {
            consumeWantsNewTask()
            consumeWantsManageSchedules()
            consumeWantsCompleteAll()
        }
        .onChange(of: appState.wantsNewTask) { _, wants in
            guard wants else { return }
            consumeWantsNewTask()
        }
        .onChange(of: appState.wantsManageSchedules) { _, wants in
            guard wants else { return }
            consumeWantsManageSchedules()
        }
        .onChange(of: appState.wantsCompleteAllTasks) { _, wants in
            guard wants else { return }
            consumeWantsCompleteAll()
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
                    _ = try? taskService.completeTask(task, resultingWorkRecordID: record.id)
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

    private func consumeWantsNewTask() {
        guard appState.wantsNewTask else { return }
        isAddTaskPresented = true
        appState.wantsNewTask = false
    }

    private func consumeWantsManageSchedules() {
        guard appState.wantsManageSchedules else { return }
        isManageSchedulesPresented = true
        appState.wantsManageSchedules = false
    }

    private func consumeWantsCompleteAll() {
        guard appState.wantsCompleteAllTasks else { return }
        appState.wantsCompleteAllTasks = false
        completeAllInstantly()
    }

    private func attemptComplete(_ occurrence: TaskOccurrence) {
        if occurrence.libraryInventoryKind == .soilStocktake {
            appState.presentSoilStocktake()
            return
        }
        if occurrence.isGreenhouseSpringCheck, case .task(let task) = occurrence.source {
            do {
                try greenhouseCare.completeCheck(for: task.locationIDs)
                completionOutcome = CompletionOutcome(
                    message: "Completed “\(occurrence.title)”.",
                    results: []
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            return
        }
        if case .task(let task) = occurrence.source,
           task.systemKind == .winterCare,
           let treeID = occurrence.treeID {
            do {
                try winterCare.markAllStepsDone(for: treeID, snapshot: weatherService.snapshot)
                completionOutcome = CompletionOutcome(
                    message: "Marked all Winter Care steps done for this tree.",
                    results: []
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            return
        }
        if let seedBatchID = occurrence.seedBatchID, !occurrence.isInstant {
            dismissDetailThen { appState.showSeedBatch(batchID: seedBatchID) }
            return
        }
        if let yamadoriID = occurrence.yamadoriID, !occurrence.isInstant {
            dismissDetailThen { appState.showYamadoriTrip(tripID: yamadoriID) }
            return
        }
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

    private func dismissDetailThen(_ action: @escaping () -> Void) {
        detailOccurrence = nil
        action()
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
        let instantOccurrences = instantCompletableOccurrences
        guard !instantOccurrences.isEmpty else { return }

        let skipped = occurrences.count - instantOccurrences.count

        var results: [TaskService.OccurrenceCompletionResult] = []
        var greenhouseCompleted = 0
        var winterCareCompleted = 0
        for occurrence in instantOccurrences {
            if occurrence.isGreenhouseSpringCheck, case .task(let task) = occurrence.source {
                if (try? greenhouseCare.completeCheck(for: task.locationIDs)) != nil {
                    greenhouseCompleted += 1
                }
                continue
            }
            if case .task(let task) = occurrence.source,
               task.systemKind == .winterCare,
               let treeID = occurrence.treeID {
                if (try? winterCare.markAllStepsDone(for: treeID, snapshot: weatherService.snapshot)) != nil {
                    winterCareCompleted += 1
                }
                continue
            }
            if let result = try? taskService.completeOccurrenceInstantly(occurrence) {
                results.append(result)
            }
        }
        let completedCount = results.count + greenhouseCompleted + winterCareCompleted

        let message: String
        if let onlyResult = results.first, completedCount == 1, skipped == 0 {
            message = completionMessage(for: onlyResult)
        } else if completedCount == 1, greenhouseCompleted == 1, skipped == 0 {
            message = "Completed “\(GreenhouseCareService.taskTitle)”."
        } else if completedCount == 1, winterCareCompleted == 1, skipped == 0 {
            message = "Marked all Winter Care steps done for this tree."
        } else if skipped > 0 {
            message = "Completed \(completedCount) of \(occurrences.count) — \(skipped) need\(skipped == 1 ? "s" : "") details. Use Complete… to finish \(skipped == 1 ? "it" : "them")."
        } else {
            message = "Completed \(completedCount) task\(completedCount == 1 ? "" : "s")."
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
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(NurseryPropagationService.self) private var nurseryPropagationService
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
                    .foregroundStyle(BonsaiWorldColors.statusAttention)
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
                    treeName: subjectName(for: occurrence),
                    onComplete: { onComplete(occurrence) },
                    onOpenDetail: { onOpenDetail(occurrence) }
                )

                if occurrence.id != items.last?.id {
                    Divider()
                }
            }
        }
    }

    private func subjectName(for occurrence: TaskOccurrence) -> String {
        if occurrence.libraryInventoryKind == .soilStocktake {
            return "Soil"
        }
        if let seedBatchID = occurrence.seedBatchID {
            if let batch = seedBatchService.batch(id: seedBatchID) {
                return "\(batch.botanicalName) · \(batch.batchCode)"
            }
            return "Seed Batch"
        }
        if let yamadoriID = occurrence.yamadoriID {
            if let trip = yamadoriService.getYamadori(id: yamadoriID) {
                let name = trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
                return name.isEmpty ? "Yamadori" : name
            }
            return "Yamadori"
        }
        if let projectID = occurrence.nurseryPropagationProjectID {
            if let project = nurseryPropagationService.project(id: projectID) {
                return "\(project.botanicalName) · \(project.projectCode)"
            }
            return "Field Tree"
        }
        guard let treeID = occurrence.treeID else { return "—" }
        return treeService.trees.first { $0.id == treeID }?.bonsaiName ?? "—"
    }

    private func sortByTreeNameThenDueDate(_ lhs: TaskOccurrence, _ rhs: TaskOccurrence) -> Bool {
        let left = subjectName(for: lhs)
        let right = subjectName(for: rhs)
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
