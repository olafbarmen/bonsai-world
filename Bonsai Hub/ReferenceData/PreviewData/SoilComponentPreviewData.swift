//
//  SoilComponentPreviewData.swift
//  Bonsai World
//
//  Reference Data seed — Soil Components (ingredients).
//

import Foundation

enum SoilComponentPreviewData {
    static let all: [SoilComponent] = ReferencePreviewSeed.names(list: 12, [
        "Akadama",
        "Pumice",
        "Lava",
        "Kanuma",
        "Kiryu",
        "Pine Bark",
        "Coco Coir",
        "Perlite",
        "Vermiculite",
        "Sand",
    ]).map { SoilComponent(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
