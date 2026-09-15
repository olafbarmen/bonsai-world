//
//  TreeBotanicalIdentityRepair.swift
//  Bonsai World
//
//  Aligns Tree genus / species / cultivar IDs with the stored Botanical Name.
//  Used when Lists order changes — Botanical Name is the source of truth.
//  Matching is always genus-scoped (never epithet-only across genera).
//

import Foundation

enum TreeBotanicalIdentityRepair {
    struct Catalog: Sendable {
        var genera: [Genus]
        var species: [Species]
        var cultivars: [Cultivar]
    }

    /// Copy with botanical IDs aligned to Botanical Name, or `nil` when nothing should change.
    static func repaired(_ tree: Tree, catalog: Catalog) -> Tree? {
        let parts = TreeNamingService.namingParts(fromBotanicalName: tree.botanicalName)
        guard !parts.genus.isEmpty else { return nil }

        guard let genus = matchGenus(parts.genus, in: catalog.genera) else {
            return nil
        }

        let matchedSpecies = matchSpecies(
            genus: genus,
            speciesText: parts.species,
            in: catalog.species
        )

        let matchedCultivar: Cultivar?
        if let species = matchedSpecies, let cultivarName = parts.cultivar, !cultivarName.isEmpty {
            matchedCultivar = matchCultivar(
                name: cultivarName,
                speciesID: species.id,
                in: catalog.cultivars
            )
        } else {
            matchedCultivar = nil
        }

        let nextGenusID: UUID? = genus.id
        let nextSpeciesID: UUID? = matchedSpecies?.id
        let nextCultivarID: UUID? = matchedCultivar?.id

        guard tree.genusID != nextGenusID
            || tree.speciesID != nextSpeciesID
            || tree.cultivarID != nextCultivarID
        else {
            return nil
        }

        var updated = tree
        updated.genusID = nextGenusID
        updated.speciesID = nextSpeciesID
        updated.cultivarID = nextCultivarID
        return updated
    }

    // MARK: - Matching

    static func genusKey(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.caseInsensitiveCompare("Lind") == .orderedSame { return "tilia" }
        if trimmed.caseInsensitiveCompare("Caprinus") == .orderedSame { return "carpinus" }
        if let open = trimmed.firstIndex(of: "("), open > trimmed.startIndex {
            return String(trimmed[..<open])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
        }
        return trimmed.lowercased()
    }

    private static func matchGenus(_ name: String, in genera: [Genus]) -> Genus? {
        let key = genusKey(name)
        let matches = genera.filter { genusKey($0.name) == key }
        return matches.count == 1 ? matches[0] : nil
    }

    private static func matchSpecies(
        genus: Genus,
        speciesText: String,
        in species: [Species]
    ) -> Species? {
        let needle = speciesText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return nil }

        let inGenus = species.filter { $0.genusID == genus.id }
        let matches = inGenus.filter { speciesMatches($0, genus: genus, needle: needle) }
        return matches.count == 1 ? matches[0] : nil
    }

    private static func speciesMatches(_ species: Species, genus: Genus, needle: String) -> Bool {
        if species.name.caseInsensitiveCompare(needle) == .orderedSame {
            return true
        }
        if !species.epithet.isEmpty,
           species.epithet.caseInsensitiveCompare(needle) == .orderedSame {
            return true
        }
        let binomial = TreeNamingService.binomial(genus: genus.name, species: needle)
        return species.name.caseInsensitiveCompare(binomial) == .orderedSame
    }

    private static func matchCultivar(
        name: String,
        speciesID: UUID,
        in cultivars: [Cultivar]
    ) -> Cultivar? {
        let matches = cultivars.filter {
            $0.speciesID == speciesID
                && $0.name.caseInsensitiveCompare(name) == .orderedSame
        }
        return matches.count == 1 ? matches[0] : nil
    }
}
