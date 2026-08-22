//
//  SpeciesPreviewData.swift
//  Bonsai World
//
//  Lists worksheet → Species + Code.
//  Each Species.genusID points at the Genus matching the binomial’s first word.
//

import Foundation

enum SpeciesPreviewData {
    private static let rows: [(name: String, code: String)] = [
        ("Juniperus chinensis", "JCH"),
        ("Juniperus procumbens", "JPR"),
        ("Juniperus rigida", "JRI"),
        ("Juniperus communis", "JCO"),
        ("Juniperus sabina", "JSA"),
        ("Acer palmatum", "APA"),
        ("Acer buergerianum", "ABU"),
        ("Acer japonicum", "AJO"),
        ("Acer campestre", "ACA"),
        ("Pinus thunbergii", "PTH"),
        ("Pinus sylvestris", "PSY"),
        ("Pinus mugo", "PMU"),
        ("Pinus parviflora", "PPF"),
        ("Larix decidua", "LDE"),
        ("Larix kaempferi", "LKA"),
        ("Picea abies", "PAB"),
        ("Taxus baccata", "TBA"),
        ("Ulmus parvifolia", "UPA"),
        ("Ulmus minor", "UMI"),
        ("Carpinus betulus", "CBE"),
        ("Carpinus coreana", "CCO"),
        ("Fagus sylvatica", "FSY"),
        ("Betula pendula", "BPE"),
        ("Pyrus pyraster", "PPY"),
    ]

    static let all: [Species] = rows.enumerated().map { index, row in
        let genusName = row.name.split(separator: " ").first.map(String.init) ?? ""
        return Species(
            id: ReferencePreviewSeed.id(list: 2, n: index + 1),
            name: row.name,
            genusID: GenusPreviewData.id(named: genusName),
            code: row.code,
            sortOrder: index + 1
        )
    }

    static func id(named name: String) -> UUID {
        guard let match = all.first(where: { $0.name == name }) else {
            preconditionFailure("Missing Species PreviewData for \(name)")
        }
        return match.id
    }
}
