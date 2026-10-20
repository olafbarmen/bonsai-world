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
    /// Synchronous CloudDocs XPC — can block for a long time (or forever in the Simulator).
    /// Never call on the main thread on iOS; use `resolveLibraryRootURL(timeout:)` instead.
    public static func libraryRootURL(fileManager: FileManager = .default) -> URL? {
        guard let container = fileManager.url(forUbiquityContainerIdentifier: containerIdentifier) else {
            return nil
        }
        let root = container
            .appendingPathComponent("Documents", isDirectory: true)
            .appendingPathComponent(libraryFolderName, isDirectory: true)
        storeCachedLibraryRootURL(root)
        return root
    }

    // MARK: - Cached / non-blocking lookup

    private static let cachedRootPathKey = "bonsai.iCloudLibrary.cachedRootPath"

    /// Last root returned by the ubiquity lookup, when that folder still exists on disk. No XPC.
    public static func cachedLibraryRootURL(fileManager: FileManager = .default) -> URL? {
        guard let path = UserDefaults.standard.string(forKey: cachedRootPathKey) else { return nil }
        let root = URL(fileURLWithPath: path, isDirectory: true)
        guard libraryPackageExists(at: root, fileManager: fileManager) else { return nil }
        return root
    }

    public static func clearCachedLibraryRootURL() {
        UserDefaults.standard.removeObject(forKey: cachedRootPathKey)
    }

    fileprivate static func storeCachedLibraryRootURL(_ root: URL) {
        UserDefaults.standard.set(root.standardizedFileURL.path, forKey: cachedRootPathKey)
    }

    /// Folder name CloudDocs uses under Mobile Documents (`iCloud.a.b` → `iCloud~a~b`).
    private static var mobileDocumentsContainerName: String {
        containerIdentifier.replacingOccurrences(of: ".", with: "~")
    }

    private static func libraryPackageExists(at root: URL, fileManager: FileManager) -> Bool {
        let container = root.deletingLastPathComponent().deletingLastPathComponent()
        return fileManager.fileExists(atPath: container.path)
    }

    /// Finds an already-materialized library root without calling CloudDocs.
    /// Used when the Simulator's ubiquity XPC never answers, and as a cache seed on device.
    public static func discoveredLibraryRootURL(fileManager: FileManager = .default) -> URL? {
        for root in discoveryCandidates() {
            if libraryPackageExists(at: root, fileManager: fileManager) {
                storeCachedLibraryRootURL(root)
                return root
            }
        }
        return nil
    }

    private static func discoveryCandidates() -> [URL] {
        var candidates: [URL] = []
        let env = ProcessInfo.processInfo.environment
        let folder = libraryFolderName
        let containerName = mobileDocumentsContainerName

        if let udid = env["SIMULATOR_UDID"], !udid.isEmpty {
            let hostHome = env["SIMULATOR_HOST_HOME"].flatMap { $0.isEmpty ? nil : $0 }
                ?? NSHomeDirectory()
            candidates.append(
                URL(fileURLWithPath: hostHome, isDirectory: true)
                    .appendingPathComponent("Library/Developer/CoreSimulator/Devices/\(udid)/data/Library/Mobile Documents/\(containerName)/Documents/\(folder)", isDirectory: true)
            )
        }

        // Device (and some Simulator layouts): ubiquity root under the app home's Mobile Documents.
        candidates.append(
            URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
                .appendingPathComponent("Library/Mobile Documents/\(containerName)/Documents/\(folder)", isDirectory: true)
        )

        // Walk up from the sandboxed home toward the device data root (Simulator).
        var probe = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        for _ in 0..<8 {
            probe = probe.deletingLastPathComponent()
            candidates.append(
                probe.appendingPathComponent("Library/Mobile Documents/\(containerName)/Documents/\(folder)", isDirectory: true)
            )
        }

        return candidates.map { $0.standardizedFileURL }
    }

    public enum LookupResult: Sendable, Equatable {
        case available(URL)
        /// The system answered: no container (signed out / iCloud Drive off).
        case unavailable
        /// The system did not answer in time. The lookup keeps running in the background.
        case timedOut
    }

    /// Default wait for CloudDocs. Shorter in the Simulator, where the XPC often never returns.
    public static var defaultLookupTimeout: TimeInterval {
        #if targetEnvironment(simulator)
        2
        #else
        8
        #endif
    }

    /// Runs the ubiquity lookup on a background thread and gives up waiting after `timeout`.
    /// Safe to await from the main actor. Caches a successful root; clears the cache on `.unavailable`.
    public static func resolveLibraryRootURL(timeout: TimeInterval = defaultLookupTimeout) async -> LookupResult {
        let gate = LookupGate()
        return await withCheckedContinuation { continuation in
            gate.install(continuation)
            LookupCoordinator.shared.enqueue(gate)
            DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + timeout) {
                gate.finish(.timedOut)
            }
        }
    }

    /// Cached or discovered root when present on disk, otherwise `resolveLibraryRootURL(timeout:)`.
    /// A cache hit still refreshes the lookup in the background (registers the container with CloudDocs).
    public static func preferredLibraryRootURL(timeout: TimeInterval = defaultLookupTimeout) async -> URL? {
        if let ready = cachedLibraryRootURL() ?? discoveredLibraryRootURL() {
            Task.detached(priority: .utility) { _ = await resolveLibraryRootURL(timeout: 60) }
            return ready
        }
        if case .available(let root) = await resolveLibraryRootURL(timeout: timeout) {
            return root
        }
        // Timed out / failed, but the package may already exist on disk (common in Simulator).
        return discoveredLibraryRootURL()
    }
}

/// Resumes a lookup continuation exactly once (result or timeout, whichever comes first).
private final class LookupGate: @unchecked Sendable {
    private let lock = NSLock()
    private var continuation: CheckedContinuation<BonsaiWorldICloudLibrary.LookupResult, Never>?

    func install(_ continuation: CheckedContinuation<BonsaiWorldICloudLibrary.LookupResult, Never>) {
        lock.lock()
        self.continuation = continuation
        lock.unlock()
    }

    func finish(_ result: BonsaiWorldICloudLibrary.LookupResult) {
        lock.lock()
        let pending = continuation
        continuation = nil
        lock.unlock()
        pending?.resume(returning: result)
    }
}

/// At most one ubiquity lookup thread at a time; a lookup that never returns does not pile up threads.
private final class LookupCoordinator: @unchecked Sendable {
    static let shared = LookupCoordinator()

    private let lock = NSLock()
    private var waiting: [LookupGate] = []
    private var isRunning = false

    func enqueue(_ gate: LookupGate) {
        lock.lock()
        waiting.append(gate)
        let shouldStart = !isRunning
        isRunning = true
        lock.unlock()
        guard shouldStart else { return }
        Thread.detachNewThread { [self] in
            let root = BonsaiWorldICloudLibrary.libraryRootURL(fileManager: FileManager())
            // Only clear when CloudDocs explicitly answers nil — not when a discovered
            // Simulator path already seeded the cache and this call never completes usefully.
            if root == nil, BonsaiWorldICloudLibrary.discoveredLibraryRootURL() == nil {
                BonsaiWorldICloudLibrary.clearCachedLibraryRootURL()
            }
            lock.lock()
            let gates = waiting
            waiting = []
            isRunning = false
            lock.unlock()
            let result: BonsaiWorldICloudLibrary.LookupResult = root.map { .available($0) } ?? .unavailable
            gates.forEach { $0.finish(result) }
        }
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
