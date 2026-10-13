//
//  WireCheckReminderSheet.swift
//  Bonsai World
//
//  After logging Wiring work — schedule a Task to check or remove the wire.
//

import SwiftUI

struct WireCheckReminderSheet: View {
    let treeID: UUID
    var wiredOn: Date
    var onFinished: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(TaskService.self) private var taskService

    @State private var checkDate: Date
    @State private var errorMessage: String?

    init(treeID: UUID, wiredOn: Date = .now, onFinished: @escaping () -> Void) {
        self.treeID = treeID
        self.wiredOn = wiredOn
        self.onFinished = onFinished
        let defaultDue = Calendar.current.date(byAdding: .month, value: 3, to: wiredOn) ?? wiredOn
        _checkDate = State(initialValue: defaultDue)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Schedule a reminder to check or remove the wire on this tree.")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                Section("Check / remove") {
                    DatePicker(
                        "Date",
                        selection: $checkDate,
                        in: wiredOn...,
                        displayedComponents: [.date]
                    )
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
            .navigationTitle("Wire Check Reminder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") { finish() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create Task") { createTask() }
                        .keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 280)
    }

    private func createTask() {
        let workTypeID = taskService.workType(id: CanonicalWorkTypeID.wireRemoval)?.id
            ?? taskService.workTypes(in: .shaping).first(where: {
                $0.name.caseInsensitiveCompare("Wire Removal") == .orderedSame
            })?.id
            ?? CanonicalWorkTypeID.wireRemoval

        let wiredLabel = wiredOn.formatted(date: .abbreviated, time: .omitted)
        do {
            _ = try taskService.createTask(
                title: "Check / remove wire",
                workTypeID: workTypeID,
                treeIDs: [treeID],
                dueDate: checkDate,
                notes: "After wiring on \(wiredLabel). Mark removed when done, or set a new check date."
            )
            finish()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func finish() {
        onFinished()
        dismiss()
    }
}
