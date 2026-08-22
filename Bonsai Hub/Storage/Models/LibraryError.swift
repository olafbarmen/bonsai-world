//
//  LibraryError.swift
//  Bonsai World
//
//  User-facing errors for library create / open / validation.
//

import Foundation

enum LibraryError: Error, LocalizedError, Sendable {
    case folderPickerCancelled
    case notADirectory
    case invalidStructure(missingFolders: [String])
    case cannotAccessFolder
    case createFailed(String)

    var errorDescription: String? {
        switch self {
        case .folderPickerCancelled:
            return "No folder was selected."
        case .notADirectory:
            return "The selection is not a folder."
        case .invalidStructure(let missing):
            let list = missing.joined(separator: ", ")
            return "This folder is not a valid Bonsai World Library. Missing: \(list)."
        case .cannotAccessFolder:
            return "Bonsai World could not access that folder."
        case .createFailed(let detail):
            return "Could not create the library. \(detail)"
        }
    }
}
