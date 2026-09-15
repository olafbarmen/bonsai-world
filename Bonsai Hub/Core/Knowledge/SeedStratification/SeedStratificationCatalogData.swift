//
//  SeedStratificationCatalogData.swift
//  Bonsai World
//
//  Initial authoritative seed stratification species matrix.
//  Ranges only — no false precision. Empty fields stay nil when unsupported.
//

import Foundation

enum SeedStratificationCatalogData {
    /// Stable speciesID: Botanical Library list-2 UUID when binomial exists; else list-90 UUID.
    static func speciesID(forScientificName name: String) -> UUID {
        if let match = SpeciesPreviewData.all.first(where: {
            $0.name.caseInsensitiveCompare(name) == .orderedSame
        }) {
            return match.id
        }
        return ReferencePreviewSeed.id(list: 90, named: name)
    }

    /// Cached once — building/sorting the matrix repeatedly freezes the main thread.
    static let all: [SpeciesStratificationProfile] = {
        profiles.sorted {
            $0.scientificName.localizedCaseInsensitiveCompare($1.scientificName) == .orderedAscending
        }
    }()

    private static let usda = SeedStratificationSharedSources.usdaWoodyPlantSeedManual
    private static let forestry = SeedStratificationSharedSources.iufroSeedManual
    private static let nursery = SeedStratificationSharedSources.europeanNurseryPractice
    private static let variation = SeedStratificationSharedSources.scientificVariationNote

