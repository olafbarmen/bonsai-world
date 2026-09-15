//
//  StylePreviewData.swift
//  Bonsai World
//
//  Reference Data — bonsai styles (same seed pattern as Tree Status).
//

import Foundation

enum StylePreviewData {
    static let all: [Style] = ReferencePreviewSeed.names(list: 21, [
        "Formal Upright (Chokkan)",
        "Informal Upright (Moyogi)",
        "Slanting (Shakan)",
        "Cascade (Kengai)",
        "Semi-Cascade (Han-kengai)",
        "Literati (Bunjin)",
        "Twin Trunk (Sokan)",
        "Forest Planting (Yose-ue)",
        "Windswept (Fukinagashi)",
        "Raft (Ikadabuki)",
        "Root-over-Rock (Sekijoju)",
        "Clinging-to-Rock (Ishitsuki)",
        "Broom (Hokidachi)",
        "Multi-Trunk (Kabudachi)",
        "Exposed Root (Neagari)",
        "Driftwood (Sharimiki)",
        "Weeping (Shidare-zukuri)",
    ]).map { Style(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
