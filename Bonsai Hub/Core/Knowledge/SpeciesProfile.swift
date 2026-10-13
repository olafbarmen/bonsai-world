//
//  SpeciesProfile.swift
//  Bonsai World
//
//  Knowledge → Species Library. Rich species guidance linked to Botanical Library
//  Species by stable speciesID. Separate from Reference Data identity records.
//

import Foundation

enum SpeciesKnowledgeStatus: String, Codable, Hashable, Sendable {
    case draft
    case reviewed

    var title: String {
        switch self {
        case .draft: "Draft"
        case .reviewed: "Reviewed"
        }
    }
}

/// Structured traits for engines and compact UI — not a care recipe.
struct SpeciesProfileTraits: Hashable, Sendable {
    var deciduous: Bool
    var growthStrength: String
    var growthSpeed: String
    var leafSize: String
    /// Leaf or needle reduction tendency — Bonsai World assessment, not a guarantee.
    var foliageReduction: String
    var ramificationPotential: String
    var backBudding: String
    var rootDevelopment: String
    var nebariPotential: String
    var trunkDevelopment: String
    var barkDevelopment: String
    var wiring: String
    var defoliation: String
    var airLayering: String
    var threadGrafting: String
    var rootGrafting: String
    var beginnerSuitability: String
    var bonsaiSuitability: String
    var difficulty: String
    var winterDormancyRequired: Bool
    var winterHardiness: String
    var rootFrostSensitivity: String
}

struct SpeciesProfileSection: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var paragraphs: [String]
    var bullets: [String]

    init(id: String, title: String, paragraphs: [String] = [], bullets: [String] = []) {
        self.id = id
        self.title = title
        self.paragraphs = paragraphs
        self.bullets = bullets
    }
}

/// Knowledge profile for one Botanical Library Species, or a Cultivar under that Species.
/// Links via permanent ``speciesID`` / ``cultivarID`` (see ``BotanicalKnowledgeIDs``) —
/// not via display-name string matching.
struct SpeciesProfile: Identifiable, Hashable, Sendable {
    /// Profile identity: cultivar ID when set, otherwise Botanical Species ID.
    var id: UUID { cultivarID ?? speciesID }
    /// Botanical Library ``Species/id`` (parent species for cultivar profiles).
    var speciesID: UUID
    /// Botanical Library ``Cultivar/id`` when this profile is cultivar-specific.
    var cultivarID: UUID?
    var scientificName: String
    var commonNames: [String]
    /// Historical or horticultural synonyms that resolve to this accepted profile.
    var synonyms: [String]
    var family: String
    var plantType: String
    var originSummary: String
    var knowledgeStatus: SpeciesKnowledgeStatus
    var traits: SpeciesProfileTraits
    /// Quick Reference label for foliage size (e.g. "Leaf size" or "Needle size").
    var foliageSizeLabel: String
    /// Quick Reference label for foliage reduction (e.g. "Leaf reduction" or "Needle reduction").
    var foliageReductionLabel: String
    /// One-line summary for Tree Detail card.
    var summaryLine: String
    /// Short attention lines for Tree Detail card (species tendencies only).
    var attentionHighlights: [String]
    var sections: [SpeciesProfileSection]
    var principleNote: String
    var sourcesNote: String

    var primaryCommonName: String { commonNames.first ?? scientificName }

    var searchText: String {
        ([scientificName] + commonNames + synonyms + [family, plantType]).joined(separator: " ")
    }

