//
//  AddJournalSheet.swift
//  Bonsai World
//
//  Registers a Journal entry on one Tree (Context Tools → Add Journal).
//

import SwiftUI

struct AddJournalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(JournalService.self) private var journalService

    let treeID: UUID
    var onSave: (JournalEntry) -> Void = { _ in }

    @State private var recordedAt: Date = .now
    @State private var text: String = ""
    @State private var isBeforeOwnership = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section {
                    DatePicker("Date", selection: $recordedAt, displayedComponents: [.date])
                    Toggle("Before ownership", isOn: $isBeforeOwnership)
                }

                Section {
                    TextField("Journal note", text: $text, axis: .vertical)
                        .lineLimit(5...12)
                } footer: {
                    Text(
                        isBeforeOwnership
                            ? "Use for what you know about this tree before it entered your care."
                            : "Narrative note — not a substitute for Work, Measurement, or Photo."
                    )
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .formStyle(.grouped)

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button("Save") { save() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .frame(minWidth: 420, minHeight: 360)
        .navigationTitle("Add Journal")
    }

    private func save() {
        do {
            let entry = try journalService.registerEntry(
                treeID: treeID,
                recordedAt: recordedAt,
                text: text,
                isBeforeOwnership: isBeforeOwnership
            )
            onSave(entry)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
