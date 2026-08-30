//
//  UserProfileStore.swift
//  Bonsai World
//
//  User Profile + Gardens. Geographic root for Maps, Weather, AI, Work, Notifications.
//  Name / email / language persist in UserDefaults (lightweight user prefs).
//  Gardens persist through an injected GardenRepository — UserDefaults before a
//  Library exists, Database/Gardens.json once one is open (see
//  GardenMigrationService and ``attachLibraryGardenRepository(_:)``).
//

import Foundation
import Observation

@Observable
@MainActor
final class UserProfileStore {
    private static let profileStorageKey = "falo.userProfile.profile.v1"
    private static let legacyCombinedKey = "falo.userProfile.v1"
    private static let legacyGardenAddressKey = "falo.appSettings.gardenAddress"

    private var gardenRepository: GardenRepository

    var name: String = "" {
        didSet { persistProfileFieldsIfNeeded() }
    }

    var email: String = "" {
        didSet { persistProfileFieldsIfNeeded() }
    }

    var language: AppLanguage = .english {
        didSet { persistProfileFieldsIfNeeded() }
    }

    private(set) var gardens: [Garden] = []
    private(set) var revision: Int = 0

    private var isLoading = false

    /// Default Garden — geographic context for Maps / Weather / AI / Dashboard.
    var defaultGarden: Garden? {
        _ = revision
        return gardens.first(where: \.isDefault) ?? gardens.first(where: \.isActive) ?? gardens.first
    }

