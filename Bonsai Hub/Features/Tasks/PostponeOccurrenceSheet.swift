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

    @State private var count = 1
    @State private var unit: TaskPostpone.Unit = .days
    @State private var errorMessage: String?

    private var dueDate: Date {
        TaskPostpone.date(from: occurrence.dueDate, count: count, unit: unit)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(occurrence.title)
                        .font(FaloTypography.headline)
                    Text("This time only. Repeating rules (for example every few years) stay the same.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Postpone") {
                    Picker("Amount", selection: $count) {
                        ForEach(Array(TaskPostpone.amounts), id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    Picker("By", selection: $unit) {
                        ForEach(TaskPostpone.Unit.allCases) { item in
                            Text(item.title).tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    LabeledContent("New due date") {
                        Text(dueDate, style: .date)
                    }
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
