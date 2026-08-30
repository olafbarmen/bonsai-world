//
//  AddTaskSheet.swift
//  Bonsai World
//
//  Creates a planned CareTask (one-off) or a recurring CareSchedule — Work
//  Type, target (specific tree(s), a whole Location, or a whole Genus), and
//  either a single due date or a repeat cadence (+ optional season). A
//  recurring schedule fixes every detail (including fertilizer, when
//  relevant) up front, so its due occurrences always complete in one action
//  later — see TaskService.pendingOccurrences(due:).
//
//  Location/Genus targets stay dynamic for Schedules (re-resolved to
//  whichever Trees currently match each time occurrences are computed), but
//  are resolved once, immediately, for one-off Tasks.
//

import SwiftUI

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var referenceDataManager
    @Environment(BotanicalService.self) private var botanicalService

    /// Preselects a tree when opened from Tree Detail; otherwise the grower picks a target.
    var preselectedTreeID: UUID?
    var onSave: (CareTask) -> Void = { _ in }

    @State private var title: String = ""
    @State private var workTypeID: UUID?
    @State private var dueDate: Date = .now
    @State private var notes: String = ""
    @State private var fertilizerTypeID: UUID?
    @State private var newFertilizerDraft: FertilizerTypeDraft?
    @State private var errorMessage: String?

    private enum TargetMode: String, CaseIterable, Identifiable {
        case trees
        case location
        case genus

        var id: Self { self }

        var title: String {
            switch self {
            case .trees: "Trees"
            case .location: "Location"
            case .genus: "Genus"
            }
        }
    }

    @State private var targetMode: TargetMode = .trees
    @State private var selectedTreeIDs: Set<UUID> = []
    @State private var selectedLocationID: UUID?
    @State private var selectedGenusID: UUID?

    private enum RepeatMode: String, CaseIterable, Identifiable {
        case interval
        case multipleTimesPerDay

        var id: Self { self }

        var title: String {
            switch self {
            case .interval: "Every…"
            case .multipleTimesPerDay: "Multiple times a day"
            }
        }
    }

    @State private var isRecurring = false
    @State private var repeatMode: RepeatMode = .interval
    @State private var recurrenceUnit: CareRecurrenceUnit = .day
    @State private var recurrenceInterval = 1
    @State private var selectedDayParts: Set<CareDayPart> = []
    @State private var hasSeasonalWindow = false
    @State private var seasonFromMonth = 1
    @State private var seasonToMonth = 12

    private var selectedWorkType: WorkType? {
        workTypeID.flatMap { taskService.workType(id: $0) }
    }

    private var requiresFertilizer: Bool {
        selectedWorkType?.behaviour.requiresFertilizer ?? false
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// The target as the grower currently has it configured. `nil` when incomplete.
    private var currentTarget: CareScheduleTarget? {
        switch targetMode {
        case .trees:
            return selectedTreeIDs.isEmpty ? nil : .trees(selectedTreeIDs)
        case .location:
            return selectedLocationID.map(CareScheduleTarget.location)
        case .genus:
            return selectedGenusID.map(CareScheduleTarget.genus)
        }
    }

    private var canSave: Bool {
        guard workTypeID != nil, currentTarget != nil else { return false }
        if isRecurring, repeatMode == .multipleTimesPerDay {
            return !selectedDayParts.isEmpty
        }
        return true
    }

    init(preselectedTreeID: UUID? = nil, onSave: @escaping (CareTask) -> Void = { _ in }) {
        self.preselectedTreeID = preselectedTreeID
        self.onSave = onSave
        _selectedTreeIDs = State(initialValue: preselectedTreeID.map { [$0] } ?? [])
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section {
                    Picker("Work Type", selection: $workTypeID) {
                        Text("Choose…").tag(UUID?.none)
                        ForEach(WorkTypeCategory.allCases) { category in
                            let types = taskService.workTypes(in: category)
                            if !types.isEmpty {
                                Section(category.title) {
                                    ForEach(types) { type in
                                        Text(type.name).tag(Optional(type.id))
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: workTypeID) { _, newValue in
                        guard trimmedTitle.isEmpty, let newValue else { return }
                        title = taskService.workType(id: newValue)?.name ?? ""
                    }

                    if requiresFertilizer {
                        HStack {
                            Picker("Fertilizer", selection: $fertilizerTypeID) {
                                Text("Choose…").tag(UUID?.none)
                                ForEach(referenceData.fertilizerTypes) { fertilizer in
                                    Text("\(fertilizer.name) — \(fertilizer.classificationSummary)")
                                        .tag(Optional(fertilizer.id))
                                }
                            }

                            Button {
                                newFertilizerDraft = referenceDataManager.blankFertilizerTypeDraft()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .buttonStyle(.borderless)
                            .help("Add a new fertilizer product")
                        }
                    }
                }

                if preselectedTreeID == nil {
                    Section {
                        Picker("Applies to", selection: $targetMode) {
                            ForEach(TargetMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()

                        switch targetMode {
                        case .trees:
                            treeMultiSelect
                        case .location:
                            Picker("Location", selection: $selectedLocationID) {
                                Text("Choose…").tag(UUID?.none)
                                ForEach(referenceData.locations) { location in
                                    Text(location.name).tag(Optional(location.id))
                                }
                            }
                        case .genus:
                            Picker("Genus", selection: $selectedGenusID) {
                                Text("Choose…").tag(UUID?.none)
                                ForEach(botanicalService.genera()) { genus in
                                    Text(genus.name).tag(Optional(genus.id))
                                }
                            }
                        }
                    } header: {
                        Text("Applies to")
                    } footer: {
                        switch targetMode {
                        case .trees:
                            Text("\(selectedTreeIDs.count) tree\(selectedTreeIDs.count == 1 ? "" : "s") selected.")
                        case .location:
                            Text("Every tree at this Location — now, and any added later.")
                        case .genus:
                            Text("Every tree of this Genus — now, and any added later.")
                        }
                    }
                }

                Section("Title") {
                    TextField("Task title", text: $title)
                }

                Section {
                    Toggle("Repeats", isOn: $isRecurring.animation())

                    if isRecurring {
                        Picker("Repeat mode", selection: $repeatMode) {
                            ForEach(RepeatMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()

                        switch repeatMode {
                        case .interval:
                            Stepper(value: $recurrenceInterval, in: 1...99) {
                                Text("Every \(recurrenceInterval) \((recurrenceInterval == 1 ? recurrenceUnit.singular : recurrenceUnit.plural).lowercased())")
                            }

                            Picker("Unit", selection: $recurrenceUnit) {
                                ForEach(CareRecurrenceUnit.allCases) { unit in
                                    Text(unit.plural).tag(unit)
                                }
                            }
                            .labelsHidden()

                        case .multipleTimesPerDay:
                            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                                Text("Which times of day?")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(CareDayPart.allCases) { part in
                                    Toggle(part.title, isOn: Binding(
                                        get: { selectedDayParts.contains(part) },
                                        set: { isOn in
                                            if isOn { selectedDayParts.insert(part) } else { selectedDayParts.remove(part) }
                                        }
                                    ))
                                }
                            }
                        }

                        Toggle("Limit to a season", isOn: $hasSeasonalWindow.animation())

                        if hasSeasonalWindow {
                            Picker("From", selection: $seasonFromMonth) {
                                ForEach(CareScheduleSeasonalWindow.allMonths, id: \.self) { month in
                                    Text(CareScheduleSeasonalWindow.monthName(month)).tag(month)
                                }
                            }
                            Picker("To", selection: $seasonToMonth) {
                                ForEach(CareScheduleSeasonalWindow.allMonths, id: \.self) { month in
                                    Text(CareScheduleSeasonalWindow.monthName(month)).tag(month)
                                }
                            }
                        }
                    } else {
                        DatePicker("Due", selection: $dueDate, displayedComponents: [.date])
                    }
                } header: {
                    Text("Scheduling")
                } footer: {
                    if isRecurring {
                        Text("This becomes a recurring rule instead of a single task — every future occurrence completes in one action. A Tree covered by more than one active rule at the same time is never double-counted.")
                    }
                }

                Section("Notes") {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .formStyle(.grouped)

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button(isRecurring ? "Save Schedule" : "Save Task") { save() }
                    .keyboardShortcut(.defaultAction)
                    .buttonStyle(.borderedProminent)
                    .disabled(!canSave)
            }
            .padding(FaloSpacing.xLarge)
        }
        .frame(minWidth: 460, minHeight: 520)
        .navigationTitle(isRecurring ? "New Schedule" : "New Task")
        .sheet(item: $newFertilizerDraft) { draft in
            FertilizerTypeEditorSheet(draft: draft) { created in
                fertilizerTypeID = created.id
            }
        }
    }

    /// Scrollable checklist of every Tree — lets a grower pick "all my Acer" or
    /// "this tree and that tree" without leaving the sheet.
    private var treeMultiSelect: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(treeService.treesInCare.sorted { $0.bonsaiName.localizedStandardCompare($1.bonsaiName) == .orderedAscending }) { tree in
                    Button {
                        if selectedTreeIDs.contains(tree.id) {
                            selectedTreeIDs.remove(tree.id)
                        } else {
                            selectedTreeIDs.insert(tree.id)
                        }
                    } label: {
                        HStack(alignment: .center, spacing: FaloSpacing.medium) {
                            Image(systemName: selectedTreeIDs.contains(tree.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(selectedTreeIDs.contains(tree.id) ? Color.accentColor : .secondary)
                            TreeListThumbnail(imageID: tree.listImageID)
                            Text(tree.bonsaiName)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(height: 160)
    }

    private func save() {
        guard let workTypeID, let target = currentTarget else { return }
        let resolvedTitle = trimmedTitle.isEmpty
            ? (taskService.workType(id: workTypeID)?.name ?? "Task")
            : trimmedTitle

        if isRecurring {
            let recurrence = repeatMode == .multipleTimesPerDay
                ? CareRecurrenceRule(unit: .day, interval: 1, dayParts: selectedDayParts)
                : CareRecurrenceRule(unit: recurrenceUnit, interval: recurrenceInterval)
            do {
                _ = try taskService.createSchedule(
                    title: resolvedTitle,
                    workTypeID: workTypeID,
                    target: target,
                    recurrence: recurrence,
                    seasonalWindow: hasSeasonalWindow
                        ? CareScheduleSeasonalWindow(fromMonth: seasonFromMonth, toMonth: seasonToMonth)
                        : nil,
                    fertilizerTypeID: requiresFertilizer ? fertilizerTypeID : nil,
                    notes: notes
                )
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            return
        }

        do {
            let task = try taskService.createTask(
                title: resolvedTitle,
                workTypeID: workTypeID,
                treeIDs: taskService.resolvedTreeIDs(for: target),
                dueDate: dueDate,
                notes: notes
            )
            onSave(task)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
