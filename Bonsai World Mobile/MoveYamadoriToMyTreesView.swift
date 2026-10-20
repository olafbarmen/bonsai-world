//
//  MoveYamadoriToMyTreesView.swift
//  Bonsai World
//
//  Move to My Trees — free-text Bonsai Name. Find → Transferred; Tree leaves nursery.
//

import SwiftUI

struct MoveYamadoriToMyTreesView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let findID: UUID
    var onMoved: (UUID) -> Void

    @State private var bonsaiName: String = ""
    @State private var nickname: String = ""
    @State private var locationID: UUID?
    @State private var copyImages = true
    @State private var transferNotes: String = ""
    @State private var didLoad = false

    private var find: YamadoriFind? { library.yamadoriFind(id: findID) }
    private var linkedTree: Tree? {
        guard let id = find?.linkedTreeID else { return nil }
        return library.tree(id: id)
    }

    private var locationOptions: [Location] {
        library.locations.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    private var canMove: Bool {
        guard find?.status.canTransferToTree == true else { return false }
        guard linkedTree?.yamadoriNursery == true else { return false }
        return !bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                if let find {
                    Section {
                        LabeledContent("Code", value: find.yamadoriCode)
                        LabeledContent("Status", value: find.status.title)
                    } footer: {
                        Text("Assigns a new Bonsai Name and moves this Yamadori Tree to My Trees. The YAM code stays on the Find as history.")
                    }

                    Section("My Trees") {
                        TextField("Bonsai Name", text: $bonsaiName)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityLabel("Bonsai Name")

                        TextField("Nickname", text: $nickname)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityLabel("Nickname")

                        Picker("Location", selection: $locationID) {
                            Text("Keep Current Location").tag(Optional<UUID>.none)
                            ForEach(locationOptions) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }

                        Toggle("Copy Photos", isOn: $copyImages)

                        TextField("Transfer Notes", text: $transferNotes, axis: .vertical)
                            .lineLimit(2...4)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityLabel("Transfer Notes")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Move to My Trees")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Move") { move() }
                        .fontWeight(.semibold)
                        .disabled(!canMove)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear { loadIfNeeded() }
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let find else { return }
        let tree = linkedTree
        bonsaiName = tree?.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ? (tree?.botanicalName ?? "")
            : find.displayName
        if bonsaiName.isEmpty {
            bonsaiName = find.yamadoriCode
        }
        nickname = tree?.nickname ?? ""
        locationID = nil
        didLoad = true
    }

    private func move() {
        guard let tree = library.moveYamadoriToMyTrees(
            findID: findID,
            bonsaiName: bonsaiName,
            nickname: nickname,
            locationID: locationID,
            transferNotes: transferNotes,
            copyImages: copyImages
        ) else { return }
        onMoved(tree.id)
        dismiss()
    }
}

#Preview {
    MoveYamadoriToMyTreesView(findID: UUID(), onMoved: { _ in })
        .environment(DemoLibrary.preview)
}
