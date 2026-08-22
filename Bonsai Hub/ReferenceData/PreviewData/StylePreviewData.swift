//
//  StylePreviewData.swift
//  Bonsai World
//
//  Reference Data — bonsai styles (same seed pattern as Tree Status).
//

import Foundation

enum StylePreviewData {
    static let all: [Style] = ReferencePreviewSeed.names(list: 21, [
        "Formal Upright",
        "Informal Upright",
        "Slanting",
        "Cascade",
        "Semi-cascade",
        "Literati",
        "Twin Trunk",
        "Clump",
        "Forest",
        "Root-over-rock",
        "Windswept",
        "Broom",
    ]).map { Style(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
