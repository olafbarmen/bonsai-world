//
//  BotanicalService.swift
//  Bonsai World
//
//  Hierarchical Genus → Species → Cultivar management for Botanical Library.
//  Platform-independent service. Views must not touch ReferencePreviewData.
//  No persistence.
//

import Foundation
import Observation

@Observable
@MainActor
final class BotanicalService {
    private let store: ReferencePreviewData

    init(store: ReferencePreviewData) {
        self.store = store
    }

    var revision: Int { store.revision }

    // MARK: - Column queries

    func genera() -> [Genus] {
        _ = store.revision
        return store.genus.sorted(by: Self.sortGenus)
    }

    func species(forGenusID genusID: UUID) -> [Species] {
        _ = store.revision
        return store.species
            .filter { $0.genusID == genusID }
            .sorted(by: Self.sortSpecies)
    }

    func cultivars(forSpeciesID speciesID: UUID) -> [Cultivar] {
        _ = store.revision
        return store.cultivars
            .filter { $0.speciesID == speciesID }
            .sorted(by: Self.sortCultivar)
    }

    func genus(id: UUID) -> Genus? {
        _ = store.revision
        return store.genus.first { $0.id == id }
    }

    func species(id: UUID) -> Species? {
        _ = store.revision
        return store.species.first { $0.id == id }
    }

    func cultivar(id: UUID) -> Cultivar? {
        _ = store.revision
        return store.cultivars.first { $0.id == id }
    }

    func genusName(id: UUID) -> String? {
        genus(id: id)?.name
    }

    func speciesName(id: UUID) -> String? {
        species(id: id)?.name
    }

    /// Species label for the Species column (epithet when available).
    func speciesColumnLabel(_ species: Species) -> String {
        let epithet = species.epithet
        return epithet.isEmpty ? species.name : epithet
    }

    // MARK: - Context-aware drafts

    /// Add draft from column context. Kind is never chosen by the user.
    func draftForAdd(context: BotanicalLibraryContext) -> BotanicalDraft {
        switch context.addKind {
        case .genus:
            return .newGenus(sortOrder: nextSortOrder(for: .genus))

        case .species:
            guard let genusID = context.selectedGenusID,
                  store.genus.contains(where: { $0.id == genusID }) else {
                return .newGenus(sortOrder: nextSortOrder(for: .genus))
            }
            return .newSpecies(
                genusID: genusID,
                sortOrder: nextSortOrder(for: .species, parentID: genusID)
            )

        case .cultivar:
            guard let speciesID = context.selectedSpeciesID,
                  let species = store.species.first(where: { $0.id == speciesID }) else {
                if let genusID = context.selectedGenusID {
                    return .newSpecies(
                        genusID: genusID,
                        sortOrder: nextSortOrder(for: .species, parentID: genusID)
                    )
                }
                return .newGenus(sortOrder: nextSortOrder(for: .genus))
            }
            return .newCultivar(
                genusID: species.genusID,
                speciesID: speciesID,
                sortOrder: nextSortOrder(for: .cultivar, parentID: speciesID)
            )
        }
    }

    func draftForEdit(_ selection: BotanicalSelection) -> BotanicalDraft? {
        switch selection.kind {
        case .genus:
            guard let genus = store.genus.first(where: { $0.id == selection.id }) else { return nil }
            return BotanicalDraft(
                id: UUID(),
                entityID: genus.id,
                kind: .genus,
                name: genus.name,
                sortOrder: genus.sortOrder,
                isActive: genus.isActive,
                genusID: nil,
                speciesID: nil
            )
        case .species:
            guard let species = store.species.first(where: { $0.id == selection.id }) else { return nil }
            return BotanicalDraft(
                id: UUID(),
                entityID: species.id,
                kind: .species,
                name: speciesColumnLabel(species),
                sortOrder: species.sortOrder,
                isActive: species.isActive,
                genusID: species.genusID,
                speciesID: nil
            )
        case .cultivar:
            guard let cultivar = store.cultivars.first(where: { $0.id == selection.id }) else { return nil }
            return BotanicalDraft(
                id: UUID(),
                entityID: cultivar.id,
                kind: .cultivar,
                name: cultivar.name,
                sortOrder: cultivar.sortOrder,
                isActive: cultivar.isActive,
                genusID: store.species.first { $0.id == cultivar.speciesID }?.genusID,
                speciesID: cultivar.speciesID
            )
        }
    }

    func nextSortOrder(for kind: BotanicalKind, parentID: UUID? = nil) -> Int {
        switch kind {
        case .genus:
            return (store.genus.map(\.sortOrder).max() ?? -1) + 1
        case .species:
            let pool = parentID.map { id in store.species.filter { $0.genusID == id } } ?? store.species
            return (pool.map(\.sortOrder).max() ?? -1) + 1
        case .cultivar:
            let pool = parentID.map { id in store.cultivars.filter { $0.speciesID == id } } ?? store.cultivars
            return (pool.map(\.sortOrder).max() ?? -1) + 1
        }
    }

    // MARK: - Validation

    enum ValidationError: Equatable {
        case emptyName
        case speciesRequiresGenus
        case cultivarRequiresSpecies
        case genusNotFound
        case speciesNotFound
    }

    func validate(_ draft: BotanicalDraft) -> ValidationError? {
        let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .emptyName }

