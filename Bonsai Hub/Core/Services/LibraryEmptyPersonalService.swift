//
//  LibraryEmptyPersonalService.swift
//  Bonsai World
//
//  Empty Personal Library — clears grower belongings; keeps knowledge / reference / brands.
//

import Foundation

enum LibraryEmptyPersonalError: Error, LocalizedError, Sendable {
    case libraryUnavailable
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .libraryUnavailable:
            return "No library is open."
        case .writeFailed(let detail):
            return "Could not write empty catalogs (\(detail))."
        }
    }
}

/// Wipes personal catalogs, image/document bytes, and user profile fields for a clean test start.
@MainActor
enum LibraryEmptyPersonalService {
    /// Confirmation phrase the grower must type exactly.
    static let confirmationPhrase = "EMPTY"

    static func emptyPersonalLibrary(
        storage: StorageService,
        libraryService: LibraryService,
        userProfile: UserProfileStore
    ) throws {
        guard storage.libraryPackageExists(),
              let root = storage.libraryPackageRootURL else {
            throw LibraryEmptyPersonalError.libraryUnavailable
        }

        let fileManager = FileManager.default
        for folder in LibraryPackageLayout.personalContentFolderRelativePaths {
            let url = root.appendingPathComponent(folder, isDirectory: true)
            try clearDirectoryContents(at: url, fileManager: fileManager)
        }

        // Write empty catalogs (do not merely delete). Missing Trees/Collections/
        // Locations/Gardens would re-trigger first-run preview migration on reload.
        try writeEmptyPersonalCatalogs(storage: storage)

        try storage.ensureLibraryFolderStructure()
        userProfile.resetPersonalProfileForEmptyLibrary()
        libraryService.notifyLibraryContentsChanged()
    }

    private static func writeEmptyPersonalCatalogs(storage: StorageService) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        func save(_ value: some Encodable, relativePath: String) throws {
            do {
                let data = try encoder.encode(value)
                try storage.savePackageFile(relativePath: relativePath, data: data)
            } catch {
                throw LibraryEmptyPersonalError.writeFailed(
                    "\(relativePath): \(error.localizedDescription)"
                )
            }
        }

        try save(LibraryTreesFile(), relativePath: LibraryPackageLayout.treesFileName)
        try save(LibraryCollectionsFile(), relativePath: LibraryPackageLayout.collectionsFileName)
        try save(LibraryPotsFile(), relativePath: LibraryPackageLayout.potsFileName)
        try save(LibraryYamadoriFile(), relativePath: LibraryPackageLayout.yamadoriFileName)
        try save(LibrarySeedBatchesFile(), relativePath: LibraryPackageLayout.seedBatchesFileName)
        try save(
            LibraryNurseryPropagationFile(),
            relativePath: LibraryPackageLayout.nurseryPropagationProjectsFileName
        )
        try save(LibraryWorkFile(), relativePath: LibraryPackageLayout.workFileName)
        try save(LibraryJournalFile(), relativePath: LibraryPackageLayout.journalFileName)
        try save(LibraryTaskFile(), relativePath: LibraryPackageLayout.tasksFileName)
        try save(LibraryScheduleFile(), relativePath: LibraryPackageLayout.schedulesFileName)
        try save(LibrarySoilStockFile(), relativePath: LibraryPackageLayout.soilStockFileName)
        try save(
            LibraryInventoryStockFile(),
            relativePath: LibraryPackageLayout.inventoryStockFileName
        )
        try save(LibraryMediaCatalogFile(), relativePath: LibraryPackageLayout.mediaLibraryFileName)
        try save(LibrarySimpleCatalogFile(), relativePath: LibraryPackageLayout.simpleCatalogFileName)
        try save(LibraryLocationsFile(), relativePath: LibraryPackageLayout.locationsFileName)
        try save(LibraryGardensFile(), relativePath: LibraryPackageLayout.gardensFileName)
        try save(
            LibraryUserProfileFile(name: "", email: "", language: .english, profileImageID: nil),
            relativePath: LibraryPackageLayout.userProfileFileName
        )
        try save(TreePhotoIndex(), relativePath: LibraryPackageLayout.treePhotoIndexFileName)
        try save(
            TreeMeasurementHistoryFile(),
            relativePath: LibraryPackageLayout.treeMeasurementHistoryFileName
        )
        try save(BonsaiNameSequenceFile(), relativePath: LibraryPackageLayout.bonsaiNameSequencesFileName)

        // Image catalog / presentations are bare arrays on disk.
        try save([ImageAsset](), relativePath: LibraryPackageLayout.imagesCatalogFileName)
        try save(
            [ImagePresentationMetadata](),
            relativePath: LibraryPackageLayout.imagesPresentationsFileName
        )

        // Empty library: Tree is photo SSOT with no bindings (avoids legacy index fill).
        struct EmptyPhotoSSOT: Encodable {
            var treeIsPhotoSourceOfTruth = true
        }
        try save(EmptyPhotoSSOT(), relativePath: LibraryPackageLayout.treePhotoSSOTStateFileName)
    }

    private static func clearDirectoryContents(at directory: URL, fileManager: FileManager) throws {
        guard fileManager.fileExists(atPath: directory.path) else { return }
        let items = try fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        for item in items {
            try? fileManager.removeItem(at: item)
        }
    }
}
