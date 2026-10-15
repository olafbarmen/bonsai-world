//
//  PostponeOccurrenceSheet.swift
//  Bonsai World
//
//  Moves one TaskOccurrence due date without changing Schedule recurrence (AX1).
//

import SwiftUI

struct PostponeOccurrenceSheet: View {
    let occurrence: TaskOccurrence
    var onFinished: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService

    @State private var dueDate: Date
    @State private var errorMessage: String?

    init(occurrence: TaskOccurrence, onFinished: @escaping () -> Void = {}) {
        self.occurrence = occurrence
        self.onFinished = onFinished
        let start = Calendar.current.startOfDay(for: .now)
        let initial = max(occurrence.dueDate, start)
        _dueDate = State(initialValue: initial)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(occurrence.title)
                        .font(FaloTypography.headline)
                    Text("Choose a new due date for this time only. Repeating rules (for example every few years) stay the same.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Section("New due date") {
                    DatePicker("Due", selection: $dueDate, displayedComponents: [.date])
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
            .navigationTitle("Postpone")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 320)
    }

    private func save() {
        do {
            try taskService.postponeOccurrence(occurrence, to: dueDate)
            onFinished()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
