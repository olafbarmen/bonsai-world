//
//  StorageService.swift
//  Bonsai World
//
//  Single entry point for library file operations.
//  Holds the active StorageProvider and routes all calls through it.
//  The rest of the app must never talk to LocalStorageProvider (or future providers) directly.
//

import Foundation
import Observation

/// App-wide storage facade. Inject via `.environment` and/or use `StorageService.shared`.
@Observable
@MainActor
final class StorageService {
    /// Shared instance for non-SwiftUI call sites. Prefer `@Environment(StorageService.self)` in views.
    static let shared = StorageService()

    private static let lastLibraryBookmarkKey = "bonsai.world.lastLibraryBookmark"

    /// Active provider. Always a `StorageProvider` existential — never expose concrete types to Features.
    private(set) var provider: any StorageProvider

    /// Current library location (for Settings). Changing this rebuilds the local provider in Phase 1.
    private(set) var libraryLocationConfiguration: LibraryLocationConfiguration

    private init() {
        let configuration = LibraryLocationConfiguration.defaultLocal
        self.libraryLocationConfiguration = configuration
        self.provider = LocalStorageProvider.makeDefault()
    }

    /// Testing / explicit bootstrap. Prefer `shared` in production.
    init(provider: any StorageProvider) {
        self.provider = provider
        self.libraryLocationConfiguration = provider.libraryLocation
    }

    // MARK: - Library location

    /// Applies a library location. Phase 1: local kinds only.
    func applyLibraryLocation(_ configuration: LibraryLocationConfiguration) throws {
        guard configuration.kind.isPhase1Local else {
            throw StorageError.providerUnavailable(configuration.kind)
        }

        let rootURL: URL
        switch configuration.kind {
        case .internalSSD:
            rootURL = LocalStorageProvider.defaultLibraryRootURL()
        case .externalSSD, .customFolder:
            rootURL = try Self.resolveBookmarkURL(configuration.bookmarkData)
        case .iCloudDrive, .oneDrive, .bonsaiCloud:
            throw StorageError.providerUnavailable(configuration.kind)
        }

        provider = LocalStorageProvider(rootURL: rootURL, libraryLocation: configuration)
        libraryLocationConfiguration = configuration
        persistLastLibraryBookmark(configuration.bookmarkData)
    }

    /// Points storage at an on-disk library root and stores a security-scoped bookmark.
    func useLibraryRootURL(_ url: URL, kind: LibraryLocationKind = .customFolder) throws {
        guard kind.isPhase1Local else {
            throw StorageError.providerUnavailable(kind)
        }
        let bookmark = try url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        let configuration = LibraryLocationConfiguration(kind: kind, bookmarkData: bookmark)
        provider = LocalStorageProvider(rootURL: url, libraryLocation: configuration)
        libraryLocationConfiguration = configuration
        persistLastLibraryBookmark(bookmark)
    }

    /// Restores the last used library bookmark, if any. Returns `false` when none or stale.
    @discardableResult
    func restoreLastLibraryIfPossible() -> Bool {
        guard let bookmark = UserDefaults.standard.data(forKey: Self.lastLibraryBookmarkKey) else {
            return false
        }
        do {
            let url = try Self.resolveBookmarkURL(bookmark)
            let configuration = LibraryLocationConfiguration(kind: .customFolder, bookmarkData: bookmark)
            provider = LocalStorageProvider(rootURL: url, libraryLocation: configuration)
            libraryLocationConfiguration = configuration
            return true
        } catch {
            return false
        }
    }

    /// Resets to the default Internal SSD library path (does not create folders).
    func useDefaultInternalLibraryLocation() {
        let configuration = LibraryLocationConfiguration.defaultLocal
        provider = LocalStorageProvider.makeDefault()
        libraryLocationConfiguration = configuration
    }

    var selectableLibraryLocationKinds: [LibraryLocationKind] {
        LibraryLocationKind.phase1Selectable
    }

    // MARK: - Library package (routed)

    func libraryPackageExists() -> Bool {
        provider.libraryPackageExists()
    }

