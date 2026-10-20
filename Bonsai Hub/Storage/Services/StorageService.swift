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
    private static let lastLibraryKindKey = "bonsai.world.lastLibraryKind"
    private static let recentLibrariesKey = "bonsai.world.recentLibraries"
    private static let maxRecentLibraries = 8

    /// Active provider. Always a `StorageProvider` existential — never expose concrete types to Features.
    private(set) var provider: any StorageProvider

    /// Current library location (for Settings). Changing this rebuilds the local provider in Phase 1.
    private(set) var libraryLocationConfiguration: LibraryLocationConfiguration

    /// Recently opened libraries (newest first), for Switch Library.
    private(set) var recentLibraries: [RecentLibraryEntry] = []

    /// Single-writer warning when another device updated the iCloud lease recently (A1).
    private(set) var foreignWriterWarning: String?

    /// When this Mac last wrote the shared image catalog or an original file.
    private(set) var lastImageWriteAt: Date?

    private init() {
        let configuration = LibraryLocationConfiguration.defaultLocal
        self.libraryLocationConfiguration = configuration
        self.provider = LocalStorageProvider.makeDefault()
        self.recentLibraries = Self.loadRecentLibraries()
    }

    /// Testing / explicit bootstrap. Prefer `shared` in production.
    init(provider: any StorageProvider) {
        self.provider = provider
        self.libraryLocationConfiguration = provider.libraryLocation
        self.recentLibraries = Self.loadRecentLibraries()
    }

    // MARK: - Library location

    /// Default Internal SSD path display (First Launch proposal).
    static var defaultLibraryPathDisplay: String {
        (LocalStorageProvider.defaultLibraryRootURL().path as NSString).abbreviatingWithTildeInPath
    }

    /// Current open library path for Settings guidance.
    var libraryPackagePathDisplay: String {
        guard let root = libraryPackageRootURL else {
            return "No library path available"
        }
        return (root.path as NSString).abbreviatingWithTildeInPath
    }

    /// Applies a library location. Phase 1 local kinds + Phase 2 iCloud Drive.
    func applyLibraryLocation(_ configuration: LibraryLocationConfiguration) throws {
        switch configuration.kind {
        case .internalSSD:
            let rootURL = LocalStorageProvider.defaultLibraryRootURL()
            try activateLocalProvider(rootURL: rootURL, kind: .internalSSD, bookmarkData: configuration.bookmarkData)
        case .externalSSD, .customFolder:
            let rootURL = try Self.resolveBookmarkURL(configuration.bookmarkData)
            try activateLocalProvider(rootURL: rootURL, kind: configuration.kind, bookmarkData: configuration.bookmarkData)
        case .iCloudDrive:
            try useICloudDriveLibrary()
        case .oneDrive, .bonsaiCloud:
            throw StorageError.providerUnavailable(configuration.kind)
        }
    }

    /// Points storage at the shared iCloud Documents library package (Mac ↔ iPhone).
    func useICloudDriveLibrary() throws {
        guard let rootURL = BonsaiWorldICloudLibrary.libraryRootURL() else {
            throw StorageError.iCloudUnavailable
        }
        let documents = rootURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)
        let configuration = LibraryLocationConfiguration(kind: .iCloudDrive, bookmarkData: nil)
        provider = LocalStorageProvider(rootURL: rootURL, libraryLocation: configuration)
        libraryLocationConfiguration = configuration
        UserDefaults.standard.set(LibraryLocationKind.iCloudDrive.rawValue, forKey: Self.lastLibraryKindKey)
        UserDefaults.standard.removeObject(forKey: Self.lastLibraryBookmarkKey)
        refreshForeignWriterWarning()
        touchWriterLease()
    }

    /// Points storage at an on-disk library root and stores a security-scoped bookmark.
    func useLibraryRootURL(_ url: URL, kind: LibraryLocationKind = .customFolder) throws {
        guard kind.isPhase1Local else {
            if kind == .iCloudDrive {
                try useICloudDriveLibrary()
                return
            }
            throw StorageError.providerUnavailable(kind)
        }
        try activateLocalProvider(rootURL: url, kind: kind, bookmarkData: nil)
    }

    /// Restores the last used library bookmark or iCloud location, if any.
    @discardableResult
    func restoreLastLibraryIfPossible() -> Bool {
        if UserDefaults.standard.string(forKey: Self.lastLibraryKindKey) == LibraryLocationKind.iCloudDrive.rawValue {
            do {
                try useICloudDriveLibrary()
                return true
            } catch {
                return false
            }
        }
        guard let bookmark = UserDefaults.standard.data(forKey: Self.lastLibraryBookmarkKey) else {
            return false
        }
        do {
            let url = try Self.resolveBookmarkURL(bookmark)
            try activateLocalProvider(rootURL: url, kind: .customFolder, bookmarkData: bookmark)
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
        UserDefaults.standard.set(LibraryLocationKind.internalSSD.rawValue, forKey: Self.lastLibraryKindKey)
        foreignWriterWarning = nil
    }

    /// Recent libraries excluding the currently open package (for Switch Library).
    var recentLibrariesForSwitch: [RecentLibraryEntry] {
        let currentPath = libraryPackageRootURL?.path
        return recentLibraries.filter { entry in
            guard let currentPath else { return true }
            return entry.id != currentPath
        }
    }

    /// Resolves a recent entry to a usable folder URL.
    func resolveRecentLibraryURL(_ entry: RecentLibraryEntry) throws -> URL {
        try Self.resolveBookmarkURL(entry.bookmarkData)
    }

    /// Package root on disk — Phase 1 local or Phase 2 iCloud-rooted provider.
    var libraryPackageRootURL: URL? {
        (provider as? LocalStorageProvider)?.packageRootURL
    }

    var selectableLibraryLocationKinds: [LibraryLocationKind] {
        LibraryLocationKind.selectable
    }

    /// Updates the single-writer lease after a successful library write path (iCloud).
    func touchWriterLease() {
        guard libraryLocationConfiguration.kind == .iCloudDrive else { return }
        let lease = LibraryWriterLease(deviceName: Self.localDeviceName)
        guard let data = try? JSONEncoder().encode(lease) else { return }
        try? provider.savePackageFile(
            relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath,
            data: data
        )
        foreignWriterWarning = nil
    }

    /// Reads the lease and sets `foreignWriterWarning` when another device is active.
    func refreshForeignWriterWarning() {
        foreignWriterWarning = nil
        guard libraryLocationConfiguration.kind == .iCloudDrive else { return }
        guard let data = try? provider.loadPackageFile(
            relativePath: BonsaiWorldICloudLibrary.writerLeaseRelativePath
        ),
              let lease = try? JSONDecoder().decode(LibraryWriterLease.self, from: data)
        else {
            return
        }
        if lease.isForeignActive(comparedTo: Self.localDeviceName) {
            foreignWriterWarning =
                "“\(lease.deviceName)” used this library recently. Avoid editing on Mac and iPhone at the same time."
        }
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
        if relativePath == LibraryPackageLayout.imagesCatalogFileName {
            lastImageWriteAt = Date()
        }
        touchWriterLease()
    }

    func loadPackageFile(relativePath: String) throws -> Data? {
        try provider.loadPackageFile(relativePath: relativePath)
    }

    func deletePackageFile(relativePath: String) throws {
        try provider.deletePackageFile(relativePath: relativePath)
        touchWriterLease()
    }

    // MARK: - Routed asset operations

    func saveImage(id: StorageAssetID, data: Data, fileExtension: String) async throws {
        try await provider.saveImage(id: id, data: data, fileExtension: fileExtension)
        lastImageWriteAt = Date()
        touchWriterLease()
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

    private func activateLocalProvider(rootURL: URL, kind: LibraryLocationKind, bookmarkData: Data?) throws {
        let bookmark: Data
        if let existing = bookmarkData {
            bookmark = existing
        } else {
            bookmark = try Self.makeBookmark(for: rootURL)
        }
        let resolved = LibraryLocationConfiguration(kind: kind, bookmarkData: bookmark)
        provider = LocalStorageProvider(rootURL: rootURL, libraryLocation: resolved)
        libraryLocationConfiguration = resolved
        UserDefaults.standard.set(kind.rawValue, forKey: Self.lastLibraryKindKey)
        rememberOpenedLibrary(url: rootURL, bookmarkData: bookmark)
        foreignWriterWarning = nil
    }

    private static var localDeviceName: String {
        Host.current().localizedName ?? "Mac"
    }

    private func rememberOpenedLibrary(url: URL, bookmarkData: Data) {
        UserDefaults.standard.set(bookmarkData, forKey: Self.lastLibraryBookmarkKey)

        var next = recentLibraries.filter { $0.id != url.path }
        next.insert(RecentLibraryEntry.make(url: url, bookmarkData: bookmarkData), at: 0)
        if next.count > Self.maxRecentLibraries {
            next = Array(next.prefix(Self.maxRecentLibraries))
        }
        recentLibraries = next
        Self.saveRecentLibraries(next)
    }

    private static func makeBookmark(for url: URL) throws -> Data {
        try url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
    }

    private static func loadRecentLibraries() -> [RecentLibraryEntry] {
        guard let data = UserDefaults.standard.data(forKey: recentLibrariesKey),
              let decoded = try? JSONDecoder().decode([RecentLibraryEntry].self, from: data)
        else {
            return []
        }
        return decoded
    }

    private static func saveRecentLibraries(_ entries: [RecentLibraryEntry]) {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: recentLibrariesKey)
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
