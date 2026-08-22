//
//  CollectionEditorView.swift
//  Bonsai World
//
//  Create Collection sheet. Membership starts empty — Trees are referenced by ID later.
//  Metadata editing for existing Collections is Collection Detail Edit Mode.
//
//  Hierarchy: Identity (name → description) then Appearance (icon → color).
//

import SwiftUI

struct CollectionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService

    /// When set (e.g. nested in New Tree), creation returns here instead of navigating the app.
    var onCreated: ((UUID) -> Void)? = nil

    @State private var name = ""
    @State private var descriptionText = ""
    @State private var selectedIcon: String?
    @State private var selectedColorHex: String?

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canCreate: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                    identitySection
                    appearanceSection
                }
                .padding(FaloSpacing.xLarge)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .faloScrollSurface()
            .navigationTitle("New Collection")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        create()
                    }
                    .disabled(!canCreate)
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(minWidth: 440, minHeight: 420)
    }

    // MARK: - Identity (primary)

    private var identitySection: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            DetailSectionHeader(title: "Identity")

            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Collection Name")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)

                    TextField("Name this collection", text: $name)
                        .font(.title2.weight(.semibold))
                        .textFieldStyle(.plain)
                        .padding(.horizontal, FaloSpacing.medium)
                        .padding(.vertical, FaloSpacing.medium)
                        .background {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                        }
                        .accessibilityLabel("Collection Name")
                }

                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Description")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)

                    TextField("Why does this collection exist?", text: $descriptionText, axis: .vertical)
                        .font(FaloCardTypography.fieldValue)
                        .textFieldStyle(.plain)
                        .lineLimit(5...10)
                        .frame(minHeight: 120, alignment: .topLeading)
                        .padding(FaloSpacing.medium)
                        .background {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                        }
                        .accessibilityLabel("Description")
                }
            }
        }
    }

    // MARK: - Appearance (secondary)

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            DetailSectionHeader(title: "Appearance")

            HStack(alignment: .top, spacing: FaloSpacing.large) {
                appearancePicker(
                    label: "Icon",
                    selection: $selectedIcon
                ) {
                    Text(FaloDisplayValue.empty).tag(String?.none)
                    ForEach(CollectionAppearanceChoices.icons, id: \.self) { symbol in
                        Label(symbol, systemImage: symbol)
                            .tag(Optional(symbol))
                    }
                } accessory: {
                    if let selectedIcon {
                        Image(systemName: selectedIcon)
                            .font(.body)
                            .foregroundStyle(.tertiary)
                            .frame(width: 22, height: 22)
                            .accessibilityHidden(true)
                    }
                }

                appearancePicker(
                    label: "Color",
                    selection: $selectedColorHex
                ) {
                    Text(FaloDisplayValue.empty).tag(String?.none)
                    ForEach(CollectionAppearanceChoices.colors, id: \.hex) { choice in
                        Text(choice.label).tag(Optional(choice.hex))
                    }
                } accessory: {
                    if let selectedColorHex, let color = Color(collectionHex: selectedColorHex) {
                        Circle()
                            .fill(color)
                            .frame(width: 14, height: 14)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }

    private func appearancePicker<Selection: Hashable, Options: View, Accessory: View>(
        label: String,
        selection: Binding<Selection>,
        @ViewBuilder options: () -> Options,
        @ViewBuilder accessory: () -> Accessory
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloTypography.caption)
                .foregroundStyle(.tertiary)

            HStack(spacing: FaloSpacing.small) {
                Picker(label, selection: selection) {
                    options()
                }
                .pickerStyle(.menu)
                .labelsHidden()

                accessory()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func create() {
        guard canCreate else { return }

        let collection = treeService.addCollection(
            name: trimmedName,
            description: descriptionText.trimmingCharacters(in: .whitespacesAndNewlines),
            color: selectedColorHex,
            icon: selectedIcon
        )

        if let onCreated {
            onCreated(collection.id)
            dismiss()
        } else {
            appState.selectedSection = .gardenCollections
            appState.selectedTreeID = nil
            appState.selectedCollectionID = collection.id
            appState.dismissCollectionEditor()
            dismiss()
        }
    }
}

#Preview {
    let preview = PreviewData()
    return CollectionEditorView()
        .environment(AppState())
        .environment(TreeService.preview(previewData: preview))
}