    private static let profiles: [SpeciesStratificationProfile] = [
            // MARK: Acer
            make(
                "Acer", "palmatum", "Japanese maple",
                bonsai: "Core deciduous bonsai maple; cultivars do not come true from seed.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: true,
                sequence: [
                    step(1, .soaking, notes: "Warm-water pretreatment may help dry seed; fresh seed may differ.", optional: true),
                    step(2, .coldStratification, tMin: 1, tMax: 8, dMin: 60, dMax: 120, moisture: .moist),
                    step(3, .germination)
                ],
                dormancyNote: "Physiological / variable by seed lot and storage.",
                why: "Cold moist stratification is the standard approach for many Acer palmatum seed lots.",
                monitoring: "Keep medium moist, not saturated. Watch for mold and premature germination.",
                confidence: .high,
                difficulty: .moderate,
                sources: [usda, nursery],
                notes: "Named cultivars do not reliably reproduce true from seed. Fresh vs dry seed may respond differently."
            ),
            make(
                "Acer", "buergerianum", "Trident maple",
                bonsai: "Important bonsai maple; vigorous nursery subject.",
                dormancy: .variable,
                treatment: .variable,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification is often used; duration varies by seed lot — do not invent a fixed day count.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                why: "Published guidance varies by lot; treat as variable rather than a single recipe.",
                monitoring: "Monitor moisture and mold; adjust duration within published ranges for the lot.",
                confidence: .variable,
                difficulty: .moderate,
                sources: [usda, variation],
                notes: "Conservative stance: prefer lot-specific guidance over a universal cold duration."
            ),
            make(
                "Acer", "ginnala", "Amur maple",
                bonsai: "Hardy maple used in bonsai and landscape.",
                dormancy: .morphophysiological,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 20, tMax: 30, dMin: 30, dMax: 60, moisture: .moist),
                    step(2, .coldStratification, tMin: 5, tMax: 5, dMin: 90, dMax: 150, moisture: .moist),
                    step(3, .germination)
                ],
                why: "Warm → cold sequences are reported for deeper dormancy in this species.",
                monitoring: "Complete warm phase before cold; check moisture throughout.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda],
                notes: "Do not skip the warm phase when following a warm→cold protocol."
            ),
            make(
                "Acer", "campestre", "Field maple",
                bonsai: "European field maple; bonsai-capable.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / variable — duration depends on seed lot.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                why: "Cold treatment is commonly used, but requirements vary.",
                confidence: .moderate,
                difficulty: .moderate,
                sources: [forestry, nursery],
                notes: "Do not assume all Acer species share Acer palmatum schedules."
            ),
            make(
                "Acer", "platanoides", "Norway maple",
                bonsai: "Occasionally used; invasive concerns in some regions.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold treatment / variable by lot.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                why: "Cold pretreatment is often discussed; precise universal durations are not assumed here.",
                confidence: .moderate,
                difficulty: .moderate,
                sources: [forestry, variation],
                notes: "Do not assume identical dormancy across Acer."
            ),
            make(
                "Acer", "pseudoplatanus", "Sycamore maple",
                bonsai: "Large maple; less common as fine bonsai.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / variable.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [forestry, nursery],
                notes: "Variable response; avoid a single fixed recipe."
            ),

            // MARK: Pinus
            make(
                "Pinus", "sylvestris", "Scots pine",
                bonsai: "Classic pine for bonsai in Europe.",
                dormancy: .noneOrMinimal,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Direct sowing is often possible."),
                    step(2, .coldStratification, notes: "Cold stratification may improve or standardize germination depending on seed lot.", moisture: .moist, optional: true),
                    step(3, .germination)
                ],
                alt: "Direct sowing and optional cold pretreatment can coexist — choose based on seed lot behavior.",
                why: "Many lots germinate without forced cold; some benefit from short cold moist treatment.",
                confidence: .moderate,
                difficulty: .straightforward,
                sources: [usda, forestry],
                notes: "Do not force a universal stratification period."
            ),
            make(
                "Pinus", "thunbergii", "Japanese black pine",
                bonsai: "Core Japanese pine for bonsai.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification may be used; not framed as universally mandatory here.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [usda, nursery],
                notes: "Represent as variable unless a specific lot source states otherwise."
            ),
            make(
                "Pinus", "mugo", "Mountain pine",
                bonsai: "Popular alpine pine for bonsai.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Direct sowing may succeed for some lots."),
                    step(2, .coldStratification, notes: "Cold treatment information may apply depending on lot.", moisture: .moist, optional: true),
                    step(3, .germination)
                ],
                alt: "Allow direct sowing and cold-treatment pathways to coexist.",
                confidence: .moderate,
                difficulty: .moderate,
                sources: [forestry, variation],
                notes: "Variable — do not invent a universal cold duration."
            ),
            make(
                "Pinus", "parviflora", "Japanese white pine",
                bonsai: "Highly valued white pine for bonsai.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Treatment is variable; no universal cold duration is asserted.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [nursery, variation],
                notes: "Do not invent a universal cold duration."
            ),

            // MARK: Picea / Larix
            make(
                "Picea", "abies", "Norway spruce",
                bonsai: "Common spruce; used in bonsai.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Usually no pretreatment required."),
                    step(2, .germination, notes: "Direct sowing when germination conditions are suitable.")
                ],
                why: "Fresh spruce seed often germinates without cold stratification.",
                confidence: .high,
                difficulty: .straightforward,
                sources: [usda, forestry],
                notes: "Do not unnecessarily recommend cold stratification."
            ),
            make(
                "Larix", "decidua", "European larch",
                bonsai: "Deciduous conifer valued for bonsai.",
                dormancy: .noneOrMinimal,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Usually no pretreatment required for fresh seed."),
                    step(2, .coldStratification, tMin: 0, tMax: 4, dMin: 20, dMax: 60, notes: "For stored seed, cold stratification can improve germination.", moisture: .moist, optional: true),
                    step(3, .germination)
                ],
                alt: "Fresh seed: direct sowing. Stored seed: optional cold 0–4 °C for 20–60 days.",
                why: "Storage can deepen dormancy; cold moist treatment may restore germination performance.",
                confidence: .high,
                difficulty: .straightforward,
                sources: [usda, forestry],
                notes: "Preserve fresh vs stored distinction."
            ),

            // MARK: Juniperus
            make(
                "Juniperus", "virginiana", "Eastern redcedar",
                bonsai: "North American juniper used in bonsai.",
                dormancy: .combined,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 20, tMax: 25, dMin: 45, dMax: 60, moisture: .moist),
                    step(2, .coldStratification, tMin: 5, tMax: 5, dMin: 45, dMax: 70, moisture: .moist),
                    step(3, .germination)
                ],
                why: "Seed coat and embryo dormancy can both be involved; sequential warm→cold is a documented approach.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda],
                notes: "Do not collapse junipers into one generic recipe."
            ),
            make(
                "Juniperus", "occidentalis", "Western juniper",
                bonsai: "Western North American juniper.",
                dormancy: .combined,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 20, tMax: 27, dMin: 45, dMax: 90, moisture: .moist),
                    step(2, .coldStratification, tMin: 4, tMax: 4, notes: "Cold treatment required; duration may be prolonged — avoid inventing a single day count beyond source support.", moisture: .moist),
                    step(3, .germination)
                ],
                why: "Prolonged warm→cold treatment is characteristic; germination can be erratic.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda],
                notes: "Germination may be erratic and prolonged."
            ),
            make(
                "Juniperus", "scopulorum", "Rocky Mountain juniper",
                bonsai: "Rocky Mountain juniper; bonsai subject.",
                dormancy: .variable,
                treatment: .variable,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification may be required for the dormant portion of the embryo; protocols are complex/variable.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                why: "Complex dormancy — do not simplify into a single fixed recipe.",
                confidence: .moderate,
                difficulty: .demanding,
                sources: [usda, variation],
                notes: "Keep representation complex/variable."
            ),
            make(
                "Juniperus", "horizontalis", "Creeping juniper",
                bonsai: "Prostrate juniper used in bonsai and landscape.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, tMin: 0, tMax: 10, dMin: 100, dMax: 100, notes: "A published treatment of approximately 100 days at ~5 °C has been reported; temperature band approximately 0–10 °C.", moisture: .moist),
                    step(2, .germination)
                ],
                why: "Cold stratification / after-ripening reported for this species.",
                confidence: .moderate,
                difficulty: .moderate,
                sources: [usda, variation],
                notes: "Published ~100 days at 5 °C is a reported protocol, not a guarantee for every lot."
            ),

            // MARK: Taxus / Fagus / Carpinus
            make(
                "Taxus", "baccata", "European yew",
                bonsai: "Classic yew for bonsai; slow.",
                dormancy: .morphophysiological,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 15, tMax: 20, dMin: 90, dMax: 210, moisture: .moist),
                    step(2, .coldStratification, tMin: 2, tMax: 5, dMin: 60, dMax: 120, moisture: .moist),
                    step(3, .germination)
                ],
                why: "Deep morphophysiological dormancy requires a prolonged warm→cold sequence.",
                monitoring: "Expect a long timeline; do not treat as a simple 3-month cold stratification.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda, forestry],
                notes: "WARNING: Germination may require a prolonged treatment sequence and may extend over more than one growing season."
            ),
            make(
                "Fagus", "sylvatica", "European beech",
                bonsai: "Beech bonsai subject.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, tMin: 1, tMax: 3, dMin: 60, dMax: 90, moisture: .moist),
                    step(2, .germination)
                ],
                why: "Cold moist stratification is standard for European beech.",
                monitoring: "Seeds may begin germinating during stratification — check regularly.",
                confidence: .high,
                difficulty: .moderate,
                sources: [usda, forestry],
                notes: "Watch for early germination in cold storage."
            ),
            make(
                "Carpinus", "betulus", "European hornbeam",
                bonsai: "Important European bonsai species.",
                dormancy: .combined,
                treatment: .variable,
                required: true,
                scarify: true,
                soak: false,
                sequence: [
                    step(1, .scarification, notes: "Physical barrier may be involved; methods are species/lot specific.", optional: true),
                    step(2, .warmStratification, notes: "Complex sequences are reported; do not oversimplify.", moisture: .moist, optional: true),
                    step(3, .coldStratification, notes: "Cold phase often part of practical protocols; durations vary.", moisture: .moist, optional: true),
                    step(4, .germination)
                ],
                why: "Deep physical + morphological dormancy components are reported; practical treatments are complex.",
                confidence: .moderate,
                difficulty: .demanding,
                sources: [forestry, variation, usda],
                notes: "High confidence for dormancy classification; moderate for any single practical recipe. Secondary dormancy can occur. Treatment timing and seed moisture are important."
            ),

            // MARK: Quercus
            make(
                "Quercus", "robur", "English oak",
                bonsai: "Oak bonsai; large leaves a challenge.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Usually no conventional cold stratification required for radicle emergence."),
                    step(2, .germination, notes: "Handle and sow fresh acorns promptly.")
                ],
                why: "Recalcitrant acorns are best handled fresh; radicle and epicotyl can have different temperature needs.",
                confidence: .high,
                difficulty: .moderate,
                sources: [usda, forestry],
                notes: "Fresh sowing preferred. Radicle vs epicotyl emergence may differ."
            ),
            make(
                "Quercus", "petraea", "Sessile oak",
                bonsai: "European oak for bonsai.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Fresh sowing preferred."),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [forestry, nursery],
                notes: "Stratification is not normally required in the same way as deeply dormant species."
            ),
            make(
                "Quercus", "ilex", "Holm oak",
                bonsai: "Evergreen oak; Mediterranean bonsai subject.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Some acorns germinate soon after dispersal."),
                    step(2, .germination, notes: "Shoot emergence may be delayed relative to radicle growth.")
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [variation, nursery],
                notes: "Variable — radicle may precede shoot emergence."
            ),

            // MARK: Ulmus
            make(
                "Ulmus", "glabra", "Wych elm",
                bonsai: "Elm for bonsai; disease considerations apply.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "No pretreatment normally required when fresh."),
                    step(2, .germination)
                ],
                confidence: .high,
                difficulty: .straightforward,
                sources: [forestry, nursery],
                notes: "Seed loses viability quickly — sow promptly."
            ),
            make(
                "Ulmus", "minor", "Field elm",
                bonsai: "European field elm.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Fresh sowing; generally no stratification required."),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .straightforward,
                sources: [forestry, nursery],
                notes: "Prefer fresh seed."
            ),
            make(
                "Ulmus", "parvifolia", "Chinese elm",
                bonsai: "Core bonsai elm.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Fresh seed can germinate rapidly."),
                    step(2, .coldStratification, dMin: 30, dMax: 60, notes: "Stored seed: about 1–2 months stratification may improve germination.", moisture: .moist, optional: true),
                    step(3, .germination)
                ],
                alt: "Fresh: sow promptly. Stored: optional cold moist period (~1–2 months).",
                confidence: .moderate,
                difficulty: .straightforward,
                sources: [nursery, usda],
                notes: "Preserve fresh vs stored distinction."
            ),

            // MARK: Malus / Prunus
            make(
                "Malus", "sylvestris", "European crab apple",
                bonsai: "Crabapple for bonsai.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification required; use a published range for the lot — no single fixed day count asserted here.", moisture: .moist),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [usda, variation],
                notes: "Use a range rather than a single fixed number. Cultivars do not come true from seed."
            ),
            make(
                "Malus", "domestica", "Apple",
                bonsai: "Apple/crabapple bonsai from seed; cultivars not true-to-type.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, tMin: 1, tMax: 5, dMin: 30, dMax: 90, notes: "Cold moist stratification range commonly cited in woody-seed manuals.", moisture: .moist),
                    step(2, .germination)
                ],
                confidence: .high,
                difficulty: .moderate,
                sources: [usda],
                notes: "Do not assume bonsai cultivars reproduce true from seed."
            ),
            make(
                "Prunus", "avium", "Wild cherry / sweet cherry",
                bonsai: "Cherry for bonsai; species-specific dormancy.",
                dormancy: .physiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, notes: "Warm pretreatment may help depending on seed condition.", moisture: .moist, optional: true),
                    step(2, .coldStratification, notes: "Cold stratification is the core treatment; durations vary by lot.", moisture: .moist),
                    step(3, .germination)
                ],
                confidence: .high,
                difficulty: .moderate,
                sources: [usda, forestry],
                notes: "Prunus requires species-specific records — do not generalize across the genus."
            ),
            make(
                "Prunus", "cerasifera", "Myrobalan plum / cherry plum",
                bonsai: "Plum used in bonsai.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / variable.", moisture: .moist),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [nursery, variation],
                notes: "Variable — avoid a fixed universal schedule."
            ),
            make(
                "Prunus", "mahaleb", "Mahaleb cherry",
                bonsai: "Rootstock/cherry species; bonsai possible.",
                dormancy: .variable,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, notes: "Often warm→cold or prolonged stratification.", moisture: .moist, optional: true),
                    step(2, .coldStratification, notes: "Cold phase commonly required; duration variable.", moisture: .moist),
                    step(3, .germination)
                ],
                confidence: .moderate,
                difficulty: .demanding,
                sources: [usda, variation],
                notes: "Often warm→cold or prolonged stratification."
            ),
            make(
                "Prunus", "spinosa", "Blackthorn / sloe",
                bonsai: "Blackthorn for bonsai.",
                dormancy: .variable,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, notes: "Warm→cold may be required.", moisture: .moist, optional: true),
                    step(2, .coldStratification, notes: "Cold phase; duration variable by lot.", moisture: .moist),
                    step(3, .germination)
                ],
                confidence: .moderate,
                difficulty: .demanding,
                sources: [forestry, variation],
                notes: "Warm→cold may be required; do not invent exact day counts without sources."
            ),

            // MARK: Fraxinus / Sorbus / Crataegus
            make(
                "Fraxinus", "excelsior", "European ash",
                bonsai: "Ash for bonsai; disease considerations apply.",
                dormancy: .morphophysiological,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / often complex dormancy — avoid a false single-number recipe.", moisture: .moist),
                    step(2, .germination)
                ],
                why: "Ash dormancy is often deep/complex; cold treatment is part of practical protocols.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda, forestry],
                notes: "Often complex dormancy — further lot-specific research recommended for precise schedules."
            ),
            make(
                "Sorbus", "aucuparia", "Rowan",
                bonsai: "Rowan/mountain ash for bonsai.",
                dormancy: .morphophysiological,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 10, tMax: 30, dMin: 16, dMax: 45, moisture: .moist),
                    step(2, .coldStratification, tMin: 2, tMax: 2, dMin: 180, dMax: 180, notes: "Approximately 180 days cold is a useful starting protocol for stored seed; studies show substantial variation.", moisture: .moist),
                    step(3, .germination)
                ],
                why: "Warm→cold is a useful starting protocol for stored seed; long cold requirements are reported.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda, variation],
                notes: "Published studies show substantial variation and long cold requirements."
            ),
            make(
                "Crataegus", "monogyna", "Common hawthorn",
                bonsai: "Hawthorn classic for bonsai.",
                dormancy: .morphophysiological,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, tMin: 15, tMax: 15, dMin: 90, dMax: 90, moisture: .moist),
                    step(2, .coldStratification, tMin: 4, tMax: 4, dMin: 90, dMax: 90, moisture: .moist),
                    step(3, .germination)
                ],
                why: "Warm→cold sequences are a documented starting protocol.",
                confidence: .high,
                difficulty: .demanding,
                sources: [usda, forestry],
                notes: "Germination may still be delayed and erratic."
            ),

            // MARK: Tilia / Betula / Ginkgo
            make(
                "Tilia", "cordata", "Small-leaved lime",
                bonsai: "Lime/linden for bonsai.",
                dormancy: .combined,
                treatment: .combined,
                required: true,
                scarify: true,
                soak: false,
                sequence: [
                    step(1, .scarification, notes: "Scarification/pretreatment may be required.", optional: true),
                    step(2, .coldStratification, notes: "Prolonged stratification often follows pretreatment; do not simplify to a short cold-only recipe.", moisture: .moist),
                    step(3, .germination)
                ],
                why: "Hard seed coats and deep dormancy can combine; protocols are multi-step.",
                confidence: .moderate,
                difficulty: .demanding,
                sources: [forestry, variation],
                notes: "Do not simplify. Additional research recommended for lot-specific durations."
            ),
            make(
                "Tilia", "platyphyllos", "Large-leaved lime",
                bonsai: "Large-leaved lime.",
                dormancy: .combined,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, notes: "Warm/cold treatment may be required.", moisture: .moist, optional: true),
                    step(2, .coldStratification, notes: "Cold phase; duration variable.", moisture: .moist),
                    step(3, .germination)
                ],
                confidence: .moderate,
                difficulty: .demanding,
                sources: [forestry, variation],
                notes: "Complex dormancy — avoid oversimplified fixed recipes."
            ),
            make(
                "Betula", "pendula", "Silver birch",
                bonsai: "Birch for bonsai; fine twigging.",
                dormancy: .noneOrMinimal,
                treatment: .none,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Usually no extensive stratification required."),
                    step(2, .germination, notes: "Light may be important for germination.")
                ],
                confidence: .moderate,
                difficulty: .straightforward,
                sources: [usda, forestry],
                notes: "Light can matter for germination."
            ),
            make(
                "Ginkgo", "biloba", "Ginkgo",
                bonsai: "Ginkgo bonsai; unique deciduous gymnosperm.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .none, notes: "Fresh seed may germinate without extensive cold treatment."),
                    step(2, .coldStratification, notes: "Cold treatment may improve or standardize germination.", moisture: .moist, optional: true),
                    step(3, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [usda, nursery],
                notes: "Do not create a false mandatory stratification requirement."
            ),

            // MARK: Zelkova / Cercidiphyllum / Cotoneaster / Pyracantha / Rosa
            make(
                "Zelkova", "serrata", "Japanese zelkova",
                bonsai: "Classic Japanese deciduous bonsai.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / variable — no universal fixed duration asserted.", moisture: .moist),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [nursery, variation],
                notes: "Variable — prefer lot-specific guidance."
            ),
            make(
                "Cercidiphyllum", "japonicum", "Katsura",
                bonsai: "Katsura for bonsai.",
                dormancy: .variable,
                treatment: .coldStratification,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification / variable.", moisture: .moist),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [nursery, variation],
                notes: "Additional research recommended for precise ranges."
            ),
            make(
                "Cotoneaster", "horizontalis", "Creeping cotoneaster",
                bonsai: "Cotoneaster for bonsai.",
                dormancy: .variable,
                treatment: .warmThenCold,
                required: true,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .warmStratification, notes: "Complex / often warm→cold — exact values not invented here.", moisture: .moist, optional: true),
                    step(2, .coldStratification, notes: "Cold phase often used; durations vary.", moisture: .moist),
                    step(3, .germination)
                ],
                confidence: .moderate,
                difficulty: .demanding,
                sources: [variation, nursery],
                notes: "Do not invent exact values unless supported by a source."
            ),
            make(
                "Pyracantha", "coccinea", "Firethorn",
                bonsai: "Firethorn for bonsai.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Variable / possible cold stratification.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [nursery, variation],
                notes: "Variable — avoid false precision."
            ),
            make(
                "Rosa", "rugosa", "Rugosa rose",
                bonsai: "Rose for bonsai / accent.",
                dormancy: .variable,
                treatment: .variable,
                required: false,
                scarify: false,
                soak: false,
                sequence: [
                    step(1, .coldStratification, notes: "Cold stratification may improve germination; represent as variable.", moisture: .moist, optional: true),
                    step(2, .germination)
                ],
                confidence: .moderate,
                difficulty: .moderate,
                sources: [usda, nursery],
                notes: "Variable — cultivars do not come true from seed."
            )
        ]

    // MARK: - Builders

    private static func make(
        _ genus: String,
        _ species: String,
        _ common: String,
        bonsai: String,
        dormancy: DormancyType,
        treatment: StratificationTreatmentType,
        required: Bool,
        scarify: Bool,
        soak: Bool,
        sequence: [StratificationTreatmentStep],
        alt: String = "",
        dormancyNote: String = "",
        why: String = "",
        monitoring: String = "Check moisture, mold, and premature germination. Keep moist, not saturated.",
        confidence: StratificationConfidenceLevel,
        difficulty: StratificationDifficulty,
        sources: [StratificationSource],
        notes: String,
        moisture: MoistureLevel = .moist
    ) -> SpeciesStratificationProfile {
        let scientific = "\(genus) \(species)"
        var mergedNotes = notes
        if !dormancyNote.isEmpty {
            mergedNotes = dormancyNote + "\n\n" + mergedNotes
        }
        return SpeciesStratificationProfile(
            speciesID: speciesID(forScientificName: scientific),
            genus: genus,
            species: species,
            commonName: common,
            bonsaiRelevance: bonsai,
            dormancyType: dormancy,
            treatmentRequired: required,
            scarificationRequired: scarify,
            soakingRequired: soak,
            treatmentType: treatment,
            treatmentSequence: sequence,
            alternativeTreatmentNotes: alt,
            moistureRequirement: moisture,
            germinationTemperatureMin: nil,
            germinationTemperatureMax: nil,
            sowingDepthGuidance: "",
            monitoringNotes: monitoring,
            whyThisTreatment: why.isEmpty ? treatment.title : why,
            difficulty: difficulty,
            confidenceLevel: confidence,
            sources: sources,
            notes: mergedNotes
        )
    }

    private static func step(
        _ order: Int,
        _ type: StratificationPhaseType,
        tMin: Double? = nil,
        tMax: Double? = nil,
        dMin: Int? = nil,
        dMax: Int? = nil,
        notes: String = "",
        moisture: MoistureLevel? = nil,
        optional: Bool = false
    ) -> StratificationTreatmentStep {
        StratificationTreatmentStep(
            order: order,
            type: type,
            temperatureMin: tMin,
            temperatureMax: tMax,
            durationMinDays: dMin,
            durationMaxDays: dMax,
            moisture: moisture,
            notes: notes,
            isOptional: optional
        )
    }
}
