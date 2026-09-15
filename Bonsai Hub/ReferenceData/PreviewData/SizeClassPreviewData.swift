//
//  SizeClassPreviewData.swift
//  Bonsai World
//
//  Reference Data — size classes (same seed pattern as Tree Status).
//

import Foundation

enum SizeClassPreviewData {
    static let all: [SizeClass] = ReferencePreviewSeed.names(list: 22, [
        "Imperial / Hachi-uye (120–200+ cm)",
        "Omono / Dai (60–120 cm)",
        "Chumono (30–60 cm)",
        "Komono (15–30 cm)",
        "Shohin (10–20 cm)",
        "Mame (5–10 cm)",
        "Keshitsubo (<5 cm)",
        "In training",
    ]).map { SizeClass(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