    func ensureLibraryFolderStructure() throws {
        try provider.ensureLibraryFolderStructure()
    }

    func missingRequiredFolders() -> [String] {
        provider.missingRequiredFolders()
    }

    func saveLibraryMetadata(_ data: Data) throws {
        try provider.saveLibraryMetadata(data)
    }

    func loadLibraryMetadata() throws -> Data? {
        try provider.loadLibraryMetadata()
    }

    func savePackageFile(relativePath: String, data: Data) throws {
        try provider.savePackageFile(relativePath: relativePath, data: data)
    }

    func loadPackageFile(relativePath: String) throws -> Data? {
        try provider.loadPackageFile(relativePath: relativePath)
    }

    func deletePackageFile(relativePath: String) throws {
        try provider.deletePackageFile(relativePath: relativePath)
    }

    // MARK: - Routed asset operations

    func saveImage(id: StorageAssetID, data: Data, fileExtension: String) async throws {
        try await provider.saveImage(id: id, data: data, fileExtension: fileExtension)
    }

    func loadImage(id: StorageAssetID, fileExtension: String) async throws -> Data {
        let provider = provider
        return try await Task.detached(priority: .userInitiated) {
            try await provider.loadImage(id: id, fileExtension: fileExtension)
        }.value
    }

    func deleteImage(id: StorageAssetID, fileExtension: String) async throws {
        try await provider.deleteImage(id: id, fileExtension: fileExtension)
    }

    func saveDocument(id: StorageAssetID, data: Data) async throws {
        try await provider.saveDocument(id: id, data: data)
    }

    func loadDocument(id: StorageAssetID) async throws -> Data {
        try await provider.loadDocument(id: id)
    }

    func deleteDocument(id: StorageAssetID) async throws {
        try await provider.deleteDocument(id: id)
    }

    // MARK: - Private

    private func persistLastLibraryBookmark(_ bookmark: Data?) {
        if let bookmark {
            UserDefaults.standard.set(bookmark, forKey: Self.lastLibraryBookmarkKey)
        }
    }

    private static func resolveBookmarkURL(_ bookmarkData: Data?) throws -> URL {
        guard let bookmarkData else {
            throw LibraryError.cannotAccessFolder
        }
        var isStale = false
        let url = try URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        )
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
              isDirectory.boolValue
        else {
            throw LibraryError.notADirectory
        }
        return url
    }
}

// MARK: - Launch fallback

struct UnavailableStorageProvider: StorageProvider {
    var libraryLocation: LibraryLocationConfiguration

    func libraryPackageExists() -> Bool { false }

    func ensureLibraryFolderStructure() throws {
        throw StorageError.libraryUnavailable
    }

    func missingRequiredFolders() -> [String] {
        LibraryPackageLayout.requiredRelativeFolders
    }

    func saveLibraryMetadata(_ data: Data) throws {
        throw StorageError.libraryUnavailable
    }

    func loadLibraryMetadata() throws -> Data? {
        throw StorageError.libraryUnavailable
    }

    func savePackageFile(relativePath: String, data: Data) throws {
        throw StorageError.libraryUnavailable
    }

    func loadPackageFile(relativePath: String) throws -> Data? {
        throw StorageError.libraryUnavailable
    }

    func deletePackageFile(relativePath: String) throws {
        throw StorageError.libraryUnavailable
    }

    func saveImage(id: StorageAssetID, data: Data, fileExtension: String) async throws {
        throw StorageError.libraryUnavailable
    }

    func loadImage(id: StorageAssetID, fileExtension: String) async throws -> Data {
        throw StorageError.libraryUnavailable
    }

    func deleteImage(id: StorageAssetID, fileExtension: String) async throws {
        throw StorageError.libraryUnavailable
    }

    func saveDocument(id: StorageAssetID, data: Data) async throws {
        throw StorageError.libraryUnavailable
    }

    func loadDocument(id: StorageAssetID) async throws -> Data {
        throw StorageError.libraryUnavailable
    }

    func deleteDocument(id: StorageAssetID) async throws {
        throw StorageError.libraryUnavailable
    }
}
