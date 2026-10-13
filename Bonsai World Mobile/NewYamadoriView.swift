//
//  NewYamadoriView.swift
//  Bonsai World
//
//  Field New Yamadori — trip + first Find (Scout). Pin on Find profile.
//

import SwiftUI

struct NewYamadoriView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var displayName: String = ""
    @State private var notes: String = ""

    private var canSave: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")
                } footer: {
                    Text("Creates a Trip and the first Find. Add a map pin on the Find profile.")
                        .font(FaloTypography.caption)
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 88)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Yamadori")
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
        guard let created = library.addYamadori(displayName: displayName, notes: notes) else { return }
        onCreated(created.find.id)
        dismiss()
    }
}

#Preview {
    NewYamadoriView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
