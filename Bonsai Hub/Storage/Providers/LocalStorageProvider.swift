//
//  LocalStorageProvider.swift
//  Bonsai World
//
//  Phase 1 StorageProvider — local Bonsai World Library on disk.
//  Features must never reference this type; use StorageService instead.
//

import Foundation

/// Local filesystem implementation of `StorageProvider`.
final class LocalStorageProvider: StorageProvider, @unchecked Sendable {
    private let rootURL: URL
    private let fileManager: FileManager
    private(set) var libraryLocation: LibraryLocationConfiguration
    private var isAccessingSecurityScope = false

    /// Creates a provider rooted at `rootURL`. Does not create folders until
    /// `ensureLibraryFolderStructure()` — LibraryService owns create/open.
    init(
        rootURL: URL,
        libraryLocation: LibraryLocationConfiguration = .defaultLocal,
        fileManager: FileManager = .default
    ) {
        self.rootURL = rootURL
        self.libraryLocation = libraryLocation
        self.fileManager = fileManager
        if libraryLocation.bookmarkData != nil {
            isAccessingSecurityScope = rootURL.startAccessingSecurityScopedResource()
        }
    }

    deinit {
        if isAccessingSecurityScope {
            rootURL.stopAccessingSecurityScopedResource()
        }
    }

    /// Default Internal SSD library under Application Support.
    static func makeDefault(fileManager: FileManager = .default) -> LocalStorageProvider {
        LocalStorageProvider(
            rootURL: defaultLibraryRootURL(fileManager: fileManager),
            libraryLocation: .defaultLocal,
            fileManager: fileManager
        )
    }

    /// Default library package path (Internal SSD). Not for Feature use.
    static func defaultLibraryRootURL(fileManager: FileManager = .default) -> URL {
        let support = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        return support.appendingPathComponent(Library.defaultName, isDirectory: true)
    }

    // MARK: - Library package

    func libraryPackageExists() -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: rootURL.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    func ensureLibraryFolderStructure() throws {
        if !libraryPackageExists() {
            try fileManager.createDirectory(at: rootURL, withIntermediateDirectories: true)
        }
        for relative in LibraryPackageLayout.requiredRelativeFolders {
            let url = rootURL.appendingPathComponent(relative, isDirectory: true)
            if !fileManager.fileExists(atPath: url.path) {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            }
        }
    }

    func missingRequiredFolders() -> [String] {
        guard libraryPackageExists() else {
            return LibraryPackageLayout.requiredRelativeFolders
        }
        return LibraryPackageLayout.requiredRelativeFolders.filter { relative in
            let url = rootURL.appendingPathComponent(relative, isDirectory: true)
            var isDirectory: ObjCBool = false
            let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
            return !(exists && isDirectory.boolValue)
        }
    }

    func saveLibraryMetadata(_ data: Data) throws {
        try ensureLibraryFolderStructure()
        let url = rootURL.appendingPathComponent(LibraryPackageLayout.metadataFileName, isDirectory: false)
        try data.write(to: url, options: .atomic)
    }

    func loadLibraryMetadata() throws -> Data? {
        let url = rootURL.appendingPathComponent(LibraryPackageLayout.metadataFileName, isDirectory: false)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    func savePackageFile(relativePath: String, data: Data) throws {
        try ensureLibraryFolderStructure()
        let url = rootURL.appendingPathComponent(relativePath, isDirectory: false)
        try fileManager.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: url, options: .atomic)
    }

    func loadPackageFile(relativePath: String) throws -> Data? {
        let url = rootURL.appendingPathComponent(relativePath, isDirectory: false)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    func deletePackageFile(relativePath: String) throws {
        try removeIfExists(rootURL.appendingPathComponent(relativePath, isDirectory: false))
    }

    // MARK: - StorageProvider — Images

    func saveImage(id: StorageAssetID, data: Data, fileExtension: String) async throws {
        try ensureLibraryFolderStructure()
        try write(data, to: imageURL(for: id, fileExtension: fileExtension))
    }

    func loadImage(id: StorageAssetID, fileExtension: String) async throws -> Data {
        try read(from: imageURL(for: id, fileExtension: fileExtension), id: id)
    }

    func deleteImage(id: StorageAssetID, fileExtension: String) async throws {
        try removeIfExists(imageURL(for: id, fileExtension: fileExtension))
    }

    // MARK: - StorageProvider — Documents

    func saveDocument(id: StorageAssetID, data: Data) async throws {
        try ensureLibraryFolderStructure()
        try write(data, to: documentURL(for: id))
    }

    func loadDocument(id: StorageAssetID) async throws -> Data {
        try read(from: documentURL(for: id), id: id)
    }

    func deleteDocument(id: StorageAssetID) async throws {
        try removeIfExists(documentURL(for: id))
    }

    // MARK: - Paths

    private func imageURL(for id: StorageAssetID, fileExtension: String) -> URL {
        let ext = fileExtension.trimmingCharacters(in: CharacterSet(charactersIn: ".")).lowercased()
        let safeExtension = ext.isEmpty ? "bin" : ext
        return rootURL
            .appendingPathComponent(LibraryPackageLayout.imagesOriginals, isDirectory: true)
            .appendingPathComponent(id.id.uuidString)
            .appendingPathExtension(safeExtension)
    }

    private func documentURL(for id: StorageAssetID) -> URL {
        rootURL
            .appendingPathComponent(LibraryPackageLayout.documents, isDirectory: true)
            .appendingPathComponent(id.id.uuidString)
            .appendingPathExtension("bin")
    }

    private func write(_ data: Data, to url: URL) throws {
        try fileManager.createDirectory(
            at: url.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: url, options: .atomic)
    }

    private func read(from url: URL, id: StorageAssetID) throws -> Data {
        guard fileManager.fileExists(atPath: url.path) else {
            throw StorageError.assetNotFound(id)
        }
        return try Data(contentsOf: url)
    }

    private func removeIfExists(_ url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }
}
