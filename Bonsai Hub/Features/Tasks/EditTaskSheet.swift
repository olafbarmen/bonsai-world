//
//  EditTaskSheet.swift
//  Bonsai World
//
//  Edit core fields for a one-off CareTask or a recurring CareSchedule.
//  Work Type and target stay as created — change those by delete + recreate.
//  Opened from Task Details or Manage Schedules.
//

import SwiftUI

struct EditTaskSheet: View {
    enum Subject {
        case task(CareTask)
        case schedule(CareSchedule)
    }

    let subject: Subject
    var onFinished: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService

    @State private var title: String
    @State private var dueDate: Date
    @State private var notes: String

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

    @State private var repeatMode: RepeatMode
    @State private var recurrenceUnit: CareRecurrenceUnit
    @State private var recurrenceInterval: Int
    @State private var selectedDayParts: Set<CareDayPart>
    @State private var hasSeasonalWindow: Bool
    @State private var seasonFromMonth: Int
    @State private var seasonToMonth: Int
    @State private var errorMessage: String?
    @State private var confirmDelete = false

    private var isSchedule: Bool {
        if case .schedule = subject { return true }
        return false
    }

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        if isSchedule, repeatMode == .multipleTimesPerDay {
            return !selectedDayParts.isEmpty
        }
        return true
    }

    init(subject: Subject, onFinished: @escaping () -> Void = {}) {
        self.subject = subject
        self.onFinished = onFinished
        switch subject {
        case .task(let task):
            _title = State(initialValue: task.title)
            _dueDate = State(initialValue: task.dueDate)
            _notes = State(initialValue: task.notes)
            _repeatMode = State(initialValue: .interval)
            _recurrenceUnit = State(initialValue: .day)
            _recurrenceInterval = State(initialValue: 1)
            _selectedDayParts = State(initialValue: [])
            _hasSeasonalWindow = State(initialValue: false)
            _seasonFromMonth = State(initialValue: 1)
            _seasonToMonth = State(initialValue: 12)
        case .schedule(let schedule):
            _title = State(initialValue: schedule.title)
            _dueDate = State(initialValue: .now)
            _notes = State(initialValue: schedule.notes)
            let parts = schedule.recurrence.dayParts
            _repeatMode = State(initialValue: parts.isEmpty ? .interval : .multipleTimesPerDay)
            _recurrenceUnit = State(initialValue: schedule.recurrence.unit)
            _recurrenceInterval = State(initialValue: schedule.recurrence.interval)
            _selectedDayParts = State(initialValue: parts)
            _hasSeasonalWindow = State(initialValue: schedule.seasonalWindow != nil)
            _seasonFromMonth = State(initialValue: schedule.seasonalWindow?.fromMonth ?? 1)
            _seasonToMonth = State(initialValue: schedule.seasonalWindow?.toMonth ?? 12)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Task title", text: $title)
                }

                if isSchedule {
                    scheduleSection
                } else {
                    Section("Due") {
                        DatePicker("Due", selection: $dueDate, displayedComponents: [.date])
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

                Section {
                    Button("Delete", role: .destructive) {
                        confirmDelete = true
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(isSchedule ? "Edit Schedule" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
            .confirmationDialog(
                isSchedule ? "Delete this schedule?" : "Delete this task?",
                isPresented: $confirmDelete,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) { delete() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(
                    isSchedule
                        ? "Future recurring occurrences will stop. Past Work stays in history."
                        : "This planned task will be removed. Past Work stays in history."
                )
            }
        }
        .frame(minWidth: 460, minHeight: 480)
    }

    private var scheduleSection: some View {
        Section {
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
        } header: {
            Text("Scheduling")
        }
    }

    private func save() {
        do {
            switch subject {
            case .task(var task):
                let resolvedTitle = trimmedTitle.isEmpty
                    ? (taskService.workType(id: task.workTypeID)?.name ?? task.title)
                    : trimmedTitle
                task.title = resolvedTitle
                task.dueDate = dueDate
                task.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
                _ = try taskService.updateTask(task)

            case .schedule(var schedule):
                let resolvedTitle = trimmedTitle.isEmpty
                    ? (taskService.workType(id: schedule.workTypeID)?.name ?? schedule.title)
                    : trimmedTitle
                schedule.title = resolvedTitle
                schedule.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
                schedule.recurrence = repeatMode == .multipleTimesPerDay
                    ? CareRecurrenceRule(unit: .day, interval: 1, dayParts: selectedDayParts)
                    : CareRecurrenceRule(unit: recurrenceUnit, interval: recurrenceInterval)
                schedule.seasonalWindow = hasSeasonalWindow
                    ? CareScheduleSeasonalWindow(fromMonth: seasonFromMonth, toMonth: seasonToMonth)
                    : nil
                _ = try taskService.updateSchedule(schedule)
            }
            onFinished()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func delete() {
        do {
            switch subject {
            case .task(let task):
                try taskService.deleteTask(id: task.id)
            case .schedule(let schedule):
                try taskService.deleteSchedule(id: schedule.id)
            }
            onFinished()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
