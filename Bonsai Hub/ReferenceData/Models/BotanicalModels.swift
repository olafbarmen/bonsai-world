//
//  BotanicalModels.swift
//  Bonsai World
//
//  Hierarchy models for Settings → Reference Data → Botanical Library.
//  Genus → Species → Cultivar is one structure — never independent lists.
//  Platform-independent; UI may adapt per client.
//

import Foundation

enum BotanicalKind: String, CaseIterable, Identifiable, Hashable, Sendable {
    case genus
    case species
    case cultivar

    var id: Self { self }

    var title: String {
        switch self {
        case .genus: "Genus"
        case .species: "Species"
        case .cultivar: "Cultivar"
        }
    }

    var nameFieldLabel: String {
        switch self {
        case .genus: "Genus Name"
        case .species: "Species Name"
        case .cultivar: "Cultivar Name"
        }
    }

    var systemImage: String {
        switch self {
        case .genus: "leaf.fill"
        case .species: "leaf"
        case .cultivar: "sparkles"
        }
    }
}

/// Column navigation state for the Botanical Library (platform-independent).
struct BotanicalLibraryContext: Hashable, Sendable {
    var selectedGenusID: UUID?
    var selectedSpeciesID: UUID?
    var selectedCultivarID: UUID?

    /// Deepest current selection (Cultivar → Species → Genus).
    var focus: BotanicalSelection? {
        if let id = selectedCultivarID {
            return BotanicalSelection(id: id, kind: .cultivar)
        }
        if let id = selectedSpeciesID {
            return BotanicalSelection(id: id, kind: .species)
        }
        if let id = selectedGenusID {
            return BotanicalSelection(id: id, kind: .genus)
        }
        return nil
    }

    /// What Add creates given the current columns — never chosen by the user.
    var addKind: BotanicalKind {
        if selectedSpeciesID != nil { return .cultivar }
        if selectedGenusID != nil { return .species }
        return .genus
    }

    mutating func selectGenus(_ id: UUID?) {
        selectedGenusID = id
        selectedSpeciesID = nil
        selectedCultivarID = nil
    }

    mutating func selectSpecies(_ id: UUID?) {
        selectedSpeciesID = id
        selectedCultivarID = nil
    }

    mutating func selectCultivar(_ id: UUID?) {
        selectedCultivarID = id
    }
}

/// Selection identity for edit / delete / active toggle.
struct BotanicalSelection: Hashable, Sendable {
    var id: UUID
    var kind: BotanicalKind
}

/// Draft for the Botanical Editor (Add / Edit). Parents come from context only.
struct BotanicalDraft: Identifiable, Hashable, Sendable {
    /// Stable identity for sheet presentation.
    var id: UUID
    /// Existing entity id when editing; `nil` when creating.
    var entityID: UUID?
    var kind: BotanicalKind
    var name: String
    var sortOrder: Int
    var isActive: Bool
    /// Required when kind == .species or .cultivar (read-only in UI).
    var genusID: UUID?
    /// Required when kind == .cultivar (read-only in UI).
    var speciesID: UUID?

    var isNew: Bool { entityID == nil }

    static func newGenus(sortOrder: Int) -> BotanicalDraft {
        BotanicalDraft(
            id: UUID(),
            entityID: nil,
            kind: .genus,
            name: "",
            sortOrder: sortOrder,
            isActive: true,
            genusID: nil,
            speciesID: nil
        )
    }

    static func newSpecies(genusID: UUID, sortOrder: Int) -> BotanicalDraft {
        BotanicalDraft(
            id: UUID(),
            entityID: nil,
            kind: .species,
            name: "",
            sortOrder: sortOrder,
            isActive: true,
            genusID: genusID,
            speciesID: nil
        )
    }

    static func newCultivar(genusID: UUID, speciesID: UUID, sortOrder: Int) -> BotanicalDraft {
        BotanicalDraft(
            id: UUID(),
            entityID: nil,
            kind: .cultivar,
            name: "",
            sortOrder: sortOrder,
            isActive: true,
            genusID: genusID,
            speciesID: speciesID
        )
    }
}
