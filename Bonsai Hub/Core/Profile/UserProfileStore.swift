//
//  UserProfileStore.swift
//  Bonsai World
//
//  User Profile + Gardens. Geographic root for Maps, Weather, AI, Work, Notifications.
//  Persisted in UserDefaults for session continuity (library persistence later).
//

import Foundation
import Observation

@Observable
@MainActor
final class UserProfileStore {
    private static let storageKey = "falo.userProfile.v1"
    private static let legacyGardenAddressKey = "falo.appSettings.gardenAddress"

    var name: String = "" {
        didSet { persistIfNeeded() }
    }

    var email: String = "" {
        didSet { persistIfNeeded() }
    }

    var language: AppLanguage = .english {
        didSet { persistIfNeeded() }
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

    init() {
        loadOrCreate()
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
        persistIfNeeded()
    }

    private func persistIfNeeded() {
        guard !isLoading else { return }
        let snapshot = PersistedProfile(
            name: name,
            email: email,
            language: language,
            gardens: gardens
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    private func loadOrCreate() {
        isLoading = true
        defer { isLoading = false }

        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let snapshot = try? JSONDecoder().decode(PersistedProfile.self, from: data) {
            name = snapshot.name
            email = snapshot.email
            language = snapshot.language
            gardens = snapshot.gardens
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
        persistIfNeeded()
    }
}

private struct PersistedProfile: Codable {
    var name: String
    var email: String
    var language: AppLanguage
    var gardens: [Garden]
}
