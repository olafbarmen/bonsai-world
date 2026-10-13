//
//  LibraryICloudSeedService.swift
//  Bonsai World
//
//  When switching a Mac library to the shared iCloud package, copy personal
//  content so iPhone sees the same trees and photos (Phase 2).
//

import Foundation

enum LibraryICloudSeedService {
    struct Report: Sendable {
        var copiedImageFiles: Int
        var mergedTreePhotoLinks: Int
        var didFullPackageCopy: Bool
    }

    /// Seeds the iCloud package from a previous on-disk library when needed.
    /// - Full copy when the iCloud package has no trees yet.
    /// - Photo + membership merge when trees already exist but Images are missing.
    @discardableResult
    static func seedIfNeeded(from sourceRoot: URL, to destinationRoot: URL) throws -> Report {
        let fm = FileManager.default
        let source = sourceRoot.standardizedFileURL
        let destination = destinationRoot.standardizedFileURL
        guard source.path != destination.path else {
            return Report(copiedImageFiles: 0, mergedTreePhotoLinks: 0, didFullPackageCopy: false)
        }
        guard fm.fileExists(atPath: source.path) else {
            return Report(copiedImageFiles: 0, mergedTreePhotoLinks: 0, didFullPackageCopy: false)
        }

        try fm.createDirectory(at: destination, withIntermediateDirectories: true)

        if isPackageMissingTrees(at: destination), packageHasTrees(at: source) {
            let images = try copyPackagePayload(from: source, to: destination)
            return Report(copiedImageFiles: images, mergedTreePhotoLinks: 0, didFullPackageCopy: true)
        }

        let copiedImages = try copyMissingImageFiles(from: source, to: destination)
        let mergedLinks = try mergeTreePhotoMembership(from: source, to: destination)
        if mergedLinks > 0 {
            try rebuildPhotoIndex(at: destination)
        }
        return Report(
            copiedImageFiles: copiedImages,
            mergedTreePhotoLinks: mergedLinks,
            didFullPackageCopy: false
        )
    }

    // MARK: - Full package

    /// Copies Database + Images (+ optional Documents). Removes WriterLease so StorageService can rewrite it.
    private static func copyPackagePayload(from source: URL, to destination: URL) throws -> Int {
        let fm = FileManager.default
        var imageCount = 0
        for folder in [LibraryPackageLayout.database, LibraryPackageLayout.images, "Documents"] {
            let from = source.appendingPathComponent(folder, isDirectory: true)
            let to = destination.appendingPathComponent(folder, isDirectory: true)
            guard fm.fileExists(atPath: from.path) else { continue }
            if fm.fileExists(atPath: to.path) {
                try fm.removeItem(at: to)
            }
            try fm.copyItem(at: from, to: to)
            if folder == LibraryPackageLayout.images {
                imageCount = countFiles(under: to)
            }
        }
        let lease = destination
            .appendingPathComponent(BonsaiWorldICloudLibrary.writerLeaseRelativePath, isDirectory: false)
        if fm.fileExists(atPath: lease.path) {
            try? fm.removeItem(at: lease)
        }
        return imageCount
    }

    // MARK: - Photos only

