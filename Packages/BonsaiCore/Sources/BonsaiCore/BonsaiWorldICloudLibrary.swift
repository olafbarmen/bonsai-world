//
//  BonsaiWorldICloudLibrary.swift
//  BonsaiCore
//
//  Shared iCloud Documents library root for Mac + iPhone (Storage Phase 2).
//  Same package shape as local; one ubiquity container identifier on both targets.
//

import Foundation

/// iCloud Drive package location shared by Bonsai Hub (Mac) and Bonsai World (iOS).
public enum BonsaiWorldICloudLibrary: Sendable {
    /// Must match entitlements on both app targets.
    public static let containerIdentifier = "iCloud.no.olafbarmen.BonsaiWorld"

    /// Folder name inside the container’s Documents directory (same as Mac `Library.defaultName`).
    public static let libraryFolderName = "Bonsai World Library"

    /// Relative path for the single-writer lease (A1).
    public static let writerLeaseRelativePath = "Database/WriterLease.json"

    /// `true` when the ubiquity container is available (signed into iCloud).
    public static var isAvailable: Bool {
        libraryRootURL() != nil
    }

    /// Package root: `<UbiquityContainer>/Documents/Bonsai World Library`.
    public static func libraryRootURL(fileManager: FileManager = .default) -> URL? {
        guard let container = fileManager.url(forUbiquityContainerIdentifier: containerIdentifier) else {
            return nil
        }
        return container
            .appendingPathComponent("Documents", isDirectory: true)
            .appendingPathComponent(libraryFolderName, isDirectory: true)
    }
}

/// Lease file for single-writer guidance (Mac ↔ iPhone).
public struct LibraryWriterLease: Codable, Hashable, Sendable {
    public var deviceName: String
    public var updatedAt: Date

    public init(deviceName: String, updatedAt: Date = .now) {
        self.deviceName = deviceName
        self.updatedAt = updatedAt
    }

    /// Another device wrote within this window → show the single-writer warning.
    public static let staleAfter: TimeInterval = 5 * 60

    public func isForeignActive(comparedTo localDeviceName: String, now: Date = .now) -> Bool {
        guard deviceName != localDeviceName else { return false }
        return now.timeIntervalSince(updatedAt) < Self.staleAfter
    }
}
