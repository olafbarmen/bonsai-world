//
//  UserProfileStore.swift
//  Bonsai World
//
//  User Profile + Gardens. Geographic root for Maps, Weather, AI, Work, Notifications.
//  Name / email / language / profile image ID:
//  - Always mirrored in UserDefaults (available before a library opens)
//  - Also stored in Database/UserProfile.json once a library is attached (ZIP backup / restore)
//  Gardens persist through GardenRepository (UserDefaults → Database/Gardens.json).
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
    /// When set, profile fields are also written to ``LibraryPackageLayout/userProfileFileName``.
    private var libraryStorage: StorageService?

    var name: String = ""
    var email: String = ""
    var language: AppLanguage = .english
    /// Optional library image for the sidebar avatar (display crop only). Nil → SF Symbol fallback.
    var profileImageID: UUID?

    private(set) var gardens: [Garden] = []
    private(set) var revision: Int = 0

    private var isLoading = false

    /// Persist name / email / language / photo after UI edits (do not rely on didSet alone).
    func noteProfileFieldsChanged() {
        persistProfileFieldsIfNeeded()
    }

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

    /// Binds profile storage to the open library.
    /// - Prefer library file when it has name or photo (ZIP restore / normal launch).
    /// - Otherwise keep in-memory prefs and write them into the library file.
    func attachLibraryProfileStorage(_ storage: StorageService) {
        libraryStorage = storage
        reconcileProfileWithLibrary(preferLibraryIdentity: true)
    }

    /// After ZIP replace: always re-read the library file; never keep stale empty prefs over a restored profile.
    func reloadProfileAfterLibraryReplace(_ storage: StorageService) {
        libraryStorage = storage
        reconcileProfileWithLibrary(preferLibraryIdentity: true)
    }

    /// Writes the current profile into the open library immediately (call before ZIP export).
    func flushProfileToOpenLibrary() {
        persistProfileToUserDefaults()
        persistProfileToLibraryIfNeeded()
    }

    private func reconcileProfileWithLibrary(preferLibraryIdentity: Bool) {
        guard libraryStorage != nil else { return }

        let memoryHasIdentity = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || profileImageID != nil

        if let snapshot = libraryStorage.flatMap({ Self.loadProfileFile(from: $0) }) {
            let libraryHasIdentity = !snapshot.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || snapshot.profileImageID != nil

            if libraryHasIdentity {
                applyProfileSnapshot(snapshot, persistMirror: true)
                return
            }

            // Library file exists but is empty — keep memory if the grower already typed a name.
            if memoryHasIdentity {
                persistProfileToLibraryIfNeeded()
                return
            }

            if preferLibraryIdentity {
                applyProfileSnapshot(snapshot, persistMirror: true)
            }
            return
        }

        // No library file yet — create one from current prefs.
        persistProfileToLibraryIfNeeded()
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

    /// Clears profile fields and gardens after Empty Personal Library.
    /// Leaves one fresh default Garden so Maps / Weather still have a geographic root.
    func resetPersonalProfileForEmptyLibrary() {
        isLoading = true
        name = ""
        email = ""
        language = .english
        profileImageID = nil
        isLoading = false
        persistProfileFieldsIfNeeded()

        try? gardenRepository.discardPersistedCatalog()
        let garden = Garden(
            id: GardenSeed.defaultGardenID,
            name: "My Garden",
            isActive: true,
            isDefault: true
        )
        gardens = [garden]
        revision += 1
        persistGardensIfNeeded()
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
        persistProfileToUserDefaults()
        persistProfileToLibraryIfNeeded()
        revision += 1
    }

    private func persistProfileToUserDefaults() {
        let snapshot = LibraryUserProfileFile(
            name: name,
            email: email,
            language: language,
            profileImageID: profileImageID
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: Self.profileStorageKey)
    }

    private func persistProfileToLibraryIfNeeded() {
        guard let storage = libraryStorage else { return }
        let snapshot = LibraryUserProfileFile(
            name: name,
            email: email,
            language: language,
            profileImageID: profileImageID
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(snapshot) else { return }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.userProfileFileName,
                data: data
            )
        } catch {
            // Fallback: write beside Trees.json when the storage provider write fails.
            guard let root = storage.libraryPackageRootURL else { return }
            let folder = root.appendingPathComponent(LibraryPackageLayout.database, isDirectory: true)
            let url = folder.appendingPathComponent("UserProfile.json", isDirectory: false)
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            try? data.write(to: url, options: .atomic)
        }
    }

    private func applyProfileSnapshot(_ snapshot: LibraryUserProfileFile, persistMirror: Bool) {
        isLoading = true
        name = snapshot.name
        email = snapshot.email
        language = snapshot.language
        profileImageID = snapshot.profileImageID
        isLoading = false
        if persistMirror {
            persistProfileToUserDefaults()
        }
        revision += 1
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
           let snapshot = try? JSONDecoder().decode(LibraryUserProfileFile.self, from: data) {
            name = snapshot.name
            email = snapshot.email
            language = snapshot.language
            profileImageID = snapshot.profileImageID
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

    private static func loadProfileFile(from storage: StorageService) -> LibraryUserProfileFile? {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.userProfileFileName
            ) else {
                return nil
            }
            return try JSONDecoder().decode(LibraryUserProfileFile.self, from: data)
        } catch {
            return nil
        }
    }
}

/// On-disk / UserDefaults envelope for profile fields (included in library ZIP).
struct LibraryUserProfileFile: Codable, Hashable, Sendable {
    var name: String
    var email: String
    var language: AppLanguage
    var profileImageID: UUID?

    init(name: String, email: String, language: AppLanguage, profileImageID: UUID? = nil) {
        self.name = name
        self.email = email
        self.language = language
        self.profileImageID = profileImageID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .english
        profileImageID = try container.decodeIfPresent(UUID.self, forKey: .profileImageID)
    }
}

/// Shape of the pre-refactor combined profile blob (`falo.userProfile.v1`).
/// Read-only fallback for one-time migration — never written by this store.
private struct LegacyPersistedProfile: Codable {
    var name: String
    var email: String
    var language: AppLanguage
    var gardens: [Garden]
}
