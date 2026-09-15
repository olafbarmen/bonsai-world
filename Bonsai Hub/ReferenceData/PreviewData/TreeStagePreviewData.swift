//
//  TreeStagePreviewData.swift
//  Bonsai World
//
//  Authoritative Tree Stage reference list (English).
//

import Foundation

enum TreeStagePreviewData {
    static let listNumber = 8

    static let canonicalNames: [String] = [
        "Seedling",
        "Cutting",
        "Nursery Stock",
        "Yamadori – Newly Collected",
        "Pre-Bonsai",
        "In Training",
        "Refinement",
        "Exhibition",
    ]

    static let all: [TreeStage] = ReferencePreviewSeed.names(list: listNumber, canonicalNames)
        .map { TreeStage(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }

    static func id(for canonicalName: String) -> UUID? {
        guard let index = canonicalNames.firstIndex(where: {
            $0.caseInsensitiveCompare(canonicalName) == .orderedSame
        }) else { return nil }
        return ReferencePreviewSeed.id(list: listNumber, n: index + 1)
    }

    static func stage(id: UUID) -> TreeStage? {
        all.first { $0.id == id }
    }
}
