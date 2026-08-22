//
//  StorageError.swift
//  Bonsai World
//
//  Errors from StorageProvider / StorageService.
//

import Foundation

enum StorageError: Error, Sendable, LocalizedError {
    case notImplemented
    case assetNotFound(StorageAssetID)
    case libraryUnavailable
    /// Requested location requires a provider that is not yet available.
    case providerUnavailable(LibraryLocationKind)

    var errorDescription: String? {
        switch self {
        case .notImplemented:
            "This storage operation is not implemented yet."
        case .assetNotFound(let id):
            "Storage asset not found (\(id.id.uuidString))."
        case .libraryUnavailable:
            "The Bonsai World Library is unavailable."
        case .providerUnavailable(let kind):
            "Storage provider for \(kind.displayName) is not available yet."
        }
    }
}
