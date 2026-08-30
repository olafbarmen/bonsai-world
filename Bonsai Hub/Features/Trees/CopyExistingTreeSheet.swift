//
//  CopyExistingTreeSheet.swift
//  Bonsai World
//
//  Global Quick Action → Add Tree → Copy Existing Tree.
//  Picker of In Care trees; confirm, then the same copy as Duplicate Tree.
//

import SwiftUI

struct CopyExistingTreeSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(\.dismiss) private var dismiss

    @State private var treePendingCopy: Tree?
    @State private var copyFailed = false
    @State private var copyErrorMessage = ""

    private var candidates: [Tree] {
        _ = treeService.trees
        return treeService.treesInCare.sorted {
            TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                TreePresentation.title(for: $1)
            ) == .orderedAscending
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if candidates.isEmpty {
                    ContentUnavailableView(
                        "No Trees to Copy",
                        systemImage: "leaf",
                        description: Text("Add a tree first, then you can copy it.")
                    )
                } else {
                    List(candidates) { tree in
                        Button {
                            treePendingCopy = tree
                        } label: {
                            HStack(alignment: .center, spacing: FaloSpacing.medium) {
                                TreeListThumbnail(imageID: tree.listImageID)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(TreePresentation.title(for: tree))
                                        .foregroundStyle(.primary)
                                    Text(tree.botanicalName)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Duplicates this tree’s info with a new Bonsai Name")
                    }
                    .faloScrollSurface()
                }
            }
            .navigationTitle("Duplicate Tree Info")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
            .confirmationDialog(
                "Duplicate Tree Info?",
                isPresented: Binding(
                    get: { treePendingCopy != nil },
                    set: { if !$0 { treePendingCopy = nil } }
                ),
                titleVisibility: .visible
            ) {
                Button("Duplicate Tree Info") {
                    if let tree = treePendingCopy {
                        performCopy(tree)
                    }
                    treePendingCopy = nil
                }
                Button("Cancel", role: .cancel) {
                    treePendingCopy = nil
                }
            } message: {
                if let tree = treePendingCopy {
                    Text("Create a tree from “\(TreePresentation.title(for: tree))” with a new Bonsai Name. Botanics, placement, pot, and acquisition are copied. Photos, measurements, and notes stay on the original.")
                } else {
                    Text("Create a tree with a new Bonsai Name. Photos and history stay on the original.")
                }
            }
            .alert("Could Not Duplicate Tree Info", isPresented: $copyFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(copyErrorMessage)
            }
        }
        .frame(minWidth: 420, minHeight: 420)
    }

    private func performCopy(_ tree: Tree) {
        let genusName = tree.genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let speciesName: String = {
            guard let id = tree.speciesID, let species = referenceData.species(id: id) else {
                return ""
            }
            return species.epithet.isEmpty ? species.name : species.epithet
        }()
        let cultivarName = tree.cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        do {
            let copy = try treeService.duplicateTree(
                id: tree.id,
                genusName: genusName,
                speciesName: speciesName,
                cultivarName: cultivarName
            )
            appState.selectedSection = .gardenTrees
            appState.selectedTreeID = copy.id
            dismiss()
        } catch {
            copyErrorMessage = error.localizedDescription.isEmpty
                ? "Tree info could not be duplicated. Try again."
                : error.localizedDescription
            copyFailed = true
        }
    }
}