    private static func copyMissingImageFiles(from source: URL, to destination: URL) throws -> Int {
        let fm = FileManager.default
        var copied = 0
        let relativeFolders = [
            LibraryPackageLayout.imagesOriginals,
            LibraryPackageLayout.imagesHero,
            LibraryPackageLayout.imagesThumbnails
        ]
        for relative in relativeFolders {
            let fromDir = source.appendingPathComponent(relative, isDirectory: true)
            let toDir = destination.appendingPathComponent(relative, isDirectory: true)
            guard fm.fileExists(atPath: fromDir.path) else { continue }
            try fm.createDirectory(at: toDir, withIntermediateDirectories: true)
            for file in try fm.contentsOfDirectory(at: fromDir, includingPropertiesForKeys: nil) {
                let destFile = toDir.appendingPathComponent(file.lastPathComponent)
                if fm.fileExists(atPath: destFile.path) { continue }
                try fm.copyItem(at: file, to: destFile)
                copied += 1
            }
        }

        for relative in [
            LibraryPackageLayout.imagesCatalogFileName,
            LibraryPackageLayout.imagesPresentationsFileName
        ] {
            let fromFile = source.appendingPathComponent(relative, isDirectory: false)
            let toFile = destination.appendingPathComponent(relative, isDirectory: false)
            guard fm.fileExists(atPath: fromFile.path) else { continue }
            try fm.createDirectory(
                at: toFile.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            if relative == LibraryPackageLayout.imagesCatalogFileName,
               fm.fileExists(atPath: toFile.path),
               let destData = try? Data(contentsOf: toFile),
               !destData.isEmpty,
               destData != Data("[]".utf8) {
                try mergeCatalogAssets(from: fromFile, into: toFile)
                continue
            }
            if fm.fileExists(atPath: toFile.path) {
                try fm.removeItem(at: toFile)
            }
            try fm.copyItem(at: fromFile, to: toFile)
        }
        return copied
    }

    private static func mergeCatalogAssets(from sourceFile: URL, into destinationFile: URL) throws {
        let sourceData = try Data(contentsOf: sourceFile)
        let destData = try Data(contentsOf: destinationFile)
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let sourceAssets = try decodeAssetList(sourceData, decoder: decoder)
        var destAssets = try decodeAssetList(destData, decoder: decoder)
        let existing = Set(destAssets.map(\.id))
        let missing = sourceAssets.filter { !existing.contains($0.id) }
        guard !missing.isEmpty else { return }
        destAssets.append(contentsOf: missing)
        try encoder.encode(destAssets).write(to: destinationFile, options: .atomic)
    }

    private static func decodeAssetList(_ data: Data, decoder: JSONDecoder) throws -> [ImageAsset] {
        if let assets = try? decoder.decode([ImageAsset].self, from: data) {
            return assets
        }
        struct Envelope: Codable { var assets: [ImageAsset] }
        if let envelope = try? decoder.decode(Envelope.self, from: data) {
            return envelope.assets
        }
        return []
    }

    // MARK: - Tree membership (JSON merge — preserves all other tree fields)

    private static func mergeTreePhotoMembership(from source: URL, to destination: URL) throws -> Int {
        let sourceTreesURL = source.appendingPathComponent(LibraryPackageLayout.treesFileName)
        let destTreesURL = destination.appendingPathComponent(LibraryPackageLayout.treesFileName)
        guard FileManager.default.fileExists(atPath: sourceTreesURL.path),
              FileManager.default.fileExists(atPath: destTreesURL.path)
        else { return 0 }

        guard
            let sourceRoot = try JSONSerialization.jsonObject(with: Data(contentsOf: sourceTreesURL)) as? [String: Any],
            let destRoot = try JSONSerialization.jsonObject(with: Data(contentsOf: destTreesURL)) as? [String: Any],
            let sourceTrees = sourceRoot["trees"] as? [[String: Any]],
            var destTrees = destRoot["trees"] as? [[String: Any]]
        else { return 0 }

        var sourceByID: [String: [String: Any]] = [:]
        for tree in sourceTrees {
            if let id = tree["id"] as? String {
                sourceByID[id] = tree
            }
        }

        var merged = 0
        for i in destTrees.indices {
            guard let id = destTrees[i]["id"] as? String,
                  let sourceTree = sourceByID[id]
            else { continue }

            let destPrimary = destTrees[i]["primaryImageID"] as? String
            let destIDs = destTrees[i]["imageIDs"] as? [Any] ?? []
            let sourcePrimary = sourceTree["primaryImageID"] as? String
            let sourceIDs = sourceTree["imageIDs"] as? [Any] ?? []
            let destHasPhotos = (destPrimary?.isEmpty == false) || !destIDs.isEmpty
            let sourceHasPhotos = (sourcePrimary?.isEmpty == false) || !sourceIDs.isEmpty
            guard !destHasPhotos, sourceHasPhotos else { continue }

            if let sourcePrimary {
                destTrees[i]["primaryImageID"] = sourcePrimary
            }
            destTrees[i]["imageIDs"] = sourceIDs
            merged += 1
        }
        guard merged > 0 else { return 0 }

        var out = destRoot
        out["trees"] = destTrees
        let data = try JSONSerialization.data(withJSONObject: out, options: [.prettyPrinted, .sortedKeys])
        try data.write(to: destTreesURL, options: .atomic)
        return merged
    }

    private static func rebuildPhotoIndex(at destination: URL) throws {
        let treesURL = destination.appendingPathComponent(LibraryPackageLayout.treesFileName)
        guard
            let root = try JSONSerialization.jsonObject(with: Data(contentsOf: treesURL)) as? [String: Any],
            let trees = root["trees"] as? [[String: Any]]
        else { return }

        var bindings: [[String: Any]] = []
        for tree in trees {
            guard let treeID = tree["id"] as? String else { continue }
            var binding: [String: Any] = [
                "treeID": treeID,
                "imageIDs": tree["imageIDs"] as? [Any] ?? []
            ]
            if let primary = tree["primaryImageID"] as? String {
                binding["primaryImageID"] = primary
            }
            bindings.append(binding)
        }
        let index: [String: Any] = [
            "bindings": bindings,
            "treeIsPhotoSourceOfTruth": true
        ]
        let data = try JSONSerialization.data(withJSONObject: index, options: [.prettyPrinted, .sortedKeys])
        let indexURL = destination.appendingPathComponent(LibraryPackageLayout.treePhotoIndexFileName)
        try data.write(to: indexURL, options: .atomic)

        let ssot: [String: Any] = ["treeIsPhotoSourceOfTruth": true]
        let ssotData = try JSONSerialization.data(withJSONObject: ssot, options: [.prettyPrinted, .sortedKeys])
        let ssotURL = destination.appendingPathComponent(LibraryPackageLayout.treePhotoSSOTStateFileName)
        try ssotData.write(to: ssotURL, options: .atomic)
    }

    // MARK: - Helpers

    private static func isPackageMissingTrees(at root: URL) -> Bool {
        !packageHasTrees(at: root)
    }

    private static func packageHasTrees(at root: URL) -> Bool {
        let url = root.appendingPathComponent(LibraryPackageLayout.treesFileName)
        guard
            let rootObj = try? JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any],
            let trees = rootObj["trees"] as? [Any]
        else { return false }
        return !trees.isEmpty
    }

    private static func countFiles(under root: URL) -> Int {
        guard let enumerator = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else { return 0 }
        var count = 0
        for case let url as URL in enumerator {
            var isDir: ObjCBool = false
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), !isDir.boolValue {
                count += 1
            }
        }
        return count
    }
}
