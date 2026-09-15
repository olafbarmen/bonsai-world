//
//  YamadoriCollectSheet.swift
//  Bonsai World
//

import SwiftUI

struct YamadoriCollectSheet: View {
    let findID: UUID
    var onCollected: ((Tree) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var locationID: UUID?
    @State private var copyImages = true
    @State private var collectionNotes = ""
    @State private var errorMessage: String?

    private var find: YamadoriFind? {
        yamadoriService.getFind(id: findID)
    }

    private var acquisitionMethodID: UUID? {
        referenceData.acquisitionMethods.first {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare("Yamadori") == .orderedSame
        }?.id
    }

    private var treeStageID: UUID? {
        referenceData.treeStages.first {
            $0.name.trimmingCharacters(in: .whitespacesAndNewlines)
                .caseInsensitiveCompare(TreeStageFertilizerMapping.newlyCollectedYamadoriName) == .orderedSame
        }?.id
    }

    var body: some View {
        NavigationStack {
            Form {
                if let find {
                    Section {
                        LabeledContent("Code", value: find.yamadoriCode)
                        LabeledContent("Status", value: find.status.title)
                    } header: {
                        Text("Find")
                    } footer: {
                        Text("Creates a Yamadori Tree with this YAM code. You can move it to My Trees when ready.")
                    }

                    Section("Yamadori Tree") {
                        Picker("Location", selection: $locationID) {
                            Text("Select Location").tag(Optional<UUID>.none)
                            ForEach(referenceData.locations) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }
                        Toggle("Copy Photos", isOn: $copyImages)
                        TextField("Collection Notes", text: $collectionNotes, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Mark Collected")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Collect") { collect() }
                        .disabled(locationID == nil)
                }
            }
            .alert("Could Not Collect", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 440, minHeight: 400)
    }

    private func collect() {
        guard let find else { return }
        guard let acquisitionMethodID else {
            errorMessage = YamadoriServiceError.acquisitionMethodRequired.localizedDescription
            return
        }
        guard let treeStageID else {
            errorMessage = YamadoriServiceError.treeStageRequired.localizedDescription
            return
        }

        let genusName = find.genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let speciesName = find.speciesID.flatMap { referenceData.species(id: $0)?.name } ?? ""
        let cultivarName = find.cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }

        var draft = YamadoriCollectDraft()
        draft.locationID = locationID
        draft.copyImages = copyImages
        draft.collectionNotes = collectionNotes

        do {
            let result = try yamadoriService.markCollected(
                id: find.id,
                draft: draft,
                acquisitionMethodID: acquisitionMethodID,
                treeStageID: treeStageID,
                genusName: genusName,
                speciesName: speciesName,
                cultivarName: cultivarName,
                validLocationIDs: Set(referenceData.locations.map(\.id))
            )
            onCollected?(result.tree)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
