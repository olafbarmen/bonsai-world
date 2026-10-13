//
//  TaskDetailSheet.swift
//  Bonsai World
//
//  Full detail for one TaskOccurrence — tapped from the Tasks workspace or a
//  Tree's "Upcoming Tasks" card. Shows the complete instructions (not
//  truncated the way a list row is), what it applies to, its cadence when
//  recurring, and a shortcut to the Tree it's for. Edit / Delete open from
//  here (core fields only). Complete reuses the same instant/form-required
//  path as the row it was opened from.
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
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(NurseryPropagationService.self) private var nurseryPropagationService
    @Environment(WinterCareService.self) private var winterCare
    @Environment(WeatherService.self) private var weatherService
    @Environment(AppState.self) private var appState

    @State private var editSubject: EditTaskSheet.Subject?
    @State private var editChecklistTreeID: UUID?
    @State private var confirmDelete = false
    @State private var checklistError: String?

    private var workType: WorkType? {
        taskService.workType(id: occurrence.workTypeID)
    }

    private var schedule: CareSchedule? {
        guard case .schedule(let scheduleID) = occurrence.source else { return nil }
        return taskService.schedules.first { $0.id == scheduleID }
    }

    private var oneOffTask: CareTask? {
        guard case .task(let task) = occurrence.source else { return nil }
        return taskService.tasks.first { $0.id == task.id } ?? task
    }

    private var notes: String {
        let raw = schedule?.notes ?? oneOffTask?.notes ?? ""
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var tree: Tree? {
        guard let treeID = occurrence.treeID else { return nil }
        return treeService.getTree(id: treeID)
    }

    private var seedBatch: SeedBatch? {
        guard let seedBatchID = occurrence.seedBatchID else { return nil }
        return seedBatchService.batch(id: seedBatchID)
    }

    private var yamadoriTrip: Yamadori? {
        guard let yamadoriID = occurrence.yamadoriID else { return nil }
        return yamadoriService.getYamadori(id: yamadoriID)
    }

    private var fieldTreeProject: NurseryPropagationProject? {
        guard let id = occurrence.nurseryPropagationProjectID else { return nil }
        return nurseryPropagationService.project(id: id)
    }

    /// Other trees this same one-off Task also covers, if any — a Task can
    /// target several trees at once even though this occurrence is for one.
    private var otherTreeNames: [String] {
        guard let oneOffTask, let treeID = occurrence.treeID, oneOffTask.treeIDs.count > 1 else { return [] }
        return oneOffTask.treeIDs
            .filter { $0 != treeID }
            .compactMap { treeService.getTree(id: $0)?.bonsaiName }
            .sorted()
    }

    private var canEditOrDelete: Bool {
        oneOffTask != nil || schedule != nil
    }

    /// Wire Removal follow-up from logging Wiring work — complete or reschedule.
    private var isWireCheckTask: Bool {
        if occurrence.workTypeID == CanonicalWorkTypeID.wireRemoval { return true }
        return workType?.name.caseInsensitiveCompare("Wire Removal") == .orderedSame
    }

    private var isWinterCareChecklist: Bool {
        oneOffTask?.systemKind == .winterCare && occurrence.treeID != nil
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
                    if occurrence.libraryInventoryKind == .soilStocktake {
                        HStack {
                            Text("Soil stock")
                            Spacer()
                            Button("Open Stocktake") {
                                dismiss()
                                appState.presentSoilStocktake()
                            }
                            .buttonStyle(.borderless)
                        }
                    } else if occurrence.seedBatchID != nil {
                        HStack {
                            if let seedBatch {
                                Text("\(seedBatch.botanicalName) · \(seedBatch.batchCode)")
                            } else {
                                Text("Seed Batch")
                            }
                            Spacer()
                            if let seedBatchID = occurrence.seedBatchID {
                                Button("Open Seed Batch") {
                                    dismiss()
                                    appState.showSeedBatch(batchID: seedBatchID)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    } else if occurrence.yamadoriID != nil {
                        HStack {
                            if let yamadoriTrip {
                                let name = yamadoriTrip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
                                Text(name.isEmpty ? "Yamadori" : name)
                            } else {
                                Text("Yamadori")
                            }
                            Spacer()
                            if let yamadoriID = occurrence.yamadoriID {
                                Button("Open Yamadori") {
                                    dismiss()
                                    appState.showYamadoriTrip(tripID: yamadoriID)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    } else if occurrence.nurseryPropagationProjectID != nil {
                        HStack {
                            if let fieldTreeProject {
                                Text("\(fieldTreeProject.botanicalName) · \(fieldTreeProject.projectCode)")
                            } else {
                                Text("Field Tree")
                            }
                            Spacer()
                            if let projectID = occurrence.nurseryPropagationProjectID {
                                Button("Open Field Tree") {
                                    dismiss()
                                    appState.showFieldTree(projectID: projectID)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                    } else {
                        HStack {
                            Text(tree?.bonsaiName ?? "Unknown tree")
                            Spacer()
                            if let treeID = occurrence.treeID {
                                Button("Open Tree") {
                                    dismiss()
                                    appState.showTreeFromMap(treeID: treeID)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
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

                if isWireCheckTask {
                    Section("Wire check") {
                        Text("Mark the wire as removed, or set a new date to check again.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                        Button("Wire removed…") {
                            onComplete()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        if canEditOrDelete {
                            Button("Set new check date…") {
                                presentEdit()
                            }
                        }
                    }
                }

                if isWinterCareChecklist, let treeID = occurrence.treeID {
                    WinterCareTreeChecklistSection(treeID: treeID)
                    if let checklistError {
                        Section {
                            Text(checklistError)
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.statusCritical)
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

                if !isWinterCareChecklist {
                    Section("Instructions") {
                        if notes.isEmpty {
                            Text("No additional instructions.")
                                .foregroundStyle(.secondary)
                        } else {
                            Text(notes)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Task Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                if canEditOrDelete {
                    ToolbarItem(placement: .automatic) {
                        Button("Edit") { presentEdit() }
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Delete", role: .destructive) {
                            confirmDelete = true
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(winterCareCompleteTitle) {
                        if isWinterCareChecklist {
                            completeWinterCareForThisTree()
                        } else {
                            onComplete()
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .confirmationDialog(
                schedule != nil ? "Delete this schedule?" : "Delete this task?",
                isPresented: $confirmDelete,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) { deleteSubject() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    schedule != nil
                        ? "Future recurring occurrences will stop. Past Work stays in history."
                        : "This planned task will be removed. Past Work stays in history."
                )
            }
            .sheet(item: $editSubject) { subject in
                EditTaskSheet(
                    subject: subject,
                    winterCareChecklistTreeID: editChecklistTreeID
                ) {
                    dismiss()
                }
            }
        }
        .frame(minWidth: 460, minHeight: 480)
    }

    private var winterCareCompleteTitle: String {
        if isWinterCareChecklist { return "Complete all steps" }
        return occurrence.isInstant ? "Complete" : "Complete…"
    }

    private func presentEdit() {
        editChecklistTreeID = isWinterCareChecklist ? occurrence.treeID : nil
        if let schedule {
            editSubject = .schedule(schedule)
        } else if let oneOffTask {
            editSubject = .task(oneOffTask)
        }
    }

    private func completeWinterCareForThisTree() {
        guard let treeID = occurrence.treeID else { return }
        do {
            try winterCare.markAllStepsDone(for: treeID, snapshot: weatherService.snapshot)
            checklistError = nil
            dismiss()
        } catch {
            checklistError = error.localizedDescription
        }
    }

    private func deleteSubject() {
        do {
            if let schedule {
                try taskService.deleteSchedule(id: schedule.id)
            } else if let oneOffTask {
                try taskService.deleteTask(id: oneOffTask.id)
            }
            dismiss()
        } catch {
            // Keep the sheet open; grower can retry or close.
        }
    }
}

extension EditTaskSheet.Subject: Identifiable {
    var id: UUID {
        switch self {
        case .task(let task): task.id
        case .schedule(let schedule): schedule.id
        }
    }
}
