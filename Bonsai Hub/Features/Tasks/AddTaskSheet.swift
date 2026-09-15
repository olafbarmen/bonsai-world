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
    @Environment(ImageService.self) private var imageService
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(NurseryPropagationService.self) private var nurseryPropagationService

    /// Preselects a tree when opened from Tree Detail; otherwise the grower picks a target.
    var preselectedTreeID: UUID?
    var preselectedShapingAreaID: ShapingAreaID?
    /// Prefills Work Type (e.g. Care → Fertilizing → Add Task).
    var preselectedWorkTypeID: UUID?
    /// Preselects a Field Tree / Propagation project (from Field Tree detail).
    var preselectedNurseryPropagationProjectID: UUID?
    var prefillTitle: String?
    var prefillNotes: String?
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
        case yamadori
        case seedBatch
        case fieldTree

        var id: Self { self }

        var title: String {
            switch self {
            case .trees: "Trees"
            case .location: "Location"
            case .genus: "Genus"
            case .yamadori: "Yamadori"
            case .seedBatch: "Seed Batch"
            case .fieldTree: "Field Tree"
            }
        }

        var allowsRecurring: Bool {
            switch self {
            case .trees, .location, .genus: true
            case .yamadori, .seedBatch, .fieldTree: false
            }
        }
    }

    @State private var targetMode: TargetMode = .trees
    @State private var selectedTreeIDs: Set<UUID> = []
    @State private var selectedLocationID: UUID?
    @State private var selectedGenusID: UUID?
    @State private var selectedYamadoriIDs: Set<UUID> = []
    @State private var selectedSeedBatchIDs: Set<UUID> = []
    @State private var selectedNurseryPropagationProjectIDs: Set<UUID> = []

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
    /// Only tree / location / genus targets can become Schedules.
    private var currentScheduleTarget: CareScheduleTarget? {
        switch targetMode {
        case .trees:
            return selectedTreeIDs.isEmpty ? nil : .trees(selectedTreeIDs)
        case .location:
            return selectedLocationID.map(CareScheduleTarget.location)
        case .genus:
            return selectedGenusID.map(CareScheduleTarget.genus)
        case .yamadori, .seedBatch, .fieldTree:
            return nil
        }
    }

    private var hasNurseryTargets: Bool {
        switch targetMode {
        case .yamadori: !selectedYamadoriIDs.isEmpty
        case .seedBatch: !selectedSeedBatchIDs.isEmpty
        case .fieldTree: !selectedNurseryPropagationProjectIDs.isEmpty
        default: false
        }
    }

    private var canSave: Bool {
        guard workTypeID != nil else { return false }
        if targetMode.allowsRecurring {
            guard currentScheduleTarget != nil else { return false }
        } else {
            guard hasNurseryTargets else { return false }
        }
        if isRecurring, repeatMode == .multipleTimesPerDay {
            return !selectedDayParts.isEmpty
        }
        return true
    }

    init(
        preselectedTreeID: UUID? = nil,
        preselectedShapingAreaID: ShapingAreaID? = nil,
        preselectedWorkTypeID: UUID? = nil,
        preselectedNurseryPropagationProjectID: UUID? = nil,
        prefillTitle: String? = nil,
        prefillNotes: String? = nil,
        onSave: @escaping (CareTask) -> Void = { _ in }
    ) {
        self.preselectedTreeID = preselectedTreeID
        self.preselectedShapingAreaID = preselectedShapingAreaID
        self.preselectedWorkTypeID = preselectedWorkTypeID
        self.preselectedNurseryPropagationProjectID = preselectedNurseryPropagationProjectID
        self.prefillTitle = prefillTitle
        self.prefillNotes = prefillNotes
        self.onSave = onSave
        _selectedTreeIDs = State(initialValue: preselectedTreeID.map { [$0] } ?? [])
        _selectedNurseryPropagationProjectIDs = State(
            initialValue: preselectedNurseryPropagationProjectID.map { [$0] } ?? []
        )
        _targetMode = State(
            initialValue: preselectedNurseryPropagationProjectID != nil ? .fieldTree : .trees
        )
        _workTypeID = State(initialValue: preselectedWorkTypeID)
        let trimmedPrefillTitle = prefillTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        _title = State(
            initialValue: trimmedPrefillTitle.isEmpty
                ? ""
                : trimmedPrefillTitle
        )
        _notes = State(initialValue: prefillNotes ?? "")
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
                                    Text("\(fertilizer.displayName) — \(fertilizer.classificationSummary)")
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

                if preselectedShapingAreaID != nil {
                    Section("Shaping Area") {
                        Text(preselectedShapingAreaID?.title ?? "")
                    }
                }

                if preselectedTreeID == nil && preselectedNurseryPropagationProjectID == nil {
                    Section {
                        Picker("Applies to", selection: $targetMode) {
                            ForEach(TargetMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .onChange(of: targetMode) { _, newMode in
                            if !newMode.allowsRecurring {
                                isRecurring = false
                            }
                        }

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
                        case .yamadori:
                            yamadoriMultiSelect
                        case .seedBatch:
                            seedBatchMultiSelect
                        case .fieldTree:
                            fieldTreeMultiSelect
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
                        case .yamadori:
                            Text("\(selectedYamadoriIDs.count) Yamadori trip\(selectedYamadoriIDs.count == 1 ? "" : "s") selected. One-off Task only.")
                        case .seedBatch:
                            Text("\(selectedSeedBatchIDs.count) Seed Batch\(selectedSeedBatchIDs.count == 1 ? "" : "es") selected. One-off Task only.")
                        case .fieldTree:
                            Text("\(selectedNurseryPropagationProjectIDs.count) Field Tree\(selectedNurseryPropagationProjectIDs.count == 1 ? "" : "s") selected. One-off Task only.")
                        }
                    }
                } else if let preselectedNurseryPropagationProjectID {
                    Section("Applies to") {
                        if let project = nurseryPropagationService.project(id: preselectedNurseryPropagationProjectID) {
                            Text("\(project.botanicalName) · \(project.projectCode)")
                        } else {
                            Text("Field Tree")
                        }
                    }
                }

                Section("Title") {
                    TextField("Task title", text: $title)
                }

                Section {
                    if preselectedShapingAreaID == nil {
                        if targetMode.allowsRecurring {
                            Toggle("Repeats", isOn: $isRecurring.animation())
                        }

                        if isRecurring, targetMode.allowsRecurring {
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
                    } else {
                        DatePicker("Due", selection: $dueDate, displayedComponents: [.date])
                    }
                } header: {
                    Text("Scheduling")
                } footer: {
                    if preselectedShapingAreaID == nil, isRecurring, targetMode.allowsRecurring {
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
                            .foregroundStyle(BonsaiWorldColors.statusCritical)
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
        .onAppear {
            if trimmedTitle.isEmpty, let workTypeID {
                title = taskService.workType(id: workTypeID)?.name ?? ""
            }
        }
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
                    multiSelectRow(
                        title: tree.bonsaiName,
                        isSelected: selectedTreeIDs.contains(tree.id),
                        thumbnail: { TreeListThumbnail(imageID: tree.listImageID, imageService: imageService) }
                    ) {
                        toggle(tree.id, in: &selectedTreeIDs)
                    }
                }
            }
        }
        .frame(height: 160)
    }

    private var yamadoriMultiSelect: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(yamadoriService.getAllYamadori().sorted {
                    $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
                }) { trip in
                    let name = trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
                    multiSelectRow(
                        title: name.isEmpty ? "Yamadori trip" : name,
                        isSelected: selectedYamadoriIDs.contains(trip.id)
                    ) {
                        toggle(trip.id, in: &selectedYamadoriIDs)
                    }
                }
            }
        }
        .frame(height: 160)
    }

    private var seedBatchMultiSelect: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(seedBatchService.batches.filter(\.stage.isActive).sorted {
                    $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
                }) { batch in
                    multiSelectRow(
                        title: "\(batch.botanicalName) · \(batch.batchCode)",
                        isSelected: selectedSeedBatchIDs.contains(batch.id)
                    ) {
                        toggle(batch.id, in: &selectedSeedBatchIDs)
                    }
                }
            }
        }
        .frame(height: 160)
    }

    private var fieldTreeMultiSelect: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(nurseryPropagationService.activeProjects(kind: .fieldTree).sorted {
                    $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
                }) { project in
                    multiSelectRow(
                        title: "\(project.botanicalName) · \(project.projectCode)",
                        isSelected: selectedNurseryPropagationProjectIDs.contains(project.id)
                    ) {
                        toggle(project.id, in: &selectedNurseryPropagationProjectIDs)
                    }
                }
            }
        }
        .frame(height: 160)
    }

    private func multiSelectRow<Thumbnail: View>(
        title: String,
        isSelected: Bool,
        @ViewBuilder thumbnail: () -> Thumbnail = { EmptyView() },
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: FaloSpacing.medium) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? BonsaiWorldColors.accent : .secondary)
                thumbnail()
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
    }

    private func toggle(_ id: UUID, in set: inout Set<UUID>) {
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
    }

    private func save() {
        guard let workTypeID else { return }
        let resolvedTitle = trimmedTitle.isEmpty
            ? (taskService.workType(id: workTypeID)?.name ?? "Task")
            : trimmedTitle

        if isRecurring, targetMode.allowsRecurring, let target = currentScheduleTarget {
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
            let task: CareTask
            switch targetMode {
            case .yamadori:
                task = try taskService.createTask(
                    title: resolvedTitle,
                    workTypeID: workTypeID,
                    yamadoriIDs: Array(selectedYamadoriIDs),
                    dueDate: dueDate,
                    notes: notes
                )
            case .seedBatch:
                task = try taskService.createTask(
                    title: resolvedTitle,
                    workTypeID: workTypeID,
                    seedBatchIDs: Array(selectedSeedBatchIDs),
                    dueDate: dueDate,
                    notes: notes
                )
            case .fieldTree:
                task = try taskService.createTask(
                    title: resolvedTitle,
                    workTypeID: workTypeID,
                    nurseryPropagationProjectIDs: Array(selectedNurseryPropagationProjectIDs),
                    dueDate: dueDate,
                    notes: notes
                )
            case .trees, .location, .genus:
                guard let target = currentScheduleTarget else { return }
                task = try taskService.createTask(
                    title: resolvedTitle,
                    workTypeID: workTypeID,
                    treeIDs: taskService.resolvedTreeIDs(for: target),
                    dueDate: dueDate,
                    notes: notes,
                    shapingAreaID: preselectedShapingAreaID?.rawValue
                )
            }
            onSave(task)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