    var activeGardens: [Garden] {
        _ = revision
        return gardens
            .filter(\.isActive)
            .sorted {
                if $0.isDefault != $1.isDefault { return $0.isDefault && !$1.isDefault }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    init(gardenRepository: GardenRepository? = nil) {
        self.gardenRepository = gardenRepository ?? UserDefaultsGardenRepository()
        loadOrCreate()
    }

    /// Switches Garden persistence to a Library-backed repository once one becomes
    /// available (mirrors `ImageService.attachStorage(_:)`). Adopts the repository's
    /// existing gardens if it already has any (second launch of the same Library);
    /// otherwise the caller is expected to have migrated the prior source into it
    /// first (see `GardenMigrationService`), so this simply re-reads the result.
    func attachLibraryGardenRepository(_ repository: GardenRepository) {
        gardenRepository = repository
        let loaded = repository.getAllGardens()
        if !loaded.isEmpty {
            gardens = loaded
            ensureSingleDefault()
        }
        revision += 1
    }

    // MARK: - Gardens

    func garden(id: UUID) -> Garden? {
        _ = revision
        return gardens.first { $0.id == id }
    }

    @discardableResult
    func saveGarden(_ garden: Garden) -> Garden {
        var working = garden
        working.name = working.name.trimmingCharacters(in: .whitespacesAndNewlines)
        working.address = working.address.trimmingCharacters(in: .whitespacesAndNewlines)
        working.postalCode = working.postalCode.trimmingCharacters(in: .whitespacesAndNewlines)
        working.city = working.city.trimmingCharacters(in: .whitespacesAndNewlines)
        working.country = working.country.trimmingCharacters(in: .whitespacesAndNewlines)
        working.region = working.region.trimmingCharacters(in: .whitespacesAndNewlines)
        working.hardinessZone = working.hardinessZone.trimmingCharacters(in: .whitespacesAndNewlines)

        if working.isDefault {
            for index in gardens.indices {
                gardens[index].isDefault = gardens[index].id == working.id
            }
            working.isDefault = true
        } else if gardens.contains(where: { $0.id == working.id && $0.isDefault }) {
            // Keep at least one default when unchecking the current default.
            working.isDefault = true
        } else if !gardens.contains(where: \.isDefault) {
            working.isDefault = true
        }

        if let index = gardens.firstIndex(where: { $0.id == working.id }) {
            gardens[index] = working
        } else {
            if gardens.isEmpty {
                working.isDefault = true
            }
            gardens.append(working)
        }

        ensureSingleDefault()
        noteMutation()
        return working
    }

    func setDefaultGarden(id: UUID) {
        guard gardens.contains(where: { $0.id == id }) else { return }
        for index in gardens.indices {
            gardens[index].isDefault = gardens[index].id == id
        }
        noteMutation()
    }

    func setGardenActive(id: UUID, isActive: Bool) {
        guard let index = gardens.firstIndex(where: { $0.id == id }) else { return }
        gardens[index].isActive = isActive
        if !isActive, gardens[index].isDefault {
            if let replacement = gardens.first(where: { $0.id != id && $0.isActive }) {
                setDefaultGarden(id: replacement.id)
                return
            }
        }
        ensureSingleDefault()
        noteMutation()
    }

    func deleteGarden(id: UUID) {
        guard gardens.count > 1 else { return }
        let wasDefault = gardens.first(where: { $0.id == id })?.isDefault == true
        gardens.removeAll { $0.id == id }
        if wasDefault, let first = gardens.first(where: \.isActive) ?? gardens.first {
            setDefaultGarden(id: first.id)
            return
        }
        ensureSingleDefault()
        noteMutation()
    }

    func blankGardenDraft() -> Garden {
        Garden(
            name: "",
            isActive: true,
            isDefault: gardens.isEmpty
        )
    }

    /// Sets or clears the manually selected Garden Position. Never geocodes Address.
    func updateGardenPosition(id: UUID, coordinate: GeographicCoordinate?) {
        guard let index = gardens.firstIndex(where: { $0.id == id }) else { return }
        if let coordinate {
            gardens[index].setGardenPosition(coordinate)
        } else {
            gardens[index].clearGardenPosition()
        }
        noteMutation()
    }

    // MARK: - Private

    private func ensureSingleDefault() {
        let defaults = gardens.filter(\.isDefault)
        if defaults.isEmpty, let first = gardens.first(where: \.isActive) ?? gardens.first {
            if let index = gardens.firstIndex(where: { $0.id == first.id }) {
                gardens[index].isDefault = true
            }
        } else if defaults.count > 1 {
            var kept = false
            for index in gardens.indices {
                if gardens[index].isDefault {
                    if kept {
                        gardens[index].isDefault = false
                    } else {
                        kept = true
                    }
                }
            }
        }
    }

    private func noteMutation() {
        revision += 1
        persistGardensIfNeeded()
    }

    private func persistGardensIfNeeded() {
        guard !isLoading else { return }
        try? gardenRepository.replaceCatalog(with: gardens)
    }

    private func persistProfileFieldsIfNeeded() {
        guard !isLoading else { return }
        let snapshot = PersistedProfileFields(name: name, email: email, language: language)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.profileStorageKey)
    }

    private func loadOrCreate() {
        isLoading = true
        defer { isLoading = false }

        loadProfileFields()

        let existingGardens = gardenRepository.getAllGardens()
        if !existingGardens.isEmpty {
            gardens = existingGardens
            ensureSingleDefault()
            revision += 1
            return
        }

        // Migrate legacy single garden address from Regional Settings, if present.
        let legacyAddress = UserDefaults.standard.string(forKey: Self.legacyGardenAddressKey) ?? ""
        let garden = Garden(
            id: GardenSeed.defaultGardenID,
            name: "My Garden",
            address: legacyAddress,
            isActive: true,
            isDefault: true
        )
        gardens = [garden]
        UserDefaults.standard.removeObject(forKey: Self.legacyGardenAddressKey)
        revision += 1
        persistGardensIfNeeded()
    }

    private func loadProfileFields() {
        if let data = UserDefaults.standard.data(forKey: Self.profileStorageKey),
           let snapshot = try? JSONDecoder().decode(PersistedProfileFields.self, from: data) {
            name = snapshot.name
            email = snapshot.email
            language = snapshot.language
            return
        }

        // One-time fallback: recover profile fields from the legacy combined blob
        // (pre-dates the dedicated profile-fields key).
        if let data = UserDefaults.standard.data(forKey: Self.legacyCombinedKey),
           let legacy = try? JSONDecoder().decode(LegacyPersistedProfile.self, from: data) {
            name = legacy.name
            email = legacy.email
            language = legacy.language
        }
    }
}

private struct PersistedProfileFields: Codable {
    var name: String
    var email: String
    var language: AppLanguage
}

/// Shape of the pre-refactor combined profile blob (`falo.userProfile.v1`).
/// Read-only fallback for one-time migration — never written by this store.
private struct LegacyPersistedProfile: Codable {
    var name: String
    var email: String
    var language: AppLanguage
    var gardens: [Garden]
}
