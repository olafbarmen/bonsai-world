//
//  NewYamadoriFindView.swift
//  Bonsai World
//
//  Add Find on an existing trip — Scout + next YAM code.
//

import SwiftUI

struct NewYamadoriFindView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let tripID: UUID
    var onCreated: (UUID) -> Void

    @State private var displayName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")
                } footer: {
                    Text("Optional. Status starts as Uncollected (Scout).")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Add Find")
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
        }
    }

    private func save() {
        guard let find = library.addFind(onYamadoriID: tripID, displayName: displayName) else { return }
        onCreated(find.id)
        dismiss()
    }
}

#Preview {
    NewYamadoriFindView(tripID: UUID(), onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
