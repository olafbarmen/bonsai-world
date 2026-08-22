//
//  LibraryService.swift
//  Bonsai World
//
//  Manages the single Bonsai World Library package.
//  All disk work goes through StorageService → StorageProvider.
//

import AppKit
import Foundation
import Observation

/// Creates, opens, and verifies the Bonsai World Library.
@Observable
@MainActor
final class LibraryService {
    private let storage: StorageService

    /// The open library for this session, if one is ready.
    private(set) var currentLibrary: Library?

    /// When `false`, the First Launch Wizard should be shown.
    private(set) var isLibraryReady = false

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Startup

    /// Resolves an existing valid library (last bookmark or default). Does **not** create one.
    func resolveLaunchLibrary() {
        if storage.restoreLastLibraryIfPossible() {
            if (try? activateOpenedLibrary()) != nil {
                return
            }
        }

        storage.useDefaultInternalLibraryLocation()
        if storage.libraryPackageExists() {
            if (try? activateOpenedLibrary()) != nil {
                return
            }
        }

        currentLibrary = nil
        isLibraryReady = false
    }

    // MARK: - Create

    /// Presents a folder picker, then creates `Bonsai World Library` inside the chosen parent.
    @discardableResult
    func createNewLibraryUsingFolderPicker() async throws -> Library {
        let parentURL = try await pickDirectory(
            title: "Choose a Location for Your Library",
            message: "Bonsai World will create a “\(Library.defaultName)” folder here.",
            prompt: "Choose"
        )
        return try createNewLibrary(inParentDirectory: parentURL)
    }

    /// Creates a new library package inside `parentDirectory`.
    @discardableResult
    func createNewLibrary(inParentDirectory parentDirectory: URL) throws -> Library {
        let didAccess = parentDirectory.startAccessingSecurityScopedResource()
        defer {
            if didAccess { parentDirectory.stopAccessingSecurityScopedResource() }
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: parentDirectory.path, isDirectory: &isDirectory),
              isDirectory.boolValue
        else {
            throw LibraryError.notADirectory
        }

        let libraryRoot = parentDirectory.appendingPathComponent(Library.defaultName, isDirectory: true)
        do {
            try storage.useLibraryRootURL(libraryRoot, kind: .customFolder)
            try storage.ensureLibraryFolderStructure()
        } catch let error as LibraryError {
            throw error
        } catch {
            throw LibraryError.createFailed(error.localizedDescription)
        }

        let library = Library(
            libraryName: Library.defaultName,
            libraryLocation: storage.libraryLocationConfiguration,
            createdDate: .now,
            version: Library.currentVersion
        )
        try saveManifest(library)
        currentLibrary = library
        isLibraryReady = true
        return library
    }

    /// Creates a library at the default Internal SSD location (no picker).
    @discardableResult
    func createNewLibrary(
        name: String = Library.defaultName,
        location: LibraryLocationConfiguration = .defaultLocal
    ) throws -> Library {
        try storage.applyLibraryLocation(location)
        try storage.ensureLibraryFolderStructure()

        let library = Library(
            libraryName: name,
            libraryLocation: location,
            createdDate: .now,
            version: Library.currentVersion
        )
        try saveManifest(library)
        currentLibrary = library
        isLibraryReady = true
        return library
    }

    // MARK: - Open

    /// Presents a folder picker and opens a valid Bonsai World Library.
    @discardableResult
    func openExistingLibraryUsingFolderPicker() async throws -> Library {
        let url = try await pickDirectory(
            title: "Open Bonsai World Library",
            message: "Select an existing Bonsai World Library folder.",
            prompt: "Open"
        )
        return try openExistingLibrary(at: url)
    }

    /// Opens and validates a library at `url`. Does not create missing folders.
    @discardableResult
    func openExistingLibrary(at url: URL) throws -> Library {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
              isDirectory.boolValue
        else {
            throw LibraryError.notADirectory
        }

        try storage.useLibraryRootURL(url, kind: .customFolder)
        try validateLibraryStructure()
        return try activateOpenedLibrary()
    }

    /// Opens the library at the current storage location after validation.
    @discardableResult
    func openExistingLibrary() throws -> Library {
        guard storage.libraryPackageExists() else {
            throw StorageError.libraryUnavailable
        }
        try validateLibraryStructure()
        return try activateOpenedLibrary()
    }

    /// Verifies required folders exist. Throws `LibraryError.invalidStructure` when incomplete.
    func validateLibraryStructure() throws {
        guard storage.libraryPackageExists() else {
            throw LibraryError.invalidStructure(missingFolders: LibraryPackageLayout.requiredRelativeFolders)
        }
        let missing = storage.missingRequiredFolders()
        if !missing.isEmpty {
            throw LibraryError.invalidStructure(missingFolders: missing)
        }
    }

    /// Creates any missing folders on an already-selected library (repair).
    func verifyLibraryStructure() throws {
        try storage.ensureLibraryFolderStructure()
    }

    // MARK: - Private

    private func activateOpenedLibrary() throws -> Library {
        try validateLibraryStructure()

        if let library = try loadManifest() {
            currentLibrary = library
            isLibraryReady = true
            return library
        }

        let library = Library(
            libraryName: Library.defaultName,
            libraryLocation: storage.libraryLocationConfiguration,
            createdDate: .now,
            version: Library.currentVersion
        )
        try saveManifest(library)
        currentLibrary = library
        isLibraryReady = true
        return library
    }

    private func saveManifest(_ library: Library) throws {
        let data = try JSONEncoder().encode(library)
        try storage.saveLibraryMetadata(data)
    }

    private func loadManifest() throws -> Library? {
        guard let data = try storage.loadLibraryMetadata() else { return nil }
        return try JSONDecoder().decode(Library.self, from: data)
    }

    private func pickDirectory(title: String, message: String, prompt: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let panel = NSOpenPanel()
            panel.title = title
            panel.message = message
            panel.prompt = prompt
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.canCreateDirectories = true

            panel.begin { response in
                if response == .OK, let url = panel.url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: LibraryError.folderPickerCancelled)
                }
            }
        }
    }
}
