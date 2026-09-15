//
//  SpeciesLibraryCategory.swift
//  Bonsai World
//
//  Species Library list grouping — browse categories for published profiles.
//

import Foundation

/// Browse categories for Knowledge → Species Library (UI sections in one list).
enum SpeciesLibraryCategory: Int, CaseIterable, Identifiable, Hashable, Sendable {
    case conifers
    case floweringDeciduous
    case nonFloweringDeciduous
    case fruitBearingDeciduous
    case floweringEvergreen
    case nonFloweringEvergreen
    case fruitBearingEvergreen

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .conifers: "Conifers"
        case .floweringDeciduous: "Flowering Deciduous Bonsai"
        case .nonFloweringDeciduous: "Non-flowering Deciduous Trees"
        case .fruitBearingDeciduous: "Fruit-bearing Deciduous Bonsai"
        case .floweringEvergreen: "Flowering Evergreen Bonsai"
        case .nonFloweringEvergreen: "Non-flowering Evergreen Bonsai"
        case .fruitBearingEvergreen: "Fruit-bearing Evergreen Bonsai"
        }
    }

    /// Stable category for a published Species Library profile.
    static func category(for profile: SpeciesProfile) -> SpeciesLibraryCategory {
        if let cultivarID = profile.cultivarID {
            switch cultivarID {
            case BotanicalKnowledgeIDs.juniperusChinensisBlaauw,
                 BotanicalKnowledgeIDs.juniperusChinensisItoigawa,
                 BotanicalKnowledgeIDs.juniperusChinensisKishu,
                 BotanicalKnowledgeIDs.juniperusChinensisShimpaku,
                 BotanicalKnowledgeIDs.juniperusChinensisStricta,
                 BotanicalKnowledgeIDs.juniperusProcumbensGreenMound,
                 BotanicalKnowledgeIDs.juniperusSquamataBlueStar:
                return .conifers
            default:
                break
            }
        }

        switch profile.speciesID {
        case BotanicalKnowledgeIDs.abiesAlba,
             BotanicalKnowledgeIDs.abiesBalsamea,
             BotanicalKnowledgeIDs.abiesBorisiiRegis,
             BotanicalKnowledgeIDs.abiesConcolor,
             BotanicalKnowledgeIDs.abiesFirma,
             BotanicalKnowledgeIDs.abiesGrandis,
             BotanicalKnowledgeIDs.abiesKoreana,
             BotanicalKnowledgeIDs.abiesLasiocarpa,
             BotanicalKnowledgeIDs.abiesNordmanniana,
             BotanicalKnowledgeIDs.abiesPinsapo,
             BotanicalKnowledgeIDs.abiesSachalinensis,
             BotanicalKnowledgeIDs.abiesVeitchii,
             BotanicalKnowledgeIDs.pinusMugo,
             BotanicalKnowledgeIDs.pinusParviflora,
             BotanicalKnowledgeIDs.pinusSylvestris,
             BotanicalKnowledgeIDs.pinusThunbergii,
             BotanicalKnowledgeIDs.juniperusChinensis,
             BotanicalKnowledgeIDs.juniperusCommunis,
             BotanicalKnowledgeIDs.juniperusProcumbens,
             BotanicalKnowledgeIDs.juniperusRigida,
             BotanicalKnowledgeIDs.juniperusSabina,
             BotanicalKnowledgeIDs.juniperusSquamata,
             BotanicalKnowledgeIDs.piceaAbies,
             BotanicalKnowledgeIDs.piceaEngelmannii,
             BotanicalKnowledgeIDs.piceaGlauca,
             BotanicalKnowledgeIDs.piceaMariana,
             BotanicalKnowledgeIDs.piceaOmorika,
             BotanicalKnowledgeIDs.piceaPungens,
             BotanicalKnowledgeIDs.piceaSitchensis,
             BotanicalKnowledgeIDs.chamaecyparisLawsoniana,
             BotanicalKnowledgeIDs.chamaecyparisNootkatensis,
             BotanicalKnowledgeIDs.chamaecyparisObtusa,
             BotanicalKnowledgeIDs.chamaecyparisPisifera,
             BotanicalKnowledgeIDs.cryptomeriaJaponica,
             BotanicalKnowledgeIDs.cupressusArizonica,
             BotanicalKnowledgeIDs.cupressusLeylandii,
             BotanicalKnowledgeIDs.cupressusMacrocarpa,
             BotanicalKnowledgeIDs.cupressusSempervirens,
             BotanicalKnowledgeIDs.cedrusAtlantica,
             BotanicalKnowledgeIDs.cedrusDeodara,
             BotanicalKnowledgeIDs.cedrusLibani,
             BotanicalKnowledgeIDs.metasequoiaGlyptostroboides,
             BotanicalKnowledgeIDs.sequoiaSempervirens,
             BotanicalKnowledgeIDs.thujaOccidentalis,
             BotanicalKnowledgeIDs.thujaPlicata,
             BotanicalKnowledgeIDs.taxusBaccata,
             BotanicalKnowledgeIDs.taxusCanadensis,
             BotanicalKnowledgeIDs.taxusCuspidata,
             BotanicalKnowledgeIDs.taxusFloridana,
             BotanicalKnowledgeIDs.taxusMedia,
             BotanicalKnowledgeIDs.taxusWallichiana,
             BotanicalKnowledgeIDs.larixDecidua,
             BotanicalKnowledgeIDs.larixKaempferi,
             BotanicalKnowledgeIDs.larixMarschlinsii,
             BotanicalKnowledgeIDs.araucariaAraucana:
            return .conifers

        case BotanicalKnowledgeIDs.forsythiaIntermedia,
             BotanicalKnowledgeIDs.wisteriaFloribunda,
             BotanicalKnowledgeIDs.chaenomelesJaponica,
             BotanicalKnowledgeIDs.prunusAvium,
             BotanicalKnowledgeIDs.prunusMume,
             BotanicalKnowledgeIDs.prunusPadus,
             BotanicalKnowledgeIDs.prunusSpinosa,
             BotanicalKnowledgeIDs.stewartiaMonadelpha,
             BotanicalKnowledgeIDs.stewartiaPseudocamellia,
             BotanicalKnowledgeIDs.viburnumOpulus,
             BotanicalKnowledgeIDs.lagerstroemiaIndica,
             BotanicalKnowledgeIDs.jacarandaMimosifolia,
             BotanicalKnowledgeIDs.delonixRegia,
             BotanicalKnowledgeIDs.tipuanaTipu:
            return .floweringDeciduous

        case BotanicalKnowledgeIDs.acerPalmatum,
             BotanicalKnowledgeIDs.acerJaponicum,
             BotanicalKnowledgeIDs.acerBuergerianum,
             BotanicalKnowledgeIDs.acerCampestre,
             BotanicalKnowledgeIDs.acerGinnala,
             BotanicalKnowledgeIDs.fagusSylvatica,
             BotanicalKnowledgeIDs.carpinusBetulus,
             BotanicalKnowledgeIDs.carpinusCoreana,
             BotanicalKnowledgeIDs.zelkovaSerrata,
             BotanicalKnowledgeIDs.ulmusMinor,
             BotanicalKnowledgeIDs.ulmusParvifolia,
             BotanicalKnowledgeIDs.alnusGlutinosa,
             BotanicalKnowledgeIDs.alnusIncana,
             BotanicalKnowledgeIDs.betulaPendula,
             BotanicalKnowledgeIDs.betulaPubescens,
             BotanicalKnowledgeIDs.quercusRobur,
             BotanicalKnowledgeIDs.tiliaCordata,
             BotanicalKnowledgeIDs.ginkgoBiloba,
             BotanicalKnowledgeIDs.corylusAvellana,
             BotanicalKnowledgeIDs.fraxinusExcelsior,
             BotanicalKnowledgeIDs.populusTremula,
             BotanicalKnowledgeIDs.salixAlba,
             BotanicalKnowledgeIDs.salixBabylonica,
             BotanicalKnowledgeIDs.salixCaprea,
             BotanicalKnowledgeIDs.premnaMicrophylla,
             BotanicalKnowledgeIDs.burseraSimaruba,
             BotanicalKnowledgeIDs.nothofagusAntarctica:
            return .nonFloweringDeciduous

        case BotanicalKnowledgeIDs.malusSylvestris,
             BotanicalKnowledgeIDs.crataegusMonogyna,
             BotanicalKnowledgeIDs.cotoneasterHorizontalis,
             BotanicalKnowledgeIDs.berberisThunbergii,
             BotanicalKnowledgeIDs.berberisVulgaris,
             BotanicalKnowledgeIDs.ficusCarica,
             BotanicalKnowledgeIDs.punicaGranatum,
             BotanicalKnowledgeIDs.pyrusCommunis,
             BotanicalKnowledgeIDs.sambucusNigra,
             BotanicalKnowledgeIDs.sorbusAucuparia:
            return .fruitBearingDeciduous

        case BotanicalKnowledgeIDs.rhododendronIndicum,
             BotanicalKnowledgeIDs.ligustrumOvalifolium,
             BotanicalKnowledgeIDs.ligustrumVulgare,
             BotanicalKnowledgeIDs.serissaJaponica,
             BotanicalKnowledgeIDs.ehretiaMicrophylla,
             BotanicalKnowledgeIDs.bougainvilleaGlabra,
             BotanicalKnowledgeIDs.adeniumObesum,
             BotanicalKnowledgeIDs.myrtusCommunis,
             BotanicalKnowledgeIDs.murrayaPaniculata,
             BotanicalKnowledgeIDs.metrosiderosExcelsa,
             BotanicalKnowledgeIDs.leptospermumScoparium,
             BotanicalKnowledgeIDs.callistemonCitrinus,
             BotanicalKnowledgeIDs.melaleucaQuinquenervia,
             BotanicalKnowledgeIDs.banksiaIntegrifolia,
             BotanicalKnowledgeIDs.grevilleaRobusta,
             BotanicalKnowledgeIDs.sennaSurattensis,
             BotanicalKnowledgeIDs.eucalyptusGunnii,
             BotanicalKnowledgeIDs.acaciaBaileyana:
            return .floweringEvergreen

        case BotanicalKnowledgeIDs.buxusSempervirens,
             BotanicalKnowledgeIDs.phillyreaAngustifolia,
             BotanicalKnowledgeIDs.pistaciaLentiscus,
             BotanicalKnowledgeIDs.quercusIlex,
             BotanicalKnowledgeIDs.quercusSuber,
             BotanicalKnowledgeIDs.podocarpusMacrophyllus,
             BotanicalKnowledgeIDs.ficusMicrocarpa,
             BotanicalKnowledgeIDs.ilexCrenata,
             BotanicalKnowledgeIDs.ficusBenjamina,
             BotanicalKnowledgeIDs.ficusReligiosa,
             BotanicalKnowledgeIDs.ficusRubiginosa,
             BotanicalKnowledgeIDs.scheffleraArboricola,
             BotanicalKnowledgeIDs.portulacariaAfra,
             BotanicalKnowledgeIDs.conocarpusErectus,
             BotanicalKnowledgeIDs.bucidaSpinosa,
             BotanicalKnowledgeIDs.crassulaOvata,
             BotanicalKnowledgeIDs.phyllanthusMyrtifolius,
             BotanicalKnowledgeIDs.casuarinaEquisetifolia:
            return .nonFloweringEvergreen

        case BotanicalKnowledgeIDs.oleaEuropaea,
             BotanicalKnowledgeIDs.oleaEuropaeaVarSylvestris,
             BotanicalKnowledgeIDs.pyracanthaCoccinea,
             BotanicalKnowledgeIDs.ilexAquifolium,
             BotanicalKnowledgeIDs.sageretiaThea,
             BotanicalKnowledgeIDs.citrusLimon,
             BotanicalKnowledgeIDs.tamarindusIndica,
             BotanicalKnowledgeIDs.malpighiaCoccigera,
             BotanicalKnowledgeIDs.triphasiaTrifolia,
             BotanicalKnowledgeIDs.syzygiumPaniculatum,
             BotanicalKnowledgeIDs.psidiumGuajava,
             BotanicalKnowledgeIDs.eugeniaUniflora,
             BotanicalKnowledgeIDs.syzygiumAustrale:
            return .fruitBearingEvergreen

        default:
            // New profiles must be assigned explicitly above.
            preconditionFailure("Missing Species Library category for \(profile.scientificName)")
        }
    }
}

extension SpeciesProfile {
    var libraryCategory: SpeciesLibraryCategory {
        SpeciesLibraryCategory.category(for: self)
    }
}

extension SpeciesProfileCatalog {
    /// Profiles grouped by Species Library browse category (empty categories omitted).
    /// Within each category, profiles stay alphabetical by scientific name.
    static func groupedMatching(search: String) -> [(category: SpeciesLibraryCategory, profiles: [SpeciesProfile])] {
        let filtered = matching(search: search)
        return SpeciesLibraryCategory.allCases.compactMap { category in
            let profiles = filtered.filter { $0.libraryCategory == category }
            guard !profiles.isEmpty else { return nil }
            return (category, profiles)
        }
    }
}
