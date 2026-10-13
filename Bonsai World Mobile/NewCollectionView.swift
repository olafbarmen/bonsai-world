//
//  NewCollectionView.swift
//  Bonsai World
//
//  Field New Collection — Identity only. Membership starts empty.
//

import SwiftUI

struct NewCollectionView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name = ""
    @State private var descriptionText = ""

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canCreate: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Collection Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Collection Name")

                    TextField("Description", text: $descriptionText, axis: .vertical)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .lineLimit(3...8)
                        .accessibilityLabel("Description")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .fontWeight(.semibold)
                        .disabled(!canCreate)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func create() {
        guard let collection = library.addCollection(name: name, description: descriptionText) else { return }
        onCreated(collection.id)
        dismiss()
    }
}

#Preview {
    NewCollectionView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
