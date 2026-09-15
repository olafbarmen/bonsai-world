//
//  YamadoriTransferSheet.swift
//  Bonsai World
//

import SwiftUI

struct YamadoriTransferSheet: View {
    let findID: UUID
    var onTransferred: ((Tree) -> Void)?

    @Environment(\.dismiss) private var dismiss
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var locationID: UUID?
    @State private var nickname = ""
    @State private var transferNotes = ""
    @State private var copyImages = true
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
                        Text("Assigns a new Bonsai Name and moves this Yamadori Tree to My Trees. The YAM code stays on the Find as history.")
                    }

                    Section("My Trees") {
                        if find.linkedTreeID != nil {
                            LabeledContent("Current Name", value: find.yamadoriCode)
                        }
                        Picker("Location", selection: $locationID) {
                            Text("Keep Current Location").tag(Optional<UUID>.none)
                            ForEach(referenceData.locations) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }
                        TextField("Nickname", text: $nickname)
                        Toggle("Copy Photos", isOn: $copyImages)
                        TextField("Transfer Notes", text: $transferNotes, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Move to My Trees")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Move") { transfer() }
                }
            }
            .alert("Could Not Move", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 440, minHeight: 420)
    }

    private func transfer() {
        guard let find else { return }
        guard let acquisitionMethodID else {
            errorMessage = YamadoriServiceError.acquisitionMethodRequired.localizedDescription
            return
        }
        guard let treeStageID else {
            errorMessage = YamadoriServiceError.treeStageRequired.localizedDescription
            return
        }

        let genusName = find.genusID.flatMap { id in
            referenceData.genus(id: id)?.name
        } ?? ""
        let speciesName = find.speciesID.flatMap { id in
            referenceData.species(id: id)?.name
        } ?? ""
        let cultivarName = find.cultivarID.flatMap { id in
            referenceData.cultivar(id: id)?.name
        }

        var draft = YamadoriTransferDraft()
        draft.locationID = locationID
        draft.nickname = nickname
        draft.transferNotes = transferNotes
        draft.copyImages = copyImages

        do {
            let tree = try yamadoriService.transferToTree(
                id: find.id,
                draft: draft,
                acquisitionMethodID: acquisitionMethodID,
                treeStageID: treeStageID,
                genusName: genusName,
                speciesName: speciesName,
                cultivarName: cultivarName,
                validLocationIDs: Set(referenceData.locations.map(\.id))
            )
            onTransferred?(tree)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
