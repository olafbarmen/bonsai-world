//
//  EditCollectionView.swift
//  Bonsai World
//
//  Field Collection edit — name and description. Save / Cancel.
//  Commits through DemoLibrary on Save. No nested NavigationStack.
//

import SwiftUI

struct EditCollectionView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let collectionID: UUID

    @State private var name = ""
    @State private var descriptionText = ""
    @State private var didLoadDraft = false

    private var collection: Collection? { library.collection(id: collectionID) }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Group {
            if collection != nil {
                editorForm
            } else {
                ContentUnavailableView("Collection not found", systemImage: "square.stack.3d.up")
            }
        }
    }

    private var editorForm: some View {
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
        .navigationTitle("Edit Collection")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        .toolbarColorScheme(.light, for: .navigationBar)
        .onAppear {
            guard !didLoadDraft, let collection else { return }
            name = collection.name
            descriptionText = collection.description
            didLoadDraft = true
        }
    }

    private func save() {
        library.updateCollection(id: collectionID, name: name, description: descriptionText)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditCollectionView(collectionID: UUID())
    }
    .environment(DemoLibrary.preview)
}