        switch draft.kind {
        case .genus:
            return nil
        case .species:
            guard let genusID = draft.genusID else { return .speciesRequiresGenus }
            guard store.genus.contains(where: { $0.id == genusID }) else { return .genusNotFound }
            return nil
        case .cultivar:
            guard let speciesID = draft.speciesID else { return .cultivarRequiresSpecies }
            guard store.species.contains(where: { $0.id == speciesID }) else { return .speciesNotFound }
            return nil
        }
    }

    // MARK: - Write

    @discardableResult
    func save(_ draft: BotanicalDraft) -> Bool {
        guard validate(draft) == nil else { return false }

        var working = draft
        working.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)

        switch working.kind {
        case .genus:
            saveGenus(working)
        case .species:
            saveSpecies(working)
        case .cultivar:
            saveCultivar(working)
        }

        store.noteMutation()
        return true
    }

    func setActive(_ selection: BotanicalSelection, isActive: Bool) {
        switch selection.kind {
        case .genus:
            mutate(&store.genus, id: selection.id) { $0.isActive = isActive }
        case .species:
            mutate(&store.species, id: selection.id) { $0.isActive = isActive }
        case .cultivar:
            mutate(&store.cultivars, id: selection.id) { $0.isActive = isActive }
        }
        store.noteMutation()
    }

    /// Deletes the focus and cascades: Genus → Species → Cultivars; Species → Cultivars.
    func delete(_ selection: BotanicalSelection) {
        switch selection.kind {
        case .genus:
            let speciesIDs = Set(store.species.filter { $0.genusID == selection.id }.map(\.id))
            store.cultivars.removeAll { speciesIDs.contains($0.speciesID) }
            store.species.removeAll { $0.genusID == selection.id }
            store.genus.removeAll { $0.id == selection.id }
        case .species:
            store.cultivars.removeAll { $0.speciesID == selection.id }
            store.species.removeAll { $0.id == selection.id }
        case .cultivar:
            store.cultivars.removeAll { $0.id == selection.id }
        }
        store.noteMutation()
    }

    // MARK: - Private

    private func saveGenus(_ draft: BotanicalDraft) {
        if let id = draft.entityID, let index = store.genus.firstIndex(where: { $0.id == id }) {
            store.genus[index].name = draft.name
            store.genus[index].sortOrder = draft.sortOrder
            store.genus[index].isActive = draft.isActive
        } else {
            store.genus.append(
                Genus(id: UUID(), name: draft.name, sortOrder: draft.sortOrder, isActive: draft.isActive)
            )
        }
    }

    private func saveSpecies(_ draft: BotanicalDraft) {
        guard let genusID = draft.genusID,
              let genusName = store.genus.first(where: { $0.id == genusID })?.name else { return }
        let binomial = Self.binomialName(genus: genusName, speciesInput: draft.name)

        if let id = draft.entityID, let index = store.species.firstIndex(where: { $0.id == id }) {
            // Editing preserves parent Genus — never reassign from draft.
            store.species[index].name = binomial
            store.species[index].sortOrder = draft.sortOrder
            store.species[index].isActive = draft.isActive
        } else {
            store.species.append(
                Species(
                    id: UUID(),
                    name: binomial,
                    genusID: genusID,
                    sortOrder: draft.sortOrder,
                    isActive: draft.isActive
                )
            )
        }
    }

    private func saveCultivar(_ draft: BotanicalDraft) {
        if let id = draft.entityID, let index = store.cultivars.firstIndex(where: { $0.id == id }) {
            // Editing preserves parent Species — never reassign from draft.
            store.cultivars[index].name = draft.name
            store.cultivars[index].sortOrder = draft.sortOrder
            store.cultivars[index].isActive = draft.isActive
        } else {
            guard let speciesID = draft.speciesID else { return }
            store.cultivars.append(
                Cultivar(
                    id: UUID(),
                    name: draft.name,
                    speciesID: speciesID,
                    sortOrder: draft.sortOrder,
                    isActive: draft.isActive
                )
            )
        }
    }

    /// Builds `Genus epithet` when the user enters only the epithet (Genus is context).
    private static func binomialName(genus: String, speciesInput: String) -> String {
        let trimmed = speciesInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: " ").map(String.init)
        if let first = parts.first,
           first.caseInsensitiveCompare(genus) == .orderedSame {
            return trimmed
        }
        return "\(genus) \(trimmed)"
    }

    private func mutate<T: Identifiable>(
        _ array: inout [T],
        id: UUID,
        update: (inout T) -> Void
    ) where T.ID == UUID {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        update(&array[index])
    }

    private static func sortGenus(_ a: Genus, _ b: Genus) -> Bool {
        if a.sortOrder != b.sortOrder { return a.sortOrder < b.sortOrder }
        return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
    }

    private static func sortSpecies(_ a: Species, _ b: Species) -> Bool {
        if a.sortOrder != b.sortOrder { return a.sortOrder < b.sortOrder }
        return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
    }

    private static func sortCultivar(_ a: Cultivar, _ b: Cultivar) -> Bool {
        if a.sortOrder != b.sortOrder { return a.sortOrder < b.sortOrder }
        return a.name.localizedCaseInsensitiveCompare(b.name) == .orderedAscending
    }
}
