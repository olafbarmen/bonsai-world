//
//  PotBrandMigrationService.swift
//  Bonsai World
//
//  Migrates curated Pot Brand / Maker seed into Database/PotBrandsAndMakers.json.
//  Seed Reference Data v1 replaces prior system-seed rows when seedVersion is
//  outdated, while preserving user-created records (isSystemSeed == false).
//

import Foundation

/// First-run / seed-version migration of curated pot brand / maker data.
@MainActor
enum PotBrandMigrationService {

    enum Result: Sendable, Equatable {
        case skippedLibraryNotReady
        case notRequired
        case migrated(brandCount: Int, makerCount: Int)
        case failed
    }

    @discardableResult
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        previewRepository: PreviewPotBrandRepository,
        libraryRepository: LibraryPotBrandRepository
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        let targetVersion = PotBrandPreviewData.seedVersion
        let existingVersion = libraryRepository.getSeedVersion() ?? 0
        let existingBrands = libraryRepository.getAllBrands()
        let existingMakers = libraryRepository.getAllMakers()
        let fileExists = persistentCatalogExists(in: storage)

        // Up to date and non-empty (or intentionally empty user catalog after seed).
        if fileExists, existingVersion >= targetVersion {
            return .notRequired
        }

        let seedBrands = previewRepository.getAllBrands()
        let seedMakers = previewRepository.getAllMakers()

        let userBrands = existingBrands.filter { !$0.isSystemSeed }
        let userMakers = existingMakers.filter { !$0.isSystemSeed }

        // Drop prior system seed; keep user rows; attach current curated seed.
        var mergedBrands = seedBrands
        var mergedMakers = seedMakers

        let seedBrandIDs = Set(seedBrands.map(\.id))
        let seedMakerIDs = Set(seedMakers.map(\.id))
        for brand in userBrands where !seedBrandIDs.contains(brand.id) {
            mergedBrands.append(brand)
        }
        for maker in userMakers where !seedMakerIDs.contains(maker.id) {
            // Keep user makers whose Brand still exists (seed or user).
            if let brandID = maker.brandID {
                let brandOK = mergedBrands.contains { $0.id == brandID }
                if brandOK { mergedMakers.append(maker) }
            } else {
                mergedMakers.append(maker)
            }
        }

        let expectedBrandIDs = Set(mergedBrands.map(\.id))
        let expectedMakerIDs = Set(mergedMakers.map(\.id))

        do {
            try libraryRepository.replaceCatalog(
                brands: mergedBrands,
                makers: mergedMakers,
                seedVersion: targetVersion
            )
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedBrandCount: mergedBrands.count,
            expectedMakerCount: mergedMakers.count,
            expectedBrandIDs: expectedBrandIDs,
            expectedMakerIDs: expectedMakerIDs,
            expectedSeedVersion: targetVersion
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        return .migrated(brandCount: seedBrands.count, makerCount: seedMakers.count)
    }

    static func persistentCatalogExists(in storage: StorageService) -> Bool {
        do {
            return try storage.loadPackageFile(relativePath: LibraryPackageLayout.potBrandsFileName) != nil
        } catch {
            return false
        }
    }

    private static func verifyPersistedCatalog(
        in storage: StorageService,
        libraryRepository: LibraryPotBrandRepository,
        expectedBrandCount: Int,
        expectedMakerCount: Int,
        expectedBrandIDs: Set<UUID>,
        expectedMakerIDs: Set<UUID>,
        expectedSeedVersion: Int
    ) -> Bool {
        guard persistentCatalogExists(in: storage) else { return false }
        guard libraryRepository.getSeedVersion() == expectedSeedVersion else { return false }

        let brands = libraryRepository.getAllBrands()
        let makers = libraryRepository.getAllMakers()
        guard brands.count == expectedBrandCount, makers.count == expectedMakerCount else {
            return false
        }

        return Set(brands.map(\.id)) == expectedBrandIDs
            && Set(makers.map(\.id)) == expectedMakerIDs
    }
}
