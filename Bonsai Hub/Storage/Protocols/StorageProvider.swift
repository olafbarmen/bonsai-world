//
//  StorageProvider.swift
//  Bonsai World
//
//  Technology-agnostic storage surface for the Bonsai World Library.
//  Implementations: LocalStorageProvider (Phase 1); future iCloud / OneDrive / Bonsai Cloud.
//  Features must depend only on this protocol (via StorageService) — never on a concrete provider.
//

import Foundation

/// Abstracts all library file operations. No iCloud, OneDrive, or path APIs here.
protocol StorageProvider: Sendable {
    /// Current library location configuration (kind + opaque bookmark). Not an absolute path.
    var libraryLocation: LibraryLocationConfiguration { get }

    // MARK: Library package

    /// Whether a library package is already present at the configured location.
    func libraryPackageExists() -> Bool

    /// Creates the library root (if needed) and ensures the default folder structure.
    func ensureLibraryFolderStructure() throws

    /// Relative folder paths that are required but currently missing (empty when valid).
    func missingRequiredFolders() -> [String]

    /// Writes library metadata (`Library.json`) inside the package.
    func saveLibraryMetadata(_ data: Data) throws

    /// Loads library metadata, or `nil` if the manifest is missing.
    func loadLibraryMetadata() throws -> Data?

    /// Writes an arbitrary relative file inside the library package (e.g. `Images/Catalog.json`).
    func savePackageFile(relativePath: String, data: Data) throws

    /// Loads a relative package file, or `nil` if missing.
    func loadPackageFile(relativePath: String) throws -> Data?

    /// Removes a relative package file when present.
    func deletePackageFile(relativePath: String) throws

    // MARK: Images

    /// Stores original image bytes under `Images/Originals/` using `fileExtension` (e.g. `jpg`, `heic`).
    func saveImage(id: StorageAssetID, data: Data, fileExtension: String) async throws
    func loadImage(id: StorageAssetID, fileExtension: String) async throws -> Data
    func deleteImage(id: StorageAssetID, fileExtension: String) async throws

    // MARK: Documents

    func saveDocument(id: StorageAssetID, data: Data) async throws
    func loadDocument(id: StorageAssetID) async throws -> Data
    func deleteDocument(id: StorageAssetID) async throws
}
