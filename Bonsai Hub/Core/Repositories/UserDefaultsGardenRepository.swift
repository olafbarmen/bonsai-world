//
//  UserDefaultsGardenRepository.swift
//  Bonsai World
//
//  GardenRepository backed by UserDefaults — used before a Library exists
//  (First Launch Wizard) and by SwiftUI #Preview fixtures. Once a Library is
//  ready, UserProfileStore switches to LibraryGardenRepository via
//  GardenMigrationService, which reads this repository as its source.
//

import Foundation

/// One-time fallback shape for gardens saved by the pre-refactor combined
/// profile blob (`falo.userProfile.v1`, `name`/`email`/`language`/`gardens`).
private struct LegacyPersistedProfile: Codable {
    var name: String
    var email: String
    var language: AppLanguage
    var gardens: [Garden]
}

/// In-memory-on-disk `GardenRepository` for pre-library sessions and previews.
@MainActor
final class UserDefaultsGardenRepository: GardenRepository {
    private static let storageKey = "falo.userProfile.gardens.v1"
    private static let legacyCombinedKey = "falo.userProfile.v1"

    func getAllGardens() -> [Garden] {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let gardens = try? JSONDecoder().decode([Garden].self, from: data) {
            return gardens
        }

        // One-time fallback: recover gardens from the legacy combined profile blob
        // (pre-dates the dedicated Gardens key) so real user data is never lost.
        if let data = UserDefaults.standard.data(forKey: Self.legacyCombinedKey),
           let legacy = try? JSONDecoder().decode(LegacyPersistedProfile.self, from: data),
           !legacy.gardens.isEmpty {
            try? replaceCatalog(with: legacy.gardens)
            return legacy.gardens
        }

        return []
    }

    func getGarden(id: UUID) -> Garden? {
        getAllGardens().first { $0.id == id }
    }

    func replaceCatalog(with gardens: [Garden]) throws {
        let data = try JSONEncoder().encode(gardens)
        UserDefaults.standard.set(data, forKey: Self.storageKey)
    }

    func discardPersistedCatalog() throws {
        UserDefaults.standard.removeObject(forKey: Self.storageKey)
    }
}
