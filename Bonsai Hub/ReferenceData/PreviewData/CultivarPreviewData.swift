//
//  CultivarPreviewData.swift
//  Bonsai World
//
//  Lists worksheet → section "Varieties".
//
//  Hierarchy (workbook convention + related VariantLister grouping):
//  - Juniper varieties → Juniperus chinensis
//  - Maple varieties → Acer palmatum
//  - Generic origin labels → Acer palmatum (listed with maple block in Lists)
//

import Foundation

enum CultivarPreviewData {
    private static let juniperChinensis: [String] = [
        "Itoigawa",
        "Kishu",
        "Shimpaku",
        "Blaauw",
        "Blue Alps",
        "San Jose",
        "Sargentii",
    ]

    private static let acerPalmatum: [String] = [
        "Deshojo",
        "Seigen",
        "Kiyohime",
        "Katsura",
        "Shishigashira",
        "Arakawa",
        "Atropurpureum",
        "Butterfly",
        "Orange Dream",
        "Sango kaku",
        "Beni Maiko",
        "Beni Hime",
        "Shaina",
        "Mikawa Yatsubusa",
        "Kotohime",
        "Little Princess",
        "Bloodgood",
        "Osakazuki",
        "Skeeters Broom",
        "Inaba Shidare",
        "Tamukeyama",
        "Viridis",
        "Garnet",
        "Red Dragon",
        "Orangeola",
        "Ukigumo",
        "Aoyagi",
        "Kamagata",
        "Hogyoku",
        "Moonrise",
        "Peaches and Cream",
        "Purple Ghost",
        "Amber Ghost",
        "Sister Ghost",
        "Fireglow",
        "Red Emperor",
        "Trompenburg",
        "Generic seed grown",
        "Field grown",
        "Collected yamadori",
    ]

    static let all: [Cultivar] = {
        let jch = SpeciesPreviewData.id(named: "Juniperus chinensis")
        let apa = SpeciesPreviewData.id(named: "Acer palmatum")

        var rows: [(name: String, speciesID: UUID)] = []
        rows += juniperChinensis.map { ($0, jch) }
        rows += acerPalmatum.map { ($0, apa) }

        return rows.enumerated().map { index, row in
            Cultivar(
                id: ReferencePreviewSeed.id(list: 3, n: index + 1),
                name: row.name,
                speciesID: row.speciesID,
                sortOrder: index + 1
            )
        }
    }()
}
