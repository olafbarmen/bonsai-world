//
//  FertilizerTypePreviewData.swift
//  Bonsai World
//
//  Reference Data seed for FertilizerType — common starter products.
//  Growers can Add more in Settings → Reference Data → Fertilizer Types.
//

import Foundation

enum FertilizerTypePreviewData {
    /// Lists-worksheet style list index reserved for Fertilizer Types.
    private static let listIndex = 17

    private static let seeds: [(
        brand: String,
        name: String,
        form: FertilizerForm,
        release: FertilizerRelease,
        origin: FertilizerOrigin,
        npk: String
    )] = [
        ("BioGold", "Original", .pellet, .slowRelease, .organic, "5.5-6.5-3.5"),
        ("", "Hanagokoro", .pellet, .slowRelease, .organic, "4-5-4"),
        ("", "Tamahi", .pellet, .slowRelease, .organic, "4-6-3"),
        ("", "Aburakasu (Oil Cake)", .pellet, .slowRelease, .organic, ""),
        ("", "Rape Cake", .pellet, .slowRelease, .organic, ""),
        ("", "Chicken Manure Pellets", .pellet, .slowRelease, .organic, "4-3-3"),
        ("", "Liquid Seaweed", .liquid, .immediate, .organic, ""),
        ("", "Fish Emulsion", .liquid, .immediate, .organic, "5-1-1"),
        ("", "Bonsai Focus", .liquid, .immediate, .mineral, "4-5-8"),
        ("", "Controlled Release Granular", .granular, .slowRelease, .mineral, "14-14-14"),
    ]

    static let all: [FertilizerType] = seeds.enumerated().map { index, seed in
        FertilizerType(
            id: ReferencePreviewSeed.id(list: listIndex, n: index + 1),
            brand: seed.brand,
            name: seed.name,
            form: seed.form,
            release: seed.release,
            origin: seed.origin,
            npk: seed.npk,
            sortOrder: index + 1
        )
    }
}
