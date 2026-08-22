//
//  TreeBotanicalHierarchyPickers.swift
//  Bonsai World
//
//  Cascading Genus → Species → Cultivar pickers driven by ReferenceDataService.
//  Filtering uses genusID / speciesID relationships — never hardcoded name lists.
//

import SwiftUI

struct TreeBotanicalHierarchyPickers: View {
    @Environment(ReferenceDataService.self) private var referenceData

    @Binding var genusID: UUID?
    @Binding var speciesID: UUID?
    @Binding var cultivarID: UUID?

    private var availableSpecies: [Species] {
        guard let genusID else { return [] }
        return referenceData.species(forGenusID: genusID)
    }

    private var availableCultivars: [Cultivar] {
        guard let speciesID else { return [] }
        return referenceData.cultivars(forSpeciesID: speciesID)
    }

    var body: some View {
        Group {
            botanicalPicker(
                title: "Genus",
                selection: $genusID,
                placeholder: "Select Genus",
                items: referenceData.genus
            )

            botanicalPicker(
                title: "Species",
                selection: $speciesID,
                placeholder: "Select Species",
                items: availableSpecies
            )
            .disabled(genusID == nil)

            botanicalPicker(
                title: "Cultivar",
                selection: $cultivarID,
                placeholder: "Select Cultivar",
                items: availableCultivars
            )
            .disabled(speciesID == nil)
        }
        .onChange(of: genusID) { _, newGenusID in
            invalidateSpeciesIfNeeded(forGenusID: newGenusID)
        }
        .onChange(of: speciesID) { _, newSpeciesID in
            invalidateCultivarIfNeeded(forSpeciesID: newSpeciesID)
        }
    }

    private func invalidateSpeciesIfNeeded(forGenusID newGenusID: UUID?) {
        guard let speciesID else {
            // No species → ensure cultivar cannot linger without a parent.
            cultivarID = nil
            return
        }
        let stillValid =
            newGenusID != nil
            && referenceData.species(id: speciesID)?.genusID == newGenusID
            && availableSpecies.contains { $0.id == speciesID }
        if !stillValid {
            self.speciesID = nil
            self.cultivarID = nil
        }
    }

    private func invalidateCultivarIfNeeded(forSpeciesID newSpeciesID: UUID?) {
        guard let cultivarID else { return }
        let stillValid =
            newSpeciesID != nil
            && referenceData.cultivar(id: cultivarID)?.speciesID == newSpeciesID
            && availableCultivars.contains { $0.id == cultivarID }
        if !stillValid {
            self.cultivarID = nil
        }
    }

    private func botanicalPicker<Item: Identifiable>(
        title: String,
        selection: Binding<UUID?>,
        placeholder: String,
        items: [Item]
    ) -> some View where Item.ID == UUID, Item: ReferenceNamedItem {
        Picker(title, selection: selection) {
            Text(placeholder).tag(Optional<UUID>.none)
            ForEach(items) { item in
                Text(item.name).tag(Optional(item.id))
            }
        }
    }
}

extension Genus: ReferenceNamedItem {}
extension Species: ReferenceNamedItem {}
extension Cultivar: ReferenceNamedItem {}

@MainActor
enum TreeBotanicalSelection {
    /// Uses stored botanical IDs on Tree (domain source of truth).
    static func ids(
        matching tree: Tree,
        referenceData: ReferenceDataService
    ) -> (genusID: UUID?, speciesID: UUID?, cultivarID: UUID?) {
        _ = referenceData
        return (tree.genusID, tree.speciesID, tree.cultivarID)
    }
}
