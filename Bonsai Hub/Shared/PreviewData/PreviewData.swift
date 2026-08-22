//
//  PreviewData.swift
//  Bonsai World
//
//  Interim in-memory catalog for UI development until Core Storage exists.
//  Not a persistence layer. Observable so membership edits refresh all modules.
//
//  Each Tree stores one `locationID` pointing at Reference Data → Growing → Locations
//  (`LocationReference` via ReferenceDataService). PreviewData does not own Locations.
//  Organizational: Collections group trees via ``Collection/treeIDs`` (Collection-owned membership).
//  Master / Lists vocabularies live under ReferenceData/ (ReferenceDataService).
//
//  Tree identity: optional `nickname` + `botanicalName` + `bonsaiName` (registry code).
//  Botanical Reference Data IDs live on Tree; naming strings are filled by callers / seed.
//

import Foundation
import Observation

/// Central preview catalog. Inject via `.environment`. Membership can be toggled in session only.
@Observable
@MainActor
final class PreviewData {

    var trees: [Tree]
    var collections: [Collection]

    init() {
        // Seed catalog = imported inventory: Names are preserved as authored below.
        trees = Self.makeImportedTrees()
        collections = Self.makeCollections()
    }

    // MARK: - Membership (session only — not persisted; Collection.treeIDs is authoritative)

    /// Adds the tree to the collection if not already a member (no duplicates).
    func ensureMembership(treeID: UUID, collectionID: UUID) {
        guard trees.contains(where: { $0.id == treeID }),
              let collectionIndex = collections.firstIndex(where: { $0.id == collectionID })
        else { return }

        if !collections[collectionIndex].treeIDs.contains(treeID) {
            collections[collectionIndex].treeIDs.append(treeID)
        }
    }

    /// Adds or removes the tree from the collection.
    func toggleMembership(treeID: UUID, collectionID: UUID) {
        guard trees.contains(where: { $0.id == treeID }),
              let collectionIndex = collections.firstIndex(where: { $0.id == collectionID })
        else { return }

        if collections[collectionIndex].treeIDs.contains(treeID) {
            collections[collectionIndex].treeIDs.removeAll { $0 == treeID }
        } else {
            collections[collectionIndex].treeIDs.append(treeID)
        }
    }

    func isMember(treeID: UUID, collectionID: UUID) -> Bool {
        guard let collection = collection(id: collectionID) else { return false }
        return collection.treeIDs.contains(treeID)
    }

    /// Creates a manual collection with no members. Session only — not persisted.
    @discardableResult
    func addCollection(
        name: String,
        description: String = "",
        icon: String? = nil,
        color: String? = nil
    ) -> Collection {
        let collection = Collection(
            id: UUID(),
            name: name,
            description: description,
            type: .manual,
            color: color,
            icon: icon,
            treeIDs: []
        )
        collections.append(collection)
        return collection
    }

    /// Inserts a fully formed Collection (session only). Used by PreviewCollectionRepository.
    @discardableResult
    func insertCollection(_ collection: Collection) -> Collection {
        collections.append(collection)
        for treeID in collection.treeIDs {
            ensureMembership(treeID: treeID, collectionID: collection.id)
        }
        return collection
    }

    /// Replaces an existing Collection by id (session only). Used by PreviewCollectionRepository.
    @discardableResult
    func replaceCollection(_ collection: Collection) -> Collection {
        guard let index = collections.firstIndex(where: { $0.id == collection.id }) else {
            return insertCollection(collection)
        }
        collections[index] = collection
        return collection
    }

    /// Removes a Collection and cleans membership references (session only).
    func removeCollection(id: UUID) {
        collections.removeAll { $0.id == id }
    }

    // MARK: - Trees (session only — not persisted)

    /// Imports a Tree with an existing permanent Name (Excel / CSV / legacy DB).
    /// Preserves `nickname` via ``TreeNamingService/preservedImportedName(_:)``.
    @discardableResult
    func importTree(_ tree: Tree) -> Tree {
        var imported = tree
        imported.nickname = TreeNamingService.preservedImportedName(tree.nickname)
        imported.modifiedDate = .now
        trees.append(imported)
        return imported
    }

    /// Inserts a fully formed Tree (session only). Used by PreviewTreeRepository.
    @discardableResult
    func insertTree(_ tree: Tree) -> Tree {
        var inserted = tree
        if inserted.createdDate == .distantPast {
            inserted.createdDate = .now
        }
        inserted.modifiedDate = .now
        trees.append(inserted)
        return inserted
    }

