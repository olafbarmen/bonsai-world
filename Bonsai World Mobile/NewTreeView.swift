//
//  NewTreeView.swift
//  Bonsai World
//
//  Field New Tree — Botanical, Nickname, Location. Auto bonsai name.
//

import SwiftUI

struct NewTreeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    /// Optional preselected Location (e.g. from Location Profile).
    var initialLocationID: UUID? = nil
    var onCreated: (UUID) -> Void

    @State private var botanicalName = ""
    @State private var nickname = ""
    @State private var locationID: UUID?
    @State private var didLoadInitial = false
    @State private var isShowingNewLocation = false

    private var canSave: Bool {
        !botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && locationID != nil
    }

    private var bonsaiNamePreview: String? {
        library.previewNextBonsaiName(botanicalName: botanicalName)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Botanical", text: $botanicalName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .textInputAutocapitalization(.words)
                        .accessibilityLabel("Botanical")

                    TextField("Nickname", text: $nickname)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Nickname")

                    if library.orderedLocations.isEmpty {
                        Text("Empty")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Button("New Location") {
                            isShowingNewLocation = true
                        }
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.accent)
                        .accessibilityLabel("New Location")
                    } else {
                        Picker("Location", selection: $locationID) {
                            Text("Select Location").tag(Optional<UUID>.none)
                            ForEach(library.orderedLocations) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }
                        .accessibilityLabel("Location")
                    }

                    if let preview = bonsaiNamePreview {
                        LabeledContent("Bonsai Name") {
                            Text(preview)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                                .monospacedDigit()
                        }
                        .accessibilityLabel("Bonsai Name, \(preview)")
                    }
                } footer: {
                    Text("Bonsai Name is assigned automatically. Nickname is optional.")
                        .font(FaloTypography.caption)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Tree")
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
            .onAppear {
                guard !didLoadInitial else { return }
                if let initialLocationID, library.location(id: initialLocationID) != nil {
                    locationID = initialLocationID
                } else {
                    locationID = library.orderedLocations.first?.id
                }
                didLoadInitial = true
            }
            .sheet(isPresented: $isShowingNewLocation, onDismiss: {
                if locationID == nil {
                    locationID = library.orderedLocations.first?.id
                }
            }) {
                NewLocationView { id in
                    locationID = id
                }
            }
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }

    private func save() {
        guard let locationID else { return }
        guard let tree = library.createTree(
            botanicalName: botanicalName,
            nickname: nickname,
            locationID: locationID
        ) else { return }
        onCreated(tree.id)
        dismiss()
    }
}

#Preview {
    NewTreeView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
