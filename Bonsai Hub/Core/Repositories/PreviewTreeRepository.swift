//
//  PreviewTreeRepository.swift
//  Bonsai World
//
//  TreeRepository backed by PreviewData only.
//  Development and migration infrastructure — not the runtime store once a
//  Bonsai World Library is available. Used for first launch (pre-library),
//  TreeMigrationService seeding, and SwiftUI #Preview fixtures.
//

import Foundation
import Observation

/// In-memory `TreeRepository` for previews, wizard bootstrap, and migration source.
@Observable
@MainActor
final class PreviewTreeRepository: TreeRepository {
    private let previewData: PreviewData

    init(previewData: PreviewData) {
        self.previewData = previewData
    }

    func getAllTrees() -> [Tree] {
        previewData.trees
    }

    func getTree(id: UUID) -> Tree? {
        previewData.tree(id: id)
    }

    @discardableResult
    func createTree(_ tree: Tree) throws -> Tree {
        if previewData.tree(id: tree.id) != nil {
            throw TreeRepositoryError.invalidTree("A tree with this id already exists.")
        }
        return previewData.insertTree(tree)
    }

    @discardableResult
    func updateTree(_ tree: Tree) throws -> Tree {
        guard previewData.tree(id: tree.id) != nil else {
            throw TreeRepositoryError.notFound(tree.id)
        }
        return previewData.replaceTree(tree)
    }

    func deleteTree(id: UUID) throws {
        guard previewData.tree(id: id) != nil else {
            throw TreeRepositoryError.notFound(id)
        }
        previewData.removeTree(id: id)
    }
}
