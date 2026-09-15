//
//  PotMakerEditorSheet.swift
//  Bonsai World
//
//  Add / Edit sheet for a Pot Maker — Settings → Pot Brands & Makers.
//  A Maker always belongs to a Brand; Brand is fixed to the row it was opened from.
//

import SwiftUI

struct PotMakerEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageImportService.self) private var imageImportService

    @State var draft: PotMakerDraft
    @State private var saveFailed = false

    private var brandName: String {
        guard let brandID = draft.brandID else { return "Independent (no Brand / Kiln)" }
        return referenceData.potBrand(id: brandID)?.name ?? "Unknown Brand"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    LabeledContent("Brand / Kiln", value: brandName)
                    TextField("Name", text: $draft.name)
                    if draft.brandID == nil {
                        TextField("Country", text: $draft.country)
                            .help("Normalized English country name when this maker has no Brand / Kiln.")
                    }
                    Picker("Maker Type", selection: $draft.makerType) {
                        ForEach(PotMakerType.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    TextField("Generation / Period", text: $draft.generation)
                        .help("Optional default for this maker, e.g. \"3rd generation\" or \"Early Period\"")
                    Toggle("Active", isOn: $draft.isActive)
                    if draft.isSystemSeed {
                        LabeledContent("Curated Seed", value: "Yes")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $draft.notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Picker("Stamp Known", selection: $draft.stampKnown) {
                        ForEach(PotStampKnowledge.allCases, id: \.self) { value in
                            Text(value.title).tag(value)
                        }
                    }
                    TextField("Stamp Description", text: $draft.stampDescription, axis: .vertical)
                        .lineLimit(2...3)
                    TextField("Stamp Identification Notes", text: $draft.stampIdentificationNotes, axis: .vertical)
                        .lineLimit(2...3)
                } header: {
                    Text("Stamp Documentation")
                } footer: {
                    Text("Documents whether stamps are known. Reference images must be user-uploaded or otherwise licensed.")
                        .font(FaloTypography.caption)
                }

                Section {
                    PotImageStrip(
                        title: "Known Stamps",
                        imageIDs: draft.stampReferenceImageIDs,
                        onAdd: { addStampImage() },
                        onRemove: { id in
                            draft.stampReferenceImageIDs.removeAll { $0 == id }
                        }
                    )
                } header: {
                    Text("Stamp References")
                } footer: {
                    Text("Known identifying stamps for this maker — separate from a photo of the stamp on a specific pot.")
                        .font(FaloTypography.caption)
                }

                Section {
                    TextField("Source Name", text: $draft.sourceName)
                    TextField("Source URL", text: $draft.sourceURL)
                        .help("Research reference only — not Bonsai World content.")
                    TextField("Verification Notes", text: $draft.verificationNotes, axis: .vertical)
                        .lineLimit(2...3)
                } header: {
                    Text("Curation")
                } footer: {
                    Text("Internal quality-control fields. Source URLs are research provenance, not owned material.")
                        .font(FaloTypography.caption)
                }
            }
            .formStyle(.grouped)
            .navigationTitle(draft.isNew ? "New Maker / Potter" : "Edit Maker / Potter")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { handleSave() }
                }
            }
            .alert("Could Not Save Maker", isPresented: $saveFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("A name is required.")
            }
        }
        .frame(minWidth: 440, minHeight: 520)
    }

    private func addStampImage() {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            draft.stampReferenceImageIDs.append(asset.id)
        }
    }

    private func handleSave() {
        if manager.savePotMaker(draft) {
            dismiss()
        } else {
            saveFailed = true
        }
    }
}
