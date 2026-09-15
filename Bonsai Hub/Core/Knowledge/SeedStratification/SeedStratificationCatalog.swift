//
//  SeedStratificationCatalog.swift
//  Bonsai World
//
//  Single source of truth for species stratification profiles.
//  Loaded from SeedStratificationCatalogData; Settings presents and will later edit.
//

import Foundation
import Observation

@MainActor
protocol SeedStratificationCatalogProviding: AnyObject {
    var profiles: [SpeciesStratificationProfile] { get }
    func profile(speciesID: UUID) -> SpeciesStratificationProfile?
    func profile(matchingScientificName name: String) -> SpeciesStratificationProfile?
    func matching(search: String) -> [SpeciesStratificationProfile]
}

@Observable
@MainActor
final class SeedStratificationCatalogService: SeedStratificationCatalogProviding {
    private(set) var profiles: [SpeciesStratificationProfile]

    init(profiles: [SpeciesStratificationProfile] = SeedStratificationCatalogData.all) {
        self.profiles = profiles
    }

    func profile(speciesID: UUID) -> SpeciesStratificationProfile? {
        profiles.first { $0.speciesID == speciesID }
    }

    func profile(matchingScientificName name: String) -> SpeciesStratificationProfile? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return profiles.first {
            $0.scientificName.caseInsensitiveCompare(trimmed) == .orderedSame
        }
    }

    func matching(search: String) -> [SpeciesStratificationProfile] {
        let query = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard query.count >= 2 else { return [] }
        return profiles.filter { $0.searchText.contains(query) }
    }

    func replaceProfiles(_ profiles: [SpeciesStratificationProfile]) {
        self.profiles = profiles.sorted {
            $0.scientificName.localizedCaseInsensitiveCompare($1.scientificName) == .orderedAscending
        }
    }
}