    init(
        speciesID: UUID,
        cultivarID: UUID? = nil,
        scientificName: String,
        commonNames: [String],
        synonyms: [String] = [],
        family: String,
        plantType: String,
        originSummary: String,
        knowledgeStatus: SpeciesKnowledgeStatus,
        traits: SpeciesProfileTraits,
        foliageSizeLabel: String = "Leaf size",
        foliageReductionLabel: String = "Leaf reduction",
        summaryLine: String,
        attentionHighlights: [String],
        sections: [SpeciesProfileSection],
        principleNote: String,
        sourcesNote: String
    ) {
        self.speciesID = speciesID
        self.cultivarID = cultivarID
        self.scientificName = scientificName
        self.commonNames = commonNames
        self.synonyms = synonyms
        self.family = family
        self.plantType = plantType
        self.originSummary = originSummary
        self.knowledgeStatus = knowledgeStatus
        self.traits = traits
        self.foliageSizeLabel = foliageSizeLabel
        self.foliageReductionLabel = foliageReductionLabel
        self.summaryLine = summaryLine
        self.attentionHighlights = attentionHighlights
        self.sections = sections
        self.principleNote = principleNote
        self.sourcesNote = sourcesNote
    }
}

enum SpeciesProfileCatalog {
    static var all: [SpeciesProfile] {
        [
            AbiesAlbaSpeciesProfile.profile,
            AbiesBalsameaSpeciesProfile.profile,
            AbiesBorisiiRegisSpeciesProfile.profile,
            AbiesConcolorSpeciesProfile.profile,
            AbiesFirmaSpeciesProfile.profile,
            AbiesGrandisSpeciesProfile.profile,
            AbiesKoreanaSpeciesProfile.profile,
            AbiesLasiocarpaSpeciesProfile.profile,
            AbiesNordmannianaSpeciesProfile.profile,
            AbiesPinsapoSpeciesProfile.profile,
            AbiesSachalinensisSpeciesProfile.profile,
            AbiesVeitchiiSpeciesProfile.profile,
            AcerBuergerianumSpeciesProfile.profile,
            AcerCampestreSpeciesProfile.profile,
            AcerGinnalaSpeciesProfile.profile,
            AcerJaponicumSpeciesProfile.profile,
            AcerPalmatumSpeciesProfile.profile,
            AlnusGlutinosaSpeciesProfile.profile,
            AlnusIncanaSpeciesProfile.profile,
            BetulaPendulaSpeciesProfile.profile,
            BetulaPubescensSpeciesProfile.profile,
            BuxusSempervirensSpeciesProfile.profile,
            CarpinusBetulusSpeciesProfile.profile,
            CarpinusCoreanaSpeciesProfile.profile,
            ChaenomelesJaponicaSpeciesProfile.profile,
            ChamaecyparisLawsonianaSpeciesProfile.profile,
            ChamaecyparisNootkatensisSpeciesProfile.profile,
            ChamaecyparisObtusaSpeciesProfile.profile,
            ChamaecyparisPisiferaSpeciesProfile.profile,
            CotoneasterHorizontalisSpeciesProfile.profile,
            CrataegusMonogynaSpeciesProfile.profile,
            CryptomeriaJaponicaSpeciesProfile.profile,
            CupressusArizonicaSpeciesProfile.profile,
            CupressusLeylandiiSpeciesProfile.profile,
            CupressusMacrocarpaSpeciesProfile.profile,
            CupressusSempervirensSpeciesProfile.profile,
            FagusSylvaticaSpeciesProfile.profile,
            ForsythiaIntermediaSpeciesProfile.profile,
            GinkgoBilobaSpeciesProfile.profile,
            JuniperusChinensisSpeciesProfile.profile,
            JuniperusChinensisBlaauwSpeciesProfile.profile,
            JuniperusChinensisItoigawaSpeciesProfile.profile,
            JuniperusChinensisKishuSpeciesProfile.profile,
            JuniperusChinensisShimpakuSpeciesProfile.profile,
            JuniperusChinensisStrictaSpeciesProfile.profile,
            JuniperusCommunisSpeciesProfile.profile,
            JuniperusProcumbensSpeciesProfile.profile,
            JuniperusProcumbensGreenMoundSpeciesProfile.profile,
            JuniperusRigidaSpeciesProfile.profile,
            JuniperusSabinaSpeciesProfile.profile,
            JuniperusSquamataSpeciesProfile.profile,
            JuniperusSquamataBlueStarSpeciesProfile.profile,
            LarixDeciduaSpeciesProfile.profile,
            LarixKaempferiSpeciesProfile.profile,
            LarixMarschlinsiiSpeciesProfile.profile,
            MalusSylvestrisSpeciesProfile.profile,
            OleaEuropaeaSpeciesProfile.profile,
            OleaEuropaeaVarSylvestrisSpeciesProfile.profile,
            PhillyreaAngustifoliaSpeciesProfile.profile,
            PiceaAbiesSpeciesProfile.profile,
            PiceaEngelmanniiSpeciesProfile.profile,
            PiceaGlaucaSpeciesProfile.profile,
            PiceaMarianaSpeciesProfile.profile,
            PiceaOmorikaSpeciesProfile.profile,
            PiceaPungensSpeciesProfile.profile,
            PiceaSitchensisSpeciesProfile.profile,
            PinusMugoSpeciesProfile.profile,
            PinusParvifloraSpeciesProfile.profile,
            PinusSylvestrisSpeciesProfile.profile,
            PinusThunbergiiSpeciesProfile.profile,
            PistaciaLentiscusSpeciesProfile.profile,
            PodocarpusMacrophyllusSpeciesProfile.profile,
            PyracanthaCoccineaSpeciesProfile.profile,
            QuercusIlexSpeciesProfile.profile,
            QuercusRoburSpeciesProfile.profile,
            QuercusSuberSpeciesProfile.profile,
            RhododendronIndicumSpeciesProfile.profile,
            TaxusBaccataSpeciesProfile.profile,
            TaxusCanadensisSpeciesProfile.profile,
            TaxusCuspidataSpeciesProfile.profile,
            TaxusFloridanaSpeciesProfile.profile,
            TaxusMediaSpeciesProfile.profile,
            TaxusWallichianaSpeciesProfile.profile,
            TiliaCordataSpeciesProfile.profile,
            UlmusMinorSpeciesProfile.profile,
            UlmusParvifoliaSpeciesProfile.profile,
            WisteriaFloribundaSpeciesProfile.profile,
            BerberisThunbergiiSpeciesProfile.profile,
            BerberisVulgarisSpeciesProfile.profile,
            CedrusAtlanticaSpeciesProfile.profile,
            CedrusDeodaraSpeciesProfile.profile,
            CedrusLibaniSpeciesProfile.profile,
            CorylusAvellanaSpeciesProfile.profile,
            FicusCaricaSpeciesProfile.profile,
            FicusMicrocarpaSpeciesProfile.profile,
            FraxinusExcelsiorSpeciesProfile.profile,
            IlexAquifoliumSpeciesProfile.profile,
            IlexCrenataSpeciesProfile.profile,
            LigustrumOvalifoliumSpeciesProfile.profile,
            LigustrumVulgareSpeciesProfile.profile,
            MetasequoiaGlyptostroboidesSpeciesProfile.profile,
            PopulusTremulaSpeciesProfile.profile,
            PrunusAviumSpeciesProfile.profile,
            PrunusMumeSpeciesProfile.profile,
            PrunusPadusSpeciesProfile.profile,
            PrunusSpinosaSpeciesProfile.profile,
            PunicaGranatumSpeciesProfile.profile,
            PyrusCommunisSpeciesProfile.profile,
            SalixAlbaSpeciesProfile.profile,
            SalixBabylonicaSpeciesProfile.profile,
            SalixCapreaSpeciesProfile.profile,
            SambucusNigraSpeciesProfile.profile,
            SequoiaSempervirensSpeciesProfile.profile,
            SerissaJaponicaSpeciesProfile.profile,
            SorbusAucupariaSpeciesProfile.profile,
            StewartiaMonadelphaSpeciesProfile.profile,
            StewartiaPseudocamelliaSpeciesProfile.profile,
            ThujaOccidentalisSpeciesProfile.profile,
            ThujaPlicataSpeciesProfile.profile,
            ViburnumOpulusSpeciesProfile.profile,
            FicusBenjaminaSpeciesProfile.profile,
            FicusReligiosaSpeciesProfile.profile,
            FicusRubiginosaSpeciesProfile.profile,
            SageretiaTheaSpeciesProfile.profile,
            EhretiaMicrophyllaSpeciesProfile.profile,
            ScheffleraArboricolaSpeciesProfile.profile,
            BougainvilleaGlabraSpeciesProfile.profile,
            PortulacariaAfraSpeciesProfile.profile,
            AdeniumObesumSpeciesProfile.profile,
            LagerstroemiaIndicaSpeciesProfile.profile,
            MyrtusCommunisSpeciesProfile.profile,
            CitrusLimonSpeciesProfile.profile,
            MurrayaPaniculataSpeciesProfile.profile,
            TamarindusIndicaSpeciesProfile.profile,
            MalpighiaCoccigeraSpeciesProfile.profile,
            ConocarpusErectusSpeciesProfile.profile,
            BucidaSpinosaSpeciesProfile.profile,
            CrassulaOvataSpeciesProfile.profile,
            PremnaMicrophyllaSpeciesProfile.profile,
            TriphasiaTrifoliaSpeciesProfile.profile,
            SyzygiumPaniculatumSpeciesProfile.profile,
            PsidiumGuajavaSpeciesProfile.profile,
            JacarandaMimosifoliaSpeciesProfile.profile,
            MetrosiderosExcelsaSpeciesProfile.profile,
            LeptospermumScopariumSpeciesProfile.profile,
            CallistemonCitrinusSpeciesProfile.profile,
            MelaleucaQuinquenerviaSpeciesProfile.profile,
            BanksiaIntegrifoliaSpeciesProfile.profile,
            GrevilleaRobustaSpeciesProfile.profile,
            AraucariaAraucanaSpeciesProfile.profile,
            NothofagusAntarcticaSpeciesProfile.profile,
            EugeniaUnifloraSpeciesProfile.profile,
            PhyllanthusMyrtifoliusSpeciesProfile.profile,
            BurseraSimarubaSpeciesProfile.profile,
            DelonixRegiaSpeciesProfile.profile,
            SennaSurattensisSpeciesProfile.profile,
            TipuanaTipuSpeciesProfile.profile,
            CasuarinaEquisetifoliaSpeciesProfile.profile,
            EucalyptusGunniiSpeciesProfile.profile,
            AcaciaBaileyanaSpeciesProfile.profile,
            SyzygiumAustraleSpeciesProfile.profile,
            ZelkovaSerrataSpeciesProfile.profile,
        ]
        .sorted {
            $0.scientificName.localizedCaseInsensitiveCompare($1.scientificName) == .orderedAscending
        }
    }

    static func profile(id: UUID) -> SpeciesProfile? {
        all.first { $0.id == id }
    }

    /// Prefers cultivar-specific profiles, then species-level (no cultivar).
    static func profile(speciesID: UUID, cultivarID: UUID? = nil) -> SpeciesProfile? {
        if let cultivarID, let exact = all.first(where: { $0.cultivarID == cultivarID }) {
            return exact
        }
        if let speciesLevel = all.first(where: { $0.speciesID == speciesID && $0.cultivarID == nil }) {
            return speciesLevel
        }
        return all.first { $0.speciesID == speciesID }
    }

    /// Search/debug helper only. Tree Detail and Nursery resolve profiles by
    /// ``speciesID`` / ``cultivarID`` (``BotanicalKnowledgeIDs``) — never by this.
    static func profile(scientificName: String) -> SpeciesProfile? {
        all.first { profile in
            profile.scientificName.caseInsensitiveCompare(scientificName) == .orderedSame
                || profile.synonyms.contains { $0.caseInsensitiveCompare(scientificName) == .orderedSame }
        }
    }

    static func matching(search: String) -> [SpeciesProfile] {
        let needle = search.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return all }
        return all.filter { $0.searchText.localizedCaseInsensitiveContains(needle) }
    }
}
