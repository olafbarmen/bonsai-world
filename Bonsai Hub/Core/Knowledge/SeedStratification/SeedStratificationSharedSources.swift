//
//  SeedStratificationSharedSources.swift
//  Bonsai World
//
//  Shared bibliographic sources for the seed stratification catalog.
//  Prefer government / forestry / scientific references over secondary blogs.
//

import Foundation

enum SeedStratificationSharedSources {
    static let usdaWoodyPlantSeedManual = StratificationSource(
        title: "The Woody Plant Seed Manual",
        organization: "USDA Forest Service",
        author: "Bonner, F.T.; Karrfalt, R.P. (eds.)",
        year: 2008,
        sourceType: .government,
        urlString: "https://www.fs.usda.gov/nsl/wpsm/",
        referenceNote: "Primary North American woody-seed reference; species chapters vary in specificity."
    )

    static let iufroSeedManual = StratificationSource(
        title: "Tree and Shrub Seed Handbook (selected European species guidance)",
        organization: "Forestry / seed-testing literature",
        author: "",
        year: nil,
        sourceType: .forestryManual,
        referenceNote: "Used as supporting context for European temperate species where USDA coverage is limited."
    )

    static let europeanNurseryPractice = StratificationSource(
        title: "Temperate nursery and forestry practice summaries",
        organization: "Horticultural / forestry extension summaries",
        author: "",
        year: nil,
        sourceType: .horticulturalOrganization,
        referenceNote: "Secondary synthesis — prefer USDA or peer-reviewed data when they conflict."
    )

    static let scientificVariationNote = StratificationSource(
        title: "Seed dormancy variation literature (review-level)",
        organization: "Peer-reviewed dormancy research corpus",
        author: "",
        year: nil,
        sourceType: .scientificPaper,
        referenceNote: "Documents that dormancy depth and required sequences vary by provenance and seed lot."
    )
}