    /// Replaces an existing Tree by id (session only). Used by PreviewTreeRepository.
    /// Permanent identity fields from the previous record are retained.
    @discardableResult
    func replaceTree(_ tree: Tree) -> Tree {
        guard let index = trees.firstIndex(where: { $0.id == tree.id }) else {
            return insertTree(tree)
        }
        var replaced = tree
        let previous = trees[index]
        replaced.id = previous.id
        replaced.genusID = previous.genusID
        replaced.speciesID = previous.speciesID
        replaced.cultivarID = previous.cultivarID
        replaced.botanicalName = previous.botanicalName
        replaced.bonsaiName = previous.bonsaiName
        replaced.modifiedDate = .now
        trees[index] = replaced
        return replaced
    }

    /// Removes a Tree and cleans Collection membership (session only).
    func removeTree(id: UUID) {
        trees.removeAll { $0.id == id }
        for index in collections.indices {
            collections[index].treeIDs.removeAll { $0 == id }
        }
    }

    // MARK: - Lookups

    func collection(id: UUID) -> Collection? {
        collections.first { $0.id == id }
    }

    func tree(id: UUID) -> Tree? {
        trees.first { $0.id == id }
    }

    /// Trees that are manual members of a Collection.
    func trees(in collectionID: UUID) -> [Tree] {
        guard let collection = collection(id: collectionID) else { return [] }
        let memberIDs = Set(collection.treeIDs)
        return trees.filter { memberIDs.contains($0.id) }
    }

    /// Trees physically at a Location (Collections are ignored).
    func trees(at locationID: UUID) -> [Tree] {
        trees.filter { $0.locationID == locationID }
    }

    /// Collections that include at least one tree currently at this Location.
    func collectionsTouching(locationID: UUID) -> [Collection] {
        let treeIDs = Set(trees(at: locationID).map(\.id))
        return collections.filter { collection in
            collection.treeIDs.contains { treeIDs.contains($0) }
        }
    }

    func collections(for treeID: UUID) -> [Collection] {
        collections.filter { $0.treeIDs.contains(treeID) }
    }

    // MARK: - Seed data

    enum StableID {
        static func location(_ n: Int) -> UUID {
            uuid(prefix: 1, n: n)
        }

        static func collection(_ n: Int) -> UUID {
            uuid(prefix: 2, n: n)
        }

        static func tree(_ n: Int) -> UUID {
            uuid(prefix: 3, n: n)
        }

        private static func uuid(prefix: Int, n: Int) -> UUID {
            UUID(uuidString: String(format: "00000000-0000-4000-8%03x-%012d", prefix, n))!
        }
    }

    /// Development seed from the one-time Olaf Excel migration (`OlafDevelopmentTrees.json`).
    private static func makeImportedTrees() -> [Tree] {
        let bundle = Bundle(for: PreviewData.self)
        // Synchronized Resources/Import files are copied flat into Contents/Resources.
        let url =
            bundle.url(forResource: "OlafDevelopmentTrees", withExtension: "json")
            ?? bundle.url(forResource: "OlafDevelopmentTrees", withExtension: "json", subdirectory: "Resources/Import")
            ?? bundle.url(forResource: "OlafDevelopmentTrees", withExtension: "json", subdirectory: "Import")
        guard let url else {
            preconditionFailure("Missing OlafDevelopmentTrees.json (run Scripts/dev_migrate_olaf_excel.py).")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryTreesFile.self, from: data).trees
        } catch {
            preconditionFailure("Failed to decode OlafDevelopmentTrees.json: \(error)")
        }
    }

    private static func makeCollections() -> [Collection] {
        // Memberships cleared after replacing the sample catalog with Olaf’s library.
        var collections = SystemSmartCollections.makeCollections(preservingTreeIDs: [:])
        collections.append(contentsOf: [
            Collection(
                id: StableID.collection(1),
                name: "Maples",
                description: "Maple material for study and seasonal color.",
                type: .manual,
                color: "#8B3A3A",
                icon: "leaf.fill",
                treeIDs: []
            ),
            Collection(
                id: StableID.collection(3),
                name: "Exhibition 2027",
                description: "Candidates and confirmed trees for the 2027 show.",
                type: .manual,
                color: "#3D6B5A",
                icon: "rosette",
                treeIDs: []
            ),
        ])
        return collections
    }
}
