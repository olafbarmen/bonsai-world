//
//  NewYamadoriObservationView.swift
//  Bonsai World
//
//  Add Observation — text + date (no category).
//

import SwiftUI

struct NewYamadoriObservationView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let findID: UUID

    @State private var text: String = ""
    @State private var date: Date = .now

    private var canSave: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Observation") {
                    TextEditor(text: $text)
                        .frame(minHeight: 120)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Observation")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add Observation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func save() {
        guard library.addYamadoriObservation(findID: findID, text: text, date: date) != nil else { return }
        dismiss()
    }
}

#Preview {
    NewYamadoriObservationView(findID: UUID())
        .environment(DemoLibrary.preview)
}
