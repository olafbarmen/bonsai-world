//
//  PotBrandEditorSheet.swift
//  Bonsai World
//
//  Add / Edit sheet for a Pot Brand — Settings → Pot Brands & Makers.
//

import SwiftUI

struct PotBrandEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(ImageImportService.self) private var imageImportService

    @State var draft: PotBrandDraft
    @State private var saveFailed = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Name", text: $draft.name)
                    Picker("Kind", selection: $draft.kind) {
                        ForEach(PotBrandKind.allCases, id: \.self) { kind in
                            Text(kind.title).tag(kind)
                        }
                    }
                    TextField("Country", text: $draft.country)
                        .help("Normalized English country name, e.g. \"Japan\", \"United Kingdom\".")
                    TextField("Origin / Region", text: $draft.originText)
                        .help("Place or tradition detail, e.g. \"Tokoname\" — not a manufacturer name.")
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
                    Text("Documents whether stamps are known. Reference images must be user-uploaded or otherwise licensed — never copied from external sites.")
                        .font(FaloTypography.caption)
                }

                Section("Reference Images") {
                    PotImageStrip(
                        title: "Reference Images",
                        imageIDs: draft.referenceImageIDs,
                        onAdd: { addImage(kind: .reference) },
                        onRemove: { id in
                            draft.referenceImageIDs.removeAll { $0 == id }
                        }
                    )
                }

                Section {
                    PotImageStrip(
                        title: "Known Stamps",
                        imageIDs: draft.stampReferenceImageIDs,
                        onAdd: { addImage(kind: .stamp) },
                        onRemove: { id in
                            draft.stampReferenceImageIDs.removeAll { $0 == id }
                        }
                    )
                } header: {
                    Text("Stamp References")
                } footer: {
                    Text("Known identifying stamps for this brand — separate from a photo of the stamp on a specific pot.")
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
            .navigationTitle(draft.isNew ? "New Brand / Kiln" : "Edit Brand / Kiln")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { handleSave() }
                }
            }
            .alert("Could Not Save Brand", isPresented: $saveFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Choose a name that is not already used by another Brand.")
            }
        }
        .frame(minWidth: 440, minHeight: 560)
    }

    private enum ImageKind { case reference, stamp }

    private func addImage(kind: ImageKind) {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            switch kind {
            case .reference:
                draft.referenceImageIDs.append(asset.id)
            case .stamp:
                draft.stampReferenceImageIDs.append(asset.id)
            }
        }
    }

    private func handleSave() {
        if manager.savePotBrand(draft) {
            dismiss()
        } else {
            saveFailed = true
        }
    }
}
