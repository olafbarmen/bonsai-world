//
//  AddShapingHistorySheet.swift
//  Bonsai World
//
//  Adds a dated history entry to one Shaping area.
//

import SwiftUI

struct AddShapingHistorySheet: View {
    let treeID: UUID
    let area: ShapingAreaID
    var onSave: (ShapingHistoryEntry) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(ImageService.self) private var imageService

    @State private var date = Date.now
    @State private var description = ""
    @State private var intent: VisionCharacteristicKind?
    @State private var imageIDs: [UUID] = []
    @State private var isImporting = false
    @State private var showIntent = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("What happened?") {
                    TextEditor(text: $description)
                        .font(FaloCardTypography.fieldValue)
                        .frame(minHeight: 100)
                }

                Section {
                    Toggle("Add intent tag", isOn: $showIntent)
                    if showIntent {
                        Picker("Intent", selection: Binding(
                            get: { intent ?? .develop },
                            set: { intent = $0 }
                        )) {
                            ForEach(VisionCharacteristicKind.allCases) { option in
                                Text(option.title).tag(option)
                            }
                        }
                    }
                }

                Section("Photos") {
                    if imageIDs.isEmpty {
                        Text("No photos attached.")
                            .foregroundStyle(.secondary)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: FaloSpacing.small) {
                                ForEach(imageIDs, id: \.self) { imageID in
                                    TreeListThumbnail(imageID: imageID, imageService: imageService)
                                }
                            }
                        }
                    }
                    Button {
                        Task { await addPhoto() }
                    } label: {
                        Label("Add Photo", systemImage: "plus")
                    }
                    .disabled(isImporting)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Add History")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .frame(minWidth: 440, minHeight: 420)
    }

    private func save() {
        let entry = ShapingHistoryEntry(
            date: date,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            imageIDs: imageIDs,
            intent: showIntent ? intent : nil
        )
        onSave(entry)
        dismiss()
    }

    private func addPhoto() async {
        isImporting = true
        defer { isImporting = false }
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            guard !imageIDs.contains(asset.id) else { return }
            imageIDs.append(asset.id)
        } catch {
            return
        }
    }
}
