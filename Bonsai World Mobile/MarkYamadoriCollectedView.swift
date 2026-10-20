//
//  MarkYamadoriCollectedView.swift
//  Bonsai World
//
//  Mark Collected — Planned Find → Yamadori Tree (nursery). Botanical name text only.
//

import SwiftUI

struct MarkYamadoriCollectedView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let findID: UUID
    var onCollected: (UUID) -> Void

    @State private var botanicalName: String = ""
    @State private var locationID: UUID?
    @State private var copyImages = true
    @State private var collectionNotes: String = ""
    @State private var didLoad = false

    private var find: YamadoriFind? { library.yamadoriFind(id: findID) }

    private var locationOptions: [Location] {
        library.locations.sorted {
            $0.name.localizedStandardCompare($1.name) == .orderedAscending
        }
    }

    private var canCollect: Bool {
        guard find?.status == .planned else { return false }
        guard locationID != nil else { return false }
        return !botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                if let find {
                    Section {
                        LabeledContent("Code", value: find.yamadoriCode)
                        LabeledContent("Status", value: find.status.title)
                    } footer: {
                        Text("Creates a Yamadori Tree with this YAM code. You can move it to My Trees later.")
                    }

                    Section("Yamadori Tree") {
                        TextField("Botanical Name", text: $botanicalName)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityLabel("Botanical Name")

                        Picker("Location", selection: $locationID) {
                            Text("Select Location").tag(Optional<UUID>.none)
                            ForEach(locationOptions) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }

                        Toggle("Copy Photos", isOn: $copyImages)

                        TextField("Collection Notes", text: $collectionNotes, axis: .vertical)
                            .lineLimit(2...4)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .accessibilityLabel("Collection Notes")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Mark Collected")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Collect") { collect() }
                        .fontWeight(.semibold)
                        .disabled(!canCollect)
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
        if let estimate = find.speciesEstimate?.trimmingCharacters(in: .whitespacesAndNewlines), !estimate.isEmpty {
            botanicalName = estimate
        } else {
            botanicalName = find.displayName.isEmpty ? find.yamadoriCode : find.displayName
        }
        locationID = locationOptions.first?.id
        didLoad = true
    }

    private func collect() {
        guard let locationID else { return }
        guard let tree = library.markYamadoriCollected(
            findID: findID,
            botanicalName: botanicalName,
            locationID: locationID,
            collectionNotes: collectionNotes,
            copyImages: copyImages
        ) else { return }
        onCollected(tree.id)
        dismiss()
    }
}

#Preview {
    MarkYamadoriCollectedView(findID: UUID(), onCollected: { _ in })
        .environment(DemoLibrary.preview)
}
