//
//  GenusPreviewData.swift
//  Bonsai World
//
//  Lists worksheet: unique genus names from Species binomials (order of appearance).
//

import Foundation

enum GenusPreviewData {
    /// Genus names in Lists Species order (first occurrence).
    static let namesInListsOrder: [String] = [
        "Juniperus",
        "Acer",
        "Pinus",
        "Larix",
        "Picea",
        "Taxus",
        "Ulmus",
        "Carpinus",
        "Fagus",
        "Betula",
        "Pyrus",
    ]

    static let all: [Genus] = ReferencePreviewSeed.names(list: 1, namesInListsOrder).map {
        Genus(id: $0.id, name: $0.name, sortOrder: $0.sortOrder)
    }

    static func id(named name: String) -> UUID {
        guard let match = all.first(where: { $0.name == name }) else {
            preconditionFailure("Missing Genus PreviewData for \(name)")
        }
        return match.id
    }
}
