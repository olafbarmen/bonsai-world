//
//  BonsaiNameSequenceStore.swift
//  Bonsai World
//
//  Persists per-species Bonsai Name sequence high-water marks in the library package.
//  Sequences never decrease when a tree is deleted — existing Bonsai Names stay fixed.
//

import Foundation
import Observation

/// On-disk envelope for `Database/BonsaiNameSequences.json`.
struct BonsaiNameSequenceFile: Codable, Hashable, Sendable {
    /// Highest sequence issued per species ID. Keys are species UUIDs.
    var highWaterBySpeciesID: [UUID: Int]

    init(highWaterBySpeciesID: [UUID: Int] = [:]) {
        self.highWaterBySpeciesID = highWaterBySpeciesID
    }
}

/// Library-backed Bonsai Name sequence high-water marks.
@Observable
@MainActor
final class BonsaiNameSequenceStore {
    private var highWaterBySpeciesID: [UUID: Int] = [:]
    private let storage: StorageService
    private var libraryPersistenceEnabled: Bool

    init(storage: StorageService, libraryPersistenceEnabled: Bool = false) {
        self.storage = storage
        self.libraryPersistenceEnabled = libraryPersistenceEnabled
        reload()
    }

    /// Enables writing to the library package (after First Launch Wizard completes).
    func setLibraryPersistenceEnabled(_ enabled: Bool) {
        libraryPersistenceEnabled = enabled
        if enabled {
            persist()
        }
    }

    func reload() {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.bonsaiNameSequencesFileName
            ) else {
                highWaterBySpeciesID = [:]
                return
            }
            let decoder = JSONDecoder()
            let file = try decoder.decode(BonsaiNameSequenceFile.self, from: data)
            highWaterBySpeciesID = file.highWaterBySpeciesID
        } catch {
            highWaterBySpeciesID = [:]
        }
    }

    /// Next available sequence for a species (does not consume or persist).
    func nextSequence(forSpecies speciesID: UUID, existingTrees: [Tree]) -> Int {
        TreeNamingService.nextSequence(
            forSpecies: speciesID,
            existingTrees: existingTrees,
            highWaterMark: highWaterBySpeciesID[speciesID] ?? 0
        )
    }

    /// Records a sequence from a tree's permanent Bonsai Name, if parseable.
    func noteTree(_ tree: Tree) {
        guard let speciesID = tree.speciesID,
              let sequence = TreeNamingService.parseBonsaiNameSequence(tree.bonsaiName)
        else { return }
        noteSequence(speciesID: speciesID, sequence: sequence)
    }

    /// Raises the high-water mark for a species. Never lowers existing values.
    func noteSequence(speciesID: UUID, sequence: Int) {
        guard sequence > 0 else { return }
        let current = highWaterBySpeciesID[speciesID] ?? 0
        guard sequence > current else { return }
        highWaterBySpeciesID[speciesID] = sequence
        persist()
    }

    /// Merges high-water marks from live trees without lowering persisted values.
    func reconcile(with trees: [Tree]) {
        var changed = false
        for tree in trees {
            guard let speciesID = tree.speciesID,
                  let sequence = TreeNamingService.parseBonsaiNameSequence(tree.bonsaiName)
            else { continue }
            let current = highWaterBySpeciesID[speciesID] ?? 0
            if sequence > current {
                highWaterBySpeciesID[speciesID] = sequence
                changed = true
            }
        }
        if changed {
            persist()
        }
    }

    // MARK: - Private

    private func persist() {
        guard libraryPersistenceEnabled else { return }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let file = BonsaiNameSequenceFile(highWaterBySpeciesID: highWaterBySpeciesID)
            let data = try encoder.encode(file)
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.bonsaiNameSequencesFileName,
                data: data
            )
        } catch {
            // Best-effort persistence.
        }
    }
}
