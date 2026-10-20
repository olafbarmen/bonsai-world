//
//  NewPotView.swift
//  Bonsai World
//
//  Field New Pot — identity fields supported without Reference Data brands.
//

import SwiftUI

struct NewPotView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name = ""
    @State private var material = ""
    @State private var shape = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")
                    TextField("Material", text: $material)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Material")
                    TextField("Shape", text: $shape)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Shape")
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                } footer: {
                    Text("Status starts as Available.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Pot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func save() {
        guard let pot = library.addPot(
            name: name,
            material: material,
            shape: shape,
            notes: notes
        ) else { return }
        onCreated(pot.id)
        dismiss()
    }
}

#Preview {
    NewPotView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
