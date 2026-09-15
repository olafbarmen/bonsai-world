//
//  BotanicalKnowledgeLinkTests.swift
//  Bonsai HubTests
//
//  Frozen Knowledge IDs must stay aligned with Botanical Library PreviewData seeds.
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct BotanicalKnowledgeLinkTests {

    @Test func frozenSpeciesIDsMatchPreviewDataSeeds() {
        let pairs: [(UUID, String)] = [
            (BotanicalKnowledgeIDs.abiesAlba, "Abies alba"),
            (BotanicalKnowledgeIDs.abiesBalsamea, "Abies balsamea"),
            (BotanicalKnowledgeIDs.abiesBorisiiRegis, "Abies × borisii-regis"),
            (BotanicalKnowledgeIDs.abiesConcolor, "Abies concolor"),
            (BotanicalKnowledgeIDs.abiesFirma, "Abies firma"),
            (BotanicalKnowledgeIDs.abiesGrandis, "Abies grandis"),
            (BotanicalKnowledgeIDs.abiesKoreana, "Abies koreana"),
            (BotanicalKnowledgeIDs.abiesLasiocarpa, "Abies lasiocarpa"),
            (BotanicalKnowledgeIDs.abiesNordmanniana, "Abies nordmanniana"),
            (BotanicalKnowledgeIDs.abiesPinsapo, "Abies pinsapo"),
            (BotanicalKnowledgeIDs.abiesSachalinensis, "Abies sachalinensis"),
            (BotanicalKnowledgeIDs.abiesVeitchii, "Abies veitchii"),
            (BotanicalKnowledgeIDs.acerBuergerianum, "Acer buergerianum"),
            (BotanicalKnowledgeIDs.acerCampestre, "Acer campestre"),
            (BotanicalKnowledgeIDs.acerGinnala, "Acer ginnala"),
            (BotanicalKnowledgeIDs.acerJaponicum, "Acer japonicum"),
            (BotanicalKnowledgeIDs.acerPalmatum, "Acer palmatum"),
            (BotanicalKnowledgeIDs.alnusGlutinosa, "Alnus glutinosa"),
            (BotanicalKnowledgeIDs.alnusIncana, "Alnus incana"),
            (BotanicalKnowledgeIDs.betulaPendula, "Betula pendula"),
            (BotanicalKnowledgeIDs.betulaPubescens, "Betula pubescens"),
            (BotanicalKnowledgeIDs.buxusSempervirens, "Buxus sempervirens"),
            (BotanicalKnowledgeIDs.carpinusBetulus, "Carpinus betulus"),
            (BotanicalKnowledgeIDs.carpinusCoreana, "Carpinus coreana"),
            (BotanicalKnowledgeIDs.chaenomelesJaponica, "Chaenomeles japonica"),
            (BotanicalKnowledgeIDs.chamaecyparisLawsoniana, "Chamaecyparis lawsoniana"),
            (BotanicalKnowledgeIDs.chamaecyparisNootkatensis, "Chamaecyparis nootkatensis"),
            (BotanicalKnowledgeIDs.chamaecyparisObtusa, "Chamaecyparis obtusa (Hinoki)"),
            (BotanicalKnowledgeIDs.chamaecyparisPisifera, "Chamaecyparis pisifera"),
            (BotanicalKnowledgeIDs.cotoneasterHorizontalis, "Cotoneaster horizontalis"),
            (BotanicalKnowledgeIDs.crataegusMonogyna, "Crataegus monogyna"),
            (BotanicalKnowledgeIDs.cryptomeriaJaponica, "Cryptomeria japonica"),
            (BotanicalKnowledgeIDs.cupressusArizonica, "Cupressus arizonica"),
            (BotanicalKnowledgeIDs.cupressusMacrocarpa, "Cupressus macrocarpa"),
            (BotanicalKnowledgeIDs.cupressusSempervirens, "Cupressus sempervirens"),
            (BotanicalKnowledgeIDs.cupressusLeylandii, "Cupressus x Leylandii"),
            (BotanicalKnowledgeIDs.adeniumObesum, "Adenium obesum"),
            (BotanicalKnowledgeIDs.bougainvilleaGlabra, "Bougainvillea glabra"),
            (BotanicalKnowledgeIDs.bucidaSpinosa, "Bucida spinosa"),
            (BotanicalKnowledgeIDs.citrusLimon, "Citrus limon"),
            (BotanicalKnowledgeIDs.conocarpusErectus, "Conocarpus erectus"),
            (BotanicalKnowledgeIDs.crassulaOvata, "Crassula ovata"),
            (BotanicalKnowledgeIDs.ehretiaMicrophylla, "Ehretia microphylla"),
            (BotanicalKnowledgeIDs.ficusBenjamina, "Ficus benjamina"),
            (BotanicalKnowledgeIDs.ficusReligiosa, "Ficus religiosa"),
            (BotanicalKnowledgeIDs.ficusRubiginosa, "Ficus rubiginosa"),
            (BotanicalKnowledgeIDs.jacarandaMimosifolia, "Jacaranda mimosifolia"),
            (BotanicalKnowledgeIDs.lagerstroemiaIndica, "Lagerstroemia indica"),
            (BotanicalKnowledgeIDs.malpighiaCoccigera, "Malpighia coccigera"),
            (BotanicalKnowledgeIDs.murrayaPaniculata, "Murraya paniculata"),
            (BotanicalKnowledgeIDs.myrtusCommunis, "Myrtus communis"),
            (BotanicalKnowledgeIDs.portulacariaAfra, "Portulacaria afra"),
            (BotanicalKnowledgeIDs.premnaMicrophylla, "Premna microphylla"),
            (BotanicalKnowledgeIDs.psidiumGuajava, "Psidium guajava"),
            (BotanicalKnowledgeIDs.sageretiaThea, "Sageretia thea"),
            (BotanicalKnowledgeIDs.scheffleraArboricola, "Schefflera arboricola"),
            (BotanicalKnowledgeIDs.syzygiumPaniculatum, "Syzygium paniculatum"),
            (BotanicalKnowledgeIDs.tamarindusIndica, "Tamarindus indica"),
            (BotanicalKnowledgeIDs.triphasiaTrifolia, "Triphasia trifolia"),
            (BotanicalKnowledgeIDs.acaciaBaileyana, "Acacia baileyana"),
            (BotanicalKnowledgeIDs.araucariaAraucana, "Araucaria araucana"),
            (BotanicalKnowledgeIDs.banksiaIntegrifolia, "Banksia integrifolia"),
            (BotanicalKnowledgeIDs.burseraSimaruba, "Bursera simaruba"),
            (BotanicalKnowledgeIDs.callistemonCitrinus, "Callistemon citrinus"),
            (BotanicalKnowledgeIDs.casuarinaEquisetifolia, "Casuarina equisetifolia"),
            (BotanicalKnowledgeIDs.delonixRegia, "Delonix regia"),
            (BotanicalKnowledgeIDs.eucalyptusGunnii, "Eucalyptus gunnii"),
            (BotanicalKnowledgeIDs.eugeniaUniflora, "Eugenia uniflora"),
            (BotanicalKnowledgeIDs.grevilleaRobusta, "Grevillea robusta"),
            (BotanicalKnowledgeIDs.leptospermumScoparium, "Leptospermum scoparium"),
            (BotanicalKnowledgeIDs.melaleucaQuinquenervia, "Melaleuca quinquenervia"),
            (BotanicalKnowledgeIDs.metrosiderosExcelsa, "Metrosideros excelsa"),
            (BotanicalKnowledgeIDs.nothofagusAntarctica, "Nothofagus antarctica"),
            (BotanicalKnowledgeIDs.phyllanthusMyrtifolius, "Phyllanthus myrtifolius"),
            (BotanicalKnowledgeIDs.sennaSurattensis, "Senna surattensis"),
            (BotanicalKnowledgeIDs.syzygiumAustrale, "Syzygium australe"),
            (BotanicalKnowledgeIDs.tipuanaTipu, "Tipuana tipu"),
            (BotanicalKnowledgeIDs.berberisThunbergii, "Berberis thunbergii"),
            (BotanicalKnowledgeIDs.berberisVulgaris, "Berberis vulgaris"),
            (BotanicalKnowledgeIDs.cedrusAtlantica, "Cedrus atlantica"),
            (BotanicalKnowledgeIDs.cedrusDeodara, "Cedrus deodara"),
            (BotanicalKnowledgeIDs.cedrusLibani, "Cedrus libani"),
            (BotanicalKnowledgeIDs.corylusAvellana, "Corylus avellana"),
            (BotanicalKnowledgeIDs.ficusCarica, "Ficus carica"),
            (BotanicalKnowledgeIDs.ficusMicrocarpa, "Ficus microcarpa"),
            (BotanicalKnowledgeIDs.fraxinusExcelsior, "Fraxinus excelsior"),
            (BotanicalKnowledgeIDs.ilexAquifolium, "Ilex aquifolium"),
            (BotanicalKnowledgeIDs.ilexCrenata, "Ilex crenata"),
            (BotanicalKnowledgeIDs.ligustrumOvalifolium, "Ligustrum ovalifolium"),
            (BotanicalKnowledgeIDs.ligustrumVulgare, "Ligustrum vulgare"),
            (BotanicalKnowledgeIDs.metasequoiaGlyptostroboides, "Metasequoia glyptostroboides"),
            (BotanicalKnowledgeIDs.populusTremula, "Populus tremula"),
            (BotanicalKnowledgeIDs.prunusAvium, "Prunus avium"),
            (BotanicalKnowledgeIDs.prunusMume, "Prunus mume"),
            (BotanicalKnowledgeIDs.prunusPadus, "Prunus padus"),
            (BotanicalKnowledgeIDs.prunusSpinosa, "Prunus spinosa"),
            (BotanicalKnowledgeIDs.punicaGranatum, "Punica granatum"),
            (BotanicalKnowledgeIDs.pyrusCommunis, "Pyrus communis"),
            (BotanicalKnowledgeIDs.salixAlba, "Salix alba"),
            (BotanicalKnowledgeIDs.salixBabylonica, "Salix babylonica"),
            (BotanicalKnowledgeIDs.salixCaprea, "Salix caprea"),
            (BotanicalKnowledgeIDs.sambucusNigra, "Sambucus nigra"),
            (BotanicalKnowledgeIDs.sequoiaSempervirens, "Sequoia sempervirens"),
            (BotanicalKnowledgeIDs.serissaJaponica, "Serissa japonica"),
            (BotanicalKnowledgeIDs.sorbusAucuparia, "Sorbus aucuparia"),
            (BotanicalKnowledgeIDs.stewartiaMonadelpha, "Stewartia monadelpha"),
            (BotanicalKnowledgeIDs.stewartiaPseudocamellia, "Stewartia pseudocamellia"),
            (BotanicalKnowledgeIDs.thujaOccidentalis, "Thuja occidentalis"),
            (BotanicalKnowledgeIDs.thujaPlicata, "Thuja plicata"),
            (BotanicalKnowledgeIDs.viburnumOpulus, "Viburnum opulus"),
            (BotanicalKnowledgeIDs.fagusSylvatica, "Fagus sylvatica"),
            (BotanicalKnowledgeIDs.forsythiaIntermedia, "Forsythia × intermedia"),
            (BotanicalKnowledgeIDs.ginkgoBiloba, "Ginkgo biloba"),
            (BotanicalKnowledgeIDs.juniperusChinensis, "Juniperus chinensis"),
            (BotanicalKnowledgeIDs.juniperusCommunis, "Juniperus communis"),
            (BotanicalKnowledgeIDs.juniperusProcumbens, "Juniperus procumbens"),
            (BotanicalKnowledgeIDs.juniperusRigida, "Juniperus rigida"),
            (BotanicalKnowledgeIDs.juniperusSabina, "Juniperus sabina"),
            (BotanicalKnowledgeIDs.juniperusSquamata, "Juniperus squamata"),
            (BotanicalKnowledgeIDs.larixDecidua, "Larix decidua"),
            (BotanicalKnowledgeIDs.larixKaempferi, "Larix kaempferi"),
            (BotanicalKnowledgeIDs.larixMarschlinsii, "Larix × marschlinsii"),
            (BotanicalKnowledgeIDs.malusSylvestris, "Malus sylvestris"),
            (BotanicalKnowledgeIDs.oleaEuropaea, "Olea europaea"),
            (BotanicalKnowledgeIDs.oleaEuropaeaVarSylvestris, "Olea europaea var. sylvestris"),
            (BotanicalKnowledgeIDs.phillyreaAngustifolia, "Phillyrea angustifolia"),
            (BotanicalKnowledgeIDs.piceaAbies, "Picea abies"),
            (BotanicalKnowledgeIDs.piceaEngelmannii, "Picea engelmannii"),
            (BotanicalKnowledgeIDs.piceaGlauca, "Picea glauca"),
            (BotanicalKnowledgeIDs.piceaMariana, "Picea mariana"),
            (BotanicalKnowledgeIDs.piceaOmorika, "Picea omorika"),
            (BotanicalKnowledgeIDs.piceaPungens, "Picea pungens"),
            (BotanicalKnowledgeIDs.piceaSitchensis, "Picea sitchensis"),
            (BotanicalKnowledgeIDs.pinusMugo, "Pinus mugo"),
            (BotanicalKnowledgeIDs.pinusParviflora, "Pinus parviflora"),
            (BotanicalKnowledgeIDs.pinusSylvestris, "Pinus sylvestris"),
            (BotanicalKnowledgeIDs.pinusThunbergii, "Pinus thunbergii"),
            (BotanicalKnowledgeIDs.pistaciaLentiscus, "Pistacia lentiscus"),
            (BotanicalKnowledgeIDs.podocarpusMacrophyllus, "Podocarpus macrophyllus"),
            (BotanicalKnowledgeIDs.pyracanthaCoccinea, "Pyracantha coccinea"),
            (BotanicalKnowledgeIDs.quercusIlex, "Quercus ilex"),
            (BotanicalKnowledgeIDs.quercusRobur, "Quercus robur"),
            (BotanicalKnowledgeIDs.quercusSuber, "Quercus suber"),
            (BotanicalKnowledgeIDs.rhododendronIndicum, "Rhododendron indicum"),
            (BotanicalKnowledgeIDs.taxusBaccata, "Taxus baccata"),
            (BotanicalKnowledgeIDs.taxusCanadensis, "Taxus canadensis"),
            (BotanicalKnowledgeIDs.taxusCuspidata, "Taxus cuspidata"),
            (BotanicalKnowledgeIDs.taxusFloridana, "Taxus floridana"),
            (BotanicalKnowledgeIDs.taxusMedia, "Taxus x media"),
            (BotanicalKnowledgeIDs.taxusWallichiana, "Taxus wallichiana"),
            (BotanicalKnowledgeIDs.tiliaCordata, "Tilia cordata"),
            (BotanicalKnowledgeIDs.ulmusMinor, "Ulmus minor"),
            (BotanicalKnowledgeIDs.ulmusParvifolia, "Ulmus parvifolia"),
            (BotanicalKnowledgeIDs.wisteriaFloribunda, "Wisteria floribunda"),
            (BotanicalKnowledgeIDs.zelkovaSerrata, "Zelkova serrata"),
        ]
        for (frozen, name) in pairs {
            #expect(frozen == SpeciesPreviewData.id(named: name))
        }
    }

    @Test func frozenCultivarIDsMatchPreviewDataSeeds() {
        let pairs: [(UUID, String, String)] = [
            (BotanicalKnowledgeIDs.juniperusChinensisBlaauw, "Juniperus chinensis", "Blaauw"),
            (BotanicalKnowledgeIDs.juniperusChinensisItoigawa, "Juniperus chinensis", "Itoigawa"),
            (BotanicalKnowledgeIDs.juniperusChinensisKishu, "Juniperus chinensis", "Kishu"),
            (BotanicalKnowledgeIDs.juniperusChinensisShimpaku, "Juniperus chinensis", "Shimpaku"),
            (BotanicalKnowledgeIDs.juniperusChinensisStricta, "Juniperus chinensis", "Stricta"),
            (BotanicalKnowledgeIDs.juniperusProcumbensGreenMound, "Juniperus procumbens", "Green Mound"),
            (BotanicalKnowledgeIDs.juniperusSquamataBlueStar, "Juniperus squamata", "Blue Star"),
        ]
        for (frozen, species, cultivar) in pairs {
            #expect(frozen == CultivarPreviewData.id(speciesName: species, cultivarName: cultivar))
        }
    }

    @Test func everyKnowledgeProfileUsesFrozenIDsNotNameLookup() {
        for profile in SpeciesProfileCatalog.all {
            if let cultivarID = profile.cultivarID {
                #expect(CultivarPreviewData.all.contains { $0.id == cultivarID })
                #expect(SpeciesPreviewData.all.contains { $0.id == profile.speciesID })
            } else {
                #expect(SpeciesPreviewData.all.contains { $0.id == profile.speciesID })
            }
            // Catalog resolves the same way Tree Detail does.
            #expect(
                SpeciesProfileCatalog.profile(
                    speciesID: profile.speciesID,
                    cultivarID: profile.cultivarID
                )?.id == profile.id
            )
        }
    }

    @Test func everySpeciesProfileHasLibraryCategoryAndGroupingCoversAll() {
        for profile in SpeciesProfileCatalog.all {
            _ = profile.libraryCategory
        }
        #expect(PodocarpusMacrophyllusSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(BetulaPendulaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(BetulaPubescensSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(AlnusIncanaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(TiliaCordataSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(GinkgoBilobaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(GinkgoBilobaSpeciesProfile.profile.libraryCategory != .conifers)
        #expect(CryptomeriaJaponicaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ChamaecyparisLawsonianaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ChamaecyparisNootkatensisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ChamaecyparisPisiferaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CupressusArizonicaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CupressusMacrocarpaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CupressusSempervirensSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CupressusLeylandiiSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(TaxusCuspidataSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(TaxusMediaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(TaxusCanadensisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(TaxusWallichianaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(TaxusFloridanaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(FicusBenjaminaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(FicusReligiosaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(FicusRubiginosaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(SageretiaTheaSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(EhretiaMicrophyllaSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(ScheffleraArboricolaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(BougainvilleaGlabraSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(PortulacariaAfraSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(AdeniumObesumSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(LagerstroemiaIndicaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(MyrtusCommunisSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(CitrusLimonSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(MurrayaPaniculataSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(TamarindusIndicaSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(MalpighiaCoccigeraSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(ConocarpusErectusSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(BucidaSpinosaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(CrassulaOvataSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(PremnaMicrophyllaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(TriphasiaTrifoliaSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(SyzygiumPaniculatumSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(PsidiumGuajavaSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(JacarandaMimosifoliaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(BerberisThunbergiiSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(BerberisVulgarisSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(CedrusAtlanticaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CedrusDeodaraSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CedrusLibaniSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(CorylusAvellanaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(FicusCaricaSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(FicusMicrocarpaSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(FraxinusExcelsiorSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(IlexAquifoliumSpeciesProfile.profile.libraryCategory == .fruitBearingEvergreen)
        #expect(IlexCrenataSpeciesProfile.profile.libraryCategory == .nonFloweringEvergreen)
        #expect(LigustrumOvalifoliumSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(LigustrumVulgareSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(MetasequoiaGlyptostroboidesSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PopulusTremulaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(PrunusAviumSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(PrunusMumeSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(PrunusPadusSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(PrunusSpinosaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(PunicaGranatumSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(PyrusCommunisSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(SalixAlbaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(SalixBabylonicaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(SalixCapreaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(SambucusNigraSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(SequoiaSempervirensSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(SerissaJaponicaSpeciesProfile.profile.libraryCategory == .floweringEvergreen)
        #expect(SorbusAucupariaSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)
        #expect(StewartiaMonadelphaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(StewartiaPseudocamelliaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(ThujaOccidentalisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ThujaPlicataSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ViburnumOpulusSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(AbiesAlbaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesBalsameaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesBorisiiRegisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesConcolorSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesFirmaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesGrandisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesKoreanaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesLasiocarpaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesNordmannianaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesPinsapoSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesSachalinensisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AbiesVeitchiiSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaEngelmanniiSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaGlaucaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaMarianaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaOmorikaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaPungensSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(PiceaSitchensisSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(AcerGinnalaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(CarpinusCoreanaSpeciesProfile.profile.libraryCategory == .nonFloweringDeciduous)
        #expect(JuniperusRigidaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(JuniperusSabinaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(JuniperusProcumbensSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(JuniperusProcumbensSpeciesProfile.profile.cultivarID == nil)
        #expect(JuniperusProcumbensGreenMoundSpeciesProfile.profile.cultivarID == BotanicalKnowledgeIDs.juniperusProcumbensGreenMound)
        #expect(JuniperusSquamataSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(JuniperusSquamataSpeciesProfile.profile.cultivarID == nil)
        #expect(JuniperusSquamataBlueStarSpeciesProfile.profile.cultivarID == BotanicalKnowledgeIDs.juniperusSquamataBlueStar)
        #expect(LarixDeciduaSpeciesProfile.profile.libraryCategory == .conifers)
        #expect(ChaenomelesJaponicaSpeciesProfile.profile.libraryCategory == .floweringDeciduous)
        #expect(CotoneasterHorizontalisSpeciesProfile.profile.libraryCategory == .fruitBearingDeciduous)

        let grouped = SpeciesProfileCatalog.groupedMatching(search: "")
        #expect(grouped.map(\.category) == SpeciesLibraryCategory.allCases)
        #expect(grouped.reduce(0) { $0 + $1.profiles.count } == SpeciesProfileCatalog.all.count)
    }

    @Test func ulmusParvifoliaProfileIsCompleteChineseElmIdentity() {
        let profile = UlmusParvifoliaSpeciesProfile.profile
        #expect(profile.scientificName == "Ulmus parvifolia")
        #expect(profile.primaryCommonName == "Chinese Elm")
        #expect(profile.family == "Ulmaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous to semi-evergreen tree")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Zelkova serrata"))
        #expect(visible.localizedCaseInsensitiveContains("Ulmus minor"))
        #expect(visible.localizedCaseInsensitiveContains("not automatically be treated as either fully evergreen"))
    }

    @Test func fagusSylvaticaProfileIsCompleteEuropeanBeechIdentity() {
        let profile = FagusSylvaticaSpeciesProfile.profile
        #expect(profile.scientificName == "Fagus sylvatica")
        #expect(profile.primaryCommonName == "European Beech")
        #expect(profile.family == "Fagaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Fagus crenata"))
        #expect(visible.localizedCaseInsensitiveContains("smooth grey bark"))
        #expect(visible.localizedCaseInsensitiveContains("must never be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("not normally the defining feature"))
    }

    @Test func carpinusBetulusProfileIsCompleteEuropeanHornbeamIdentity() {
        let profile = CarpinusBetulusSpeciesProfile.profile
        #expect(profile.scientificName == "Carpinus betulus")
        #expect(profile.primaryCommonName == "European Hornbeam")
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.ramificationPotential == "Excellent")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Carpinus japonica"))
        #expect(visible.localizedCaseInsensitiveContains("Fagus sylvatica"))
        #expect(visible.localizedCaseInsensitiveContains("must never be presented as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("generally not a defining feature"))
    }

    @Test func carpinusCoreanaProfileIsCompleteKoreanHornbeamIdentity() {
        let profile = CarpinusCoreanaSpeciesProfile.profile
        #expect(profile.scientificName == "Carpinus coreana")
        #expect(profile.primaryCommonName == "Korean Hornbeam")
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Korea.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Intermediate to Advanced")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Deciduous · Small")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good")
        #expect(profile.traits.rootDevelopment == "Good")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Carpinus coreana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.carpinusBetulus)
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Carpinus betulus"))
        #expect(visible.localizedCaseInsensitiveContains("Japanese Hornbeam"))
        #expect(visible.localizedCaseInsensitiveContains("smaller version of Carpinus betulus"))
        #expect(visible.localizedCaseInsensitiveContains("shohin"))
        #expect(visible.localizedCaseInsensitiveContains("Trunk quality first"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that completely bare old branches"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Excellent ramification"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesAlbaProfileIsCompleteEuropeanSilverFirIdentity() {
        let profile = AbiesAlbaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies alba")
        #expect(profile.primaryCommonName == "European Silver Fir")
        #expect(profile.commonNames.contains("Silver Fir"))
        #expect(profile.commonNames.contains("Common Silver Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Central and southern Europe, particularly mountainous regions.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate to Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Excellent on mature material")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies alba"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("flat needles"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("mountain"))
        #expect(visible.localizedCaseInsensitiveContains("drought-tolerant juniper"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesBalsameaProfileIsCompleteBalsamFirIdentity() {
        let profile = AbiesBalsameaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies balsamea")
        #expect(profile.primaryCommonName == "Balsam Fir")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Northern North America, particularly Canada and the northeastern United States.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — dependent on retained healthy foliage and viable buds")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Low to Moderate as a species, but shallow bonsai roots still require protection from prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies balsamea"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("northern North America"))
        #expect(visible.localizedCaseInsensitiveContains("boreal"))
        #expect(visible.localizedCaseInsensitiveContains("flat"))
        #expect(visible.localizedCaseInsensitiveContains("Cold-hardy"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought-tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("shallow bonsai container"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("cold hardiness"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesBorisiiRegisProfileIsCompleteKingBorisFirIdentity() {
        let profile = AbiesBorisiiRegisSpeciesProfile.profile
        #expect(profile.scientificName == "Abies × borisii-regis")
        #expect(profile.scientificName.contains("×"))
        #expect(!profile.scientificName.contains("Abies x borisii-regis") || profile.scientificName.contains("×"))
        #expect(profile.primaryCommonName == "King Boris Fir")
        #expect(profile.commonNames.contains("Boris Fir"))
        #expect(profile.commonNames.contains("Bulgarian Fir"))
        #expect(profile.synonyms.contains("Abies borisii-regis"))
        #expect(profile.synonyms.contains("Abies x borisii-regis"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer · Natural hybrid taxon")
        #expect(profile.originSummary == "The southern Balkan Peninsula, particularly mountainous regions associated with Greece, Bulgaria and neighbouring areas.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies × borisii-regis"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.contains("Abies × borisii-regis"))
        #expect(visible.localizedCaseInsensitiveContains("Abies alba"))
        #expect(visible.localizedCaseInsensitiveContains("Abies cephalonica"))
        #expect(visible.localizedCaseInsensitiveContains("naturally occurring"))
        #expect(visible.localizedCaseInsensitiveContains("artificial horticultural hybrid"))
        #expect(visible.localizedCaseInsensitiveContains("Balkan"))
        #expect(visible.localizedCaseInsensitiveContains("multiplication sign"))
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(visible.localizedCaseInsensitiveContains("Individual trees may show variation"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesConcolorProfileIsCompleteWhiteFirIdentity() {
        let profile = AbiesConcolorSpeciesProfile.profile
        #expect(profile.scientificName == "Abies concolor")
        #expect(profile.primaryCommonName == "White Fir")
        #expect(profile.commonNames.contains("Concolor Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Western North America, primarily in mountainous regions of the western United States and northern Mexico.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Long, flat, soft needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies concolor"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("western North America"))
        #expect(visible.localizedCaseInsensitiveContains("long, flat"))
        #expect(visible.localizedCaseInsensitiveContains("soft"))
        #expect(visible.localizedCaseInsensitiveContains("blue-green"))
        #expect(visible.localizedCaseInsensitiveContains("silvery"))
        #expect(visible.localizedCaseInsensitiveContains("identical colour"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought-proof"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesFirmaProfileIsCompleteMomiFirIdentity() {
        let profile = AbiesFirmaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies firma")
        #expect(profile.primaryCommonName == "Momi Fir")
        #expect(profile.commonNames.contains("Japanese Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Japan, primarily in mountainous and forested regions.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies firma"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesKoreana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Japan"))
        #expect(visible.localizedCaseInsensitiveContains("Momi"))
        #expect(visible.localizedCaseInsensitiveContains("Japanese forest"))
        #expect(visible.localizedCaseInsensitiveContains("flat"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesGrandisProfileIsCompleteGrandFirIdentity() {
        let profile = AbiesGrandisSpeciesProfile.profile
        #expect(profile.scientificName == "Abies grandis")
        #expect(profile.primaryCommonName == "Grand Fir")
        #expect(profile.commonNames.contains("Giant Fir"))
        #expect(profile.commonNames.contains("Lowland White Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Western North America, particularly the Pacific Northwest and inland northwestern mountain and forest regions.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate to Fast when vigorous")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — dependent on retained healthy foliage and viable buds")
        #expect(profile.traits.rootDevelopment == "Moderate to Strong")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Moderate to Strong")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies grandis"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesConcolor)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Pacific Northwest"))
        #expect(visible.localizedCaseInsensitiveContains("western North America"))
        #expect(visible.localizedCaseInsensitiveContains("large forest tree"))
        #expect(visible.localizedCaseInsensitiveContains("scale"))
        #expect(visible.localizedCaseInsensitiveContains("Manage vigour"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought-tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("high water demand"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesKoreanaProfileIsCompleteKoreanFirIdentity() {
        let profile = AbiesKoreanaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies koreana")
        #expect(profile.primaryCommonName == "Korean Fir")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Mountainous regions of South Korea.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Short flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — dependent on retained healthy foliage and viable buds")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate to Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies koreana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("South Korea"))
        #expect(visible.localizedCaseInsensitiveContains("short"))
        #expect(visible.localizedCaseInsensitiveContains("flat needles"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought-tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(visible.localizedCaseInsensitiveContains("European fir"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesLasiocarpaProfileIsCompleteSubalpineFirIdentity() {
        let profile = AbiesLasiocarpaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies lasiocarpa")
        #expect(profile.primaryCommonName == "Subalpine Fir")
        #expect(profile.commonNames.contains("Rocky Mountain Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Western North America, primarily in high-elevation mountain and subalpine forests.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Low to Moderate, but shallow bonsai roots remain vulnerable during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies lasiocarpa"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesGrandis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("subalpine"))
        #expect(visible.localizedCaseInsensitiveContains("high-elevation"))
        #expect(visible.localizedCaseInsensitiveContains("western North America"))
        #expect(visible.localizedCaseInsensitiveContains("blue-green"))
        #expect(visible.localizedCaseInsensitiveContains("silvery"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("heat stress"))
        #expect(visible.localizedCaseInsensitiveContains("patience"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(visible.localizedCaseInsensitiveContains("Not every specimen"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesNordmannianaProfileIsCompleteNordmannFirIdentity() {
        let profile = AbiesNordmannianaSpeciesProfile.profile
        #expect(profile.scientificName == "Abies nordmanniana")
        #expect(profile.primaryCommonName == "Nordmann Fir")
        #expect(profile.commonNames.contains("Caucasian Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "The Caucasus Mountains and neighbouring regions around the eastern Black Sea.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where viable buds and healthy foliage are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies nordmanniana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesKoreana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Caucasus"))
        #expect(visible.localizedCaseInsensitiveContains("dark green"))
        #expect(visible.localizedCaseInsensitiveContains("flat"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought-tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesPinsapoProfileIsCompleteSpanishFirIdentity() {
        let profile = AbiesPinsapoSpeciesProfile.profile
        #expect(profile.scientificName == "Abies pinsapo")
        #expect(profile.primaryCommonName == "Spanish Fir")
        #expect(profile.commonNames.contains("Pinsapo Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Southern Spain, primarily in mountainous areas of Andalusia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow")
        #expect(profile.traits.growthSpeed == "Slow")
        #expect(profile.traits.leafSize == "Evergreen · Short, stiff needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies pinsapo"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesAlba)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesKoreana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesNordmanniana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Andalusia"))
        #expect(visible.localizedCaseInsensitiveContains("southern Spain"))
        #expect(visible.localizedCaseInsensitiveContains("short, stiff"))
        #expect(visible.localizedCaseInsensitiveContains("Mediterranean"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(visible.localizedCaseInsensitiveContains("shallow bonsai containers"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesSachalinensisProfileIsCompleteSakhalinFirIdentity() {
        let profile = AbiesSachalinensisSpeciesProfile.profile
        #expect(profile.scientificName == "Abies sachalinensis")
        #expect(profile.primaryCommonName == "Sakhalin Fir")
        #expect(profile.commonNames.contains("Sakhalin Silver Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Northeast Asia, primarily Sakhalin, the Kuril Islands and northern Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Low to Moderate, although shallow bonsai roots remain vulnerable during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies sachalinensis"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesFirma)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Northeast Asia"))
        #expect(visible.localizedCaseInsensitiveContains("Sakhalin"))
        #expect(visible.localizedCaseInsensitiveContains("Kuril"))
        #expect(visible.localizedCaseInsensitiveContains("northern Japan"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("heat stress"))
        #expect(visible.localizedCaseInsensitiveContains("patience"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func abiesVeitchiiProfileIsCompleteVeitchsFirIdentity() {
        let profile = AbiesVeitchiiSpeciesProfile.profile
        #expect(profile.scientificName == "Abies veitchii")
        #expect(profile.primaryCommonName == "Veitch's Fir")
        #expect(profile.commonNames.contains("Veitch Fir"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Japan, particularly the mountainous regions of central and northern Honshu.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Short, flat needles")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongest where healthy foliage and viable buds are retained")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Low to Moderate, although shallow bonsai roots remain vulnerable during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Abies veitchii"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesFirma)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.abiesSachalinensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea"))
        #expect(visible.localizedCaseInsensitiveContains("Honshu"))
        #expect(visible.localizedCaseInsensitiveContains("Japan"))
        #expect(visible.localizedCaseInsensitiveContains("short, flat"))
        #expect(visible.localizedCaseInsensitiveContains("dense foliage"))
        #expect(visible.localizedCaseInsensitiveContains("mountain"))
        #expect(visible.localizedCaseInsensitiveContains("upright cones"))
        #expect(visible.localizedCaseInsensitiveContains("heat"))
        #expect(visible.localizedCaseInsensitiveContains("patience"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("viable buds"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Mature branches can become rigid"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func piceaAbiesProfileIsCompleteNorwaySpruceIdentity() {
        let profile = PiceaAbiesSpeciesProfile.profile
        #expect(profile.scientificName == "Picea abies")
        #expect(profile.primaryCommonName == "Norway Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea glauca"))
        #expect(visible.localizedCaseInsensitiveContains("Picea pungens"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use routine broadleaf defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("natural character rather than decorative deadwood"))
    }

    @Test func piceaEngelmanniiProfileIsCompleteEngelmannSpruceIdentity() {
        let profile = PiceaEngelmanniiSpeciesProfile.profile
        #expect(profile.scientificName == "Picea engelmannii")
        #expect(profile.primaryCommonName == "Engelmann Spruce")
        #expect(!profile.commonNames.contains("Engelmann's Spruce"))
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Western Canada through the western and west-central United States to northeastern Mexico.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High — naturally adapted to cold mountainous environments")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Vigorous when well established")
        #expect(profile.traits.growthSpeed == "Strongly climate and site dependent")
        #expect(profile.traits.leafSize == "Evergreen · Short, fine needles · Green to blue-green/glaucous")
        #expect(profile.traits.ramificationPotential == "Fine branching possible with disciplined development")
        #expect(profile.traits.backBudding == "Limited compared with broadleaf deciduous species — preserve viable foliage and buds")
        #expect(profile.traits.wiring == "Useful during structural development — protect bark and young shoots")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea engelmannii"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea glauca"))
        #expect(visible.localizedCaseInsensitiveContains("Picea pungens"))
        #expect(visible.localizedCaseInsensitiveContains("Picea sitchensis"))
        #expect(visible.localizedCaseInsensitiveContains("mountain"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("subsp. engelmannii"))
        #expect(visible.localizedCaseInsensitiveContains("subsp. mexicana"))
        #expect(visible.localizedCaseInsensitiveContains("Norway"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering schedule"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("krummholz"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func piceaGlaucaProfileIsCompleteWhiteSpruceIdentity() {
        let profile = PiceaGlaucaSpeciesProfile.profile
        #expect(profile.scientificName == "Picea glauca")
        #expect(profile.primaryCommonName == "White Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "North America, broadly across Canada and the northern and northeastern United States.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Very high")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Vigorous when established")
        #expect(profile.traits.growthSpeed == "Strongly dependent on climate, light, root health and cultivation conditions")
        #expect(profile.traits.leafSize == "Evergreen · Short four-sided needles · Green to blue-green")
        #expect(profile.traits.ramificationPotential == "Fine branching possible with gradual development")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development and branch positioning")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea glauca"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaEngelmannii)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea engelmannii"))
        #expect(visible.localizedCaseInsensitiveContains("Picea pungens"))
        #expect(visible.localizedCaseInsensitiveContains("Picea sitchensis"))
        #expect(visible.localizedCaseInsensitiveContains("Picea abies"))
        #expect(visible.localizedCaseInsensitiveContains("boreal"))
        #expect(visible.localizedCaseInsensitiveContains("Canada"))
        #expect(visible.localizedCaseInsensitiveContains("four-sided"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Norwegian"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func piceaMarianaProfileIsCompleteBlackSpruceIdentity() {
        let profile = PiceaMarianaSpeciesProfile.profile
        #expect(profile.scientificName == "Picea mariana")
        #expect(profile.primaryCommonName == "Black Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Subarctic North America through northern and northeastern North America.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Very high")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow")
        #expect(profile.traits.growthSpeed == "Slow — long-term development required")
        #expect(profile.traits.leafSize == "Evergreen · Short, stiff blue-green needles")
        #expect(profile.traits.ramificationPotential == "Fine branching possible, but development is slow")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development — monitor carefully for scarring")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea mariana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaGlauca)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaEngelmannii)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea nigra"))
        #expect(visible.localizedCaseInsensitiveContains("Picea abies"))
        #expect(visible.localizedCaseInsensitiveContains("Picea glauca"))
        #expect(visible.localizedCaseInsensitiveContains("Picea engelmannii"))
        #expect(visible.localizedCaseInsensitiveContains("boreal"))
        #expect(visible.localizedCaseInsensitiveContains("subarctic"))
        #expect(visible.localizedCaseInsensitiveContains("spire-like"))
        #expect(visible.localizedCaseInsensitiveContains("slow"))
        #expect(visible.localizedCaseInsensitiveContains("oxygen-poor"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Norwegian"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func piceaOmorikaProfileIsCompleteSerbianSpruceIdentity() {
        let profile = PiceaOmorikaSpeciesProfile.profile
        #expect(profile.scientificName == "Picea omorika")
        #expect(profile.primaryCommonName == "Serbian Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "A very restricted natural range in the western Balkans, particularly in Serbia and Bosnia and Herzegovina.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Vigorous, with strong apical dominance")
        #expect(profile.traits.leafSize == "Evergreen · Short, fine needles · Dark green above, paler below")
        #expect(profile.traits.ramificationPotential == "Fine branching possible with gradual development")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for establishing branch structure and natural cascading/descending branch character")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea omorika"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaMariana)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea abies"))
        #expect(visible.localizedCaseInsensitiveContains("Picea orientalis"))
        #expect(visible.localizedCaseInsensitiveContains("Balkans"))
        #expect(visible.localizedCaseInsensitiveContains("Serbia"))
        #expect(visible.localizedCaseInsensitiveContains("apical"))
        #expect(visible.localizedCaseInsensitiveContains("pendulous"))
        #expect(visible.localizedCaseInsensitiveContains("two-tone"))
        #expect(visible.localizedCaseInsensitiveContains("narrow"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 4 — Balance"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func piceaPungensProfileIsCompleteBlueSpruceIdentity() {
        let profile = PiceaPungensSpeciesProfile.profile
        #expect(profile.scientificName == "Picea pungens")
        #expect(profile.primaryCommonName == "Blue Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Rocky Mountains of the western United States.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate; can be vigorous when young and well established")
        #expect(profile.traits.leafSize == "Evergreen · Stiff, pointed needles · Green to blue-green/glaucous")
        #expect(profile.traits.ramificationPotential == "Fine branching possible with gradual development")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development and branch positioning")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea pungens"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaGlauca)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaOmorika)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea glauca"))
        #expect(visible.localizedCaseInsensitiveContains("Picea engelmannii"))
        #expect(visible.localizedCaseInsensitiveContains("Picea omorika"))
        #expect(visible.localizedCaseInsensitiveContains("Rocky Mountains"))
        #expect(visible.localizedCaseInsensitiveContains("not every"))
        #expect(visible.localizedCaseInsensitiveContains("intensely blue"))
        #expect(visible.localizedCaseInsensitiveContains("stiff"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("cultivars"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func piceaSitchensisProfileIsCompleteSitkaSpruceIdentity() {
        let profile = PiceaSitchensisSpeciesProfile.profile
        #expect(profile.scientificName == "Picea sitchensis")
        #expect(profile.primaryCommonName == "Sitka Spruce")
        #expect(profile.family == "Pinaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Coastal western North America, from Alaska through British Columbia and along the Pacific coast of the northwestern United States.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High")
        #expect(profile.traits.bonsaiSuitability == "Good for larger formats")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Fast and vigorous under favourable conditions")
        #expect(profile.traits.growthSpeed == "Fast — vigour must be controlled during refinement")
        #expect(profile.traits.leafSize == "Evergreen · Stiff, sharply pointed needles · Green to blue-green")
        #expect(profile.traits.ramificationPotential == "Possible with gradual development, but vigour must be controlled")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development — monitor carefully during vigorous growth")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Picea sitchensis"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaAbies)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.piceaPungens)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Picea glauca"))
        #expect(visible.localizedCaseInsensitiveContains("Picea pungens"))
        #expect(visible.localizedCaseInsensitiveContains("Pacific"))
        #expect(visible.localizedCaseInsensitiveContains("coastal"))
        #expect(visible.localizedCaseInsensitiveContains("Alaska"))
        #expect(visible.localizedCaseInsensitiveContains("not naturally a small tree"))
        #expect(visible.localizedCaseInsensitiveContains("medium-to-large"))
        #expect(visible.localizedCaseInsensitiveContains("vigour"))
        #expect(visible.localizedCaseInsensitiveContains("oxygen-poor"))
        #expect(visible.localizedCaseInsensitiveContains("hanging cones"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 4 — Vigour control"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func taxusCuspidataProfileIsCompleteJapaneseYewIdentity() {
        let profile = TaxusCuspidataSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus cuspidata")
        #expect(profile.primaryCommonName == "Japanese Yew")
        #expect(profile.commonNames == ["Japanese Yew"])
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Southern Russian Far East, Korea, northern China and Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate — strongly climate and cultivation dependent")
        #expect(profile.traits.leafSize == "Evergreen · Dark green needle-like foliage · Relatively short, flattened needles")
        #expect(profile.traits.ramificationPotential == "Good with controlled development")
        #expect(profile.traits.backBudding == "Good potential compared with many conifers, especially on established healthy material — not guaranteed")
        #expect(profile.traits.wiring == "Highly suitable — flexible wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Taxus cuspidata"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Siebold & Zucc."))
        #expect(visible.localizedCaseInsensitiveContains("Taxus baccata"))
        #expect(visible.contains("Taxus × media"))
        #expect(visible.localizedCaseInsensitiveContains("Russian Far East"))
        #expect(visible.localizedCaseInsensitiveContains("Korea"))
        #expect(visible.localizedCaseInsensitiveContains("Japan"))
        #expect(visible.localizedCaseInsensitiveContains("deadwood"))
        #expect(visible.localizedCaseInsensitiveContains("live-vein") || visible.localizedCaseInsensitiveContains("live vein"))
        #expect(visible.localizedCaseInsensitiveContains("back-budding is not guaranteed") || visible.localizedCaseInsensitiveContains("not guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine full defoliation") || visible.localizedCaseInsensitiveContains("Do not recommend routine"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("highly toxic"))
        #expect(visible.localizedCaseInsensitiveContains("aril"))
        #expect(visible.localizedCaseInsensitiveContains("waterlogging"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 5 — Mature Bonsai"))
        #expect(!visible.localizedCaseInsensitiveContains("antidote"))
        #expect(!visible.localizedCaseInsensitiveContains("call emergency"))
        #expect(profile.sections.contains { $0.id == "toxicity" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
    }

    @Test func taxusMediaProfileIsCompleteHybridYewIdentity() {
        let profile = TaxusMediaSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus × media")
        #expect(profile.primaryCommonName == "Hybrid Yew")
        #expect(profile.commonNames == ["Hybrid Yew", "Anglo-Japanese Yew"])
        #expect(profile.synonyms == ["Taxus x media"])
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer · Horticultural hybrid")
        #expect(profile.originSummary == "Artificial horticultural hybrid of Taxus baccata and Taxus cuspidata.")
        #expect(TaxusMediaSpeciesProfile.botanicalLibraryName == "Taxus x media")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Taxus x media"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.taxusMedia)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCuspidata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCanadensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusWallichiana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusFloridana)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Taxus baccata"))
        #expect(visible.localizedCaseInsensitiveContains("Taxus cuspidata"))
        #expect(visible.localizedCaseInsensitiveContains("toxic"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(profile.sections.contains { $0.id == "toxicity" })
    }

    @Test func taxusCanadensisProfileIsCompleteCanadaYewIdentity() {
        let profile = TaxusCanadensisSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus canadensis")
        #expect(profile.primaryCommonName == "Canada Yew")
        #expect(profile.commonNames == ["Canada Yew", "Canadian Yew"])
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Eastern North America, from Newfoundland and the Great Lakes region south through the northeastern United States into the Appalachians.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Taxus canadensis"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.taxusCanadensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCuspidata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusMedia)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusWallichiana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusFloridana)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("spreading") || visible.localizedCaseInsensitiveContains("shrubby"))
        #expect(visible.localizedCaseInsensitiveContains("shade"))
        #expect(visible.localizedCaseInsensitiveContains("toxic"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(profile.sections.contains { $0.id == "toxicity" })
    }

    @Test func taxusWallichianaProfileIsCompleteHimalayanYewIdentity() {
        let profile = TaxusWallichianaSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus wallichiana")
        #expect(profile.primaryCommonName == "Himalayan Yew")
        #expect(profile.commonNames == ["Himalayan Yew"])
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "The Himalaya and adjoining mountain regions of south and southeast Asia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Taxus wallichiana"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.taxusWallichiana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCuspidata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusMedia)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCanadensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusFloridana)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Zucc."))
        #expect(visible.localizedCaseInsensitiveContains("nursery"))
        #expect(visible.localizedCaseInsensitiveContains("legal") || visible.localizedCaseInsensitiveContains("ethical"))
        #expect(visible.localizedCaseInsensitiveContains("toxic"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(profile.sections.contains { $0.id == "toxicity" })
    }

    @Test func taxusFloridanaProfileIsCompleteFloridaYewIdentity() {
        let profile = TaxusFloridanaSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus floridana")
        #expect(profile.primaryCommonName == "Florida Yew")
        #expect(profile.commonNames == ["Florida Yew"])
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "A very restricted native range in northwestern Florida, USA.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Taxus floridana"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.taxusFloridana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCuspidata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusMedia)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusCanadensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusWallichiana)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("nursery"))
        #expect(visible.localizedCaseInsensitiveContains("restricted") || visible.localizedCaseInsensitiveContains("endemic"))
        #expect(visible.localizedCaseInsensitiveContains("cold-hardy") || visible.localizedCaseInsensitiveContains("cold hardy") || visible.localizedCaseInsensitiveContains("less cold"))
        #expect(visible.localizedCaseInsensitiveContains("toxic"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(profile.sections.contains { $0.id == "toxicity" })
    }

    @Test func taxusBaccataProfileIsCompleteEuropeanYewIdentity() {
        let profile = TaxusBaccataSpeciesProfile.profile
        #expect(profile.scientificName == "Taxus baccata")
        #expect(profile.primaryCommonName == "European Yew")
        #expect(profile.family == "Taxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.backBudding == "Excellent under healthy conditions")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Taxus cuspidata"))
        #expect(visible.contains("Taxus × media"))
        #expect(visible.localizedCaseInsensitiveContains("must never be described as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Shade tolerance does not mean permanent low-light cultivation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend permanent indoor cultivation"))
        #expect(visible.localizedCaseInsensitiveContains("All parts of the tree contain toxic compounds"))
        #expect(!visible.localizedCaseInsensitiveContains("antidote"))
        #expect(!visible.localizedCaseInsensitiveContains("call emergency"))
    }

    @Test func juniperusCommunisProfileIsCompleteCommonJuniperIdentity() {
        let profile = JuniperusCommunisSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus communis")
        #expect(profile.primaryCommonName == "Common Juniper")
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.backBudding == "Limited · Do not rely on budding from bare old wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Juniperus chinensis"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus sabina"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus procumbens"))
        #expect(visible.localizedCaseInsensitiveContains("scale-foliage"))
        #expect(visible.localizedCaseInsensitiveContains("bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("natural deadwood rather than decorative deadwood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use broadleaf defoliation"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusChinensis)
    }

    @Test func juniperusRigidaProfileIsCompleteNeedleJuniperIdentity() {
        let profile = JuniperusRigidaSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus rigida")
        #expect(profile.primaryCommonName == "Needle Juniper")
        #expect(profile.commonNames.contains("Temple Juniper"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Northeastern Asia, including China, Korea, Japan and parts of the Russian Far East.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow")
        #expect(profile.traits.leafSize == "Evergreen · Needle foliage")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Limited — depends strongly on retained healthy foliage")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Juniperus rigida"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusChinensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusCommunis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusProcumbens)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Juniperus chinensis"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus procumbens"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus communis"))
        #expect(visible.localizedCaseInsensitiveContains("needle"))
        #expect(visible.localizedCaseInsensitiveContains("living veins"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Excellent"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func juniperusSabinaProfileIsCompleteSavinJuniperIdentity() {
        let profile = JuniperusSabinaSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus sabina")
        #expect(profile.primaryCommonName == "Savin Juniper")
        #expect(profile.commonNames.contains("Savin"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Europe, western and central Asia, extending across mountainous and continental regions.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Intermediate to Advanced")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Scale foliage with potential juvenile foliage")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Limited to Moderate — strongly dependent on retained healthy foliage")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Juniperus sabina"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusChinensis)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusRigida)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.juniperusProcumbens)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Juniperus chinensis"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus rigida"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus procumbens"))
        #expect(visible.localizedCaseInsensitiveContains("scale foliage"))
        #expect(visible.localizedCaseInsensitiveContains("juvenile foliage"))
        #expect(visible.localizedCaseInsensitiveContains("living tissue"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("yamadori"))
        #expect(visible.localizedCaseInsensitiveContains("Excellent"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func juniperusProcumbensProfileIsCompleteJapaneseGardenJuniperIdentity() {
        let profile = JuniperusProcumbensSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus procumbens")
        #expect(profile.primaryCommonName == "Japanese Garden Juniper")
        #expect(profile.commonNames.contains("Japanese Juniper"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Primarily scale foliage")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Limited to Moderate — dependent on retained healthy foliage")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Excellent")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Juniperus procumbens"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.juniperusProcumbens)
        #expect(profile.id != JuniperusProcumbensGreenMoundSpeciesProfile.profile.id)
        #expect(JuniperusProcumbensGreenMoundSpeciesProfile.profile.cultivarID == BotanicalKnowledgeIDs.juniperusProcumbensGreenMound)
        #expect(profile.libraryCategory == .conifers)

        let resolvedSpecies = SpeciesProfileCatalog.profile(speciesID: BotanicalKnowledgeIDs.juniperusProcumbens)
        #expect(resolvedSpecies?.cultivarID == nil)
        #expect(resolvedSpecies?.scientificName == "Juniperus procumbens")
        let resolvedCultivar = SpeciesProfileCatalog.profile(
            speciesID: BotanicalKnowledgeIDs.juniperusProcumbens,
            cultivarID: BotanicalKnowledgeIDs.juniperusProcumbensGreenMound
        )
        #expect(resolvedCultivar?.cultivarID == BotanicalKnowledgeIDs.juniperusProcumbensGreenMound)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Green Mound"))
        #expect(visible.localizedCaseInsensitiveContains("scale foliage"))
        #expect(visible.localizedCaseInsensitiveContains("shohin"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("interior foliage"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Wiring is one of the primary development tools"))
        #expect(visible.localizedCaseInsensitiveContains("Cultivar-specific characteristics must not automatically"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func juniperusSquamataProfileIsCompleteFlakyJuniperIdentity() {
        let profile = JuniperusSquamataSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus squamata")
        #expect(profile.primaryCommonName == "Flaky Juniper")
        #expect(profile.commonNames.contains("Himalayan Juniper"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "The Himalayan region and mountainous areas of central and eastern Asia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good to Excellent")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Needle-like foliage")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Limited to Moderate — dependent on retained healthy foliage")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Juniperus squamata"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.juniperusSquamata)
        #expect(profile.id != JuniperusSquamataBlueStarSpeciesProfile.profile.id)
        #expect(JuniperusSquamataBlueStarSpeciesProfile.profile.cultivarID == BotanicalKnowledgeIDs.juniperusSquamataBlueStar)
        #expect(profile.libraryCategory == .conifers)

        let resolvedSpecies = SpeciesProfileCatalog.profile(speciesID: BotanicalKnowledgeIDs.juniperusSquamata)
        #expect(resolvedSpecies?.cultivarID == nil)
        #expect(resolvedSpecies?.scientificName == "Juniperus squamata")
        let resolvedCultivar = SpeciesProfileCatalog.profile(
            speciesID: BotanicalKnowledgeIDs.juniperusSquamata,
            cultivarID: BotanicalKnowledgeIDs.juniperusSquamataBlueStar
        )
        #expect(resolvedCultivar?.cultivarID == BotanicalKnowledgeIDs.juniperusSquamataBlueStar)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Blue Star"))
        #expect(visible.localizedCaseInsensitiveContains("needle-like"))
        #expect(visible.localizedCaseInsensitiveContains("mountain"))
        #expect(visible.localizedCaseInsensitiveContains("Himalayan"))
        #expect(visible.localizedCaseInsensitiveContains("Do not strip branches bare"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume old bare wood"))
        #expect(visible.localizedCaseInsensitiveContains("interior foliage"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Wiring is an important development tool"))
        #expect(visible.localizedCaseInsensitiveContains("Cultivar-specific characteristics must not automatically"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func juniperusChinensisProfileIsBaselineSpeciesSeparateFromCultivars() {
        let profile = JuniperusChinensisSpeciesProfile.profile
        #expect(profile.scientificName == "Juniperus chinensis")
        #expect(profile.primaryCommonName == "Chinese Juniper")
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.speciesID == BotanicalKnowledgeIDs.juniperusChinensis)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("baseline species"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus communis"))
        #expect(visible.localizedCaseInsensitiveContains("scale foliage"))
        #expect(visible.localizedCaseInsensitiveContains("juvenile"))
        #expect(visible.localizedCaseInsensitiveContains("completely bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Itoigawa"))
        #expect(visible.localizedCaseInsensitiveContains("Kishu"))
        #expect(visible.localizedCaseInsensitiveContains("Blaauw"))

        #expect(
            SpeciesProfileCatalog.profile(
                speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
                cultivarID: nil
            )?.id == profile.id
        )
        #expect(
            SpeciesProfileCatalog.profile(
                speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
                cultivarID: BotanicalKnowledgeIDs.juniperusChinensisItoigawa
            )?.id == BotanicalKnowledgeIDs.juniperusChinensisItoigawa
        )
        #expect(
            SpeciesProfileCatalog.profile(
                speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
                cultivarID: BotanicalKnowledgeIDs.juniperusChinensisKishu
            )?.id == BotanicalKnowledgeIDs.juniperusChinensisKishu
        )
        #expect(
            SpeciesProfileCatalog.profile(scientificName: "Juniperus chinensis")?.cultivarID == nil
        )
    }

    @Test func ulmusMinorProfileIsCompleteFieldElmIdentity() {
        let profile = UlmusMinorSpeciesProfile.profile
        #expect(profile.scientificName == "Ulmus minor")
        #expect(profile.primaryCommonName == "Field Elm")
        #expect(profile.commonNames.contains("European Field Elm"))
        #expect(profile.family == "Ulmaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.ramificationPotential == "Excellent")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Ulmus parvifolia"))
        #expect(visible.localizedCaseInsensitiveContains("Ulmus glabra"))
        #expect(visible.localizedCaseInsensitiveContains("must not be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Dutch elm disease"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.ulmusParvifolia)
    }

    @Test func quercusRoburProfileIsCompleteEnglishOakIdentity() {
        let profile = QuercusRoburSpeciesProfile.profile
        #expect(profile.scientificName == "Quercus robur")
        #expect(profile.primaryCommonName == "English Oak")
        #expect(profile.commonNames.contains("Pedunculate Oak"))
        #expect(profile.family == "Fagaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.bonsaiSuitability == "Excellent")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Quercus petraea"))
        #expect(visible.localizedCaseInsensitiveContains("Quercus ilex"))
        #expect(visible.localizedCaseInsensitiveContains("Quercus suber"))
        #expect(visible.localizedCaseInsensitiveContains("must not be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("medium or large bonsai"))
        #expect(visible.localizedCaseInsensitiveContains("Older oak branches become rigid"))
        #expect(!profile.commonNames.contains("European Oak"))
    }

    @Test func crataegusMonogynaProfileIsCompleteCommonHawthornIdentity() {
        let profile = CrataegusMonogynaSpeciesProfile.profile
        #expect(profile.scientificName == "Crataegus monogyna")
        #expect(profile.primaryCommonName == "Common Hawthorn")
        #expect(profile.commonNames.contains("English Hawthorn"))
        #expect(profile.family == "Rosaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.defoliation == "Not recommended as routine management")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("other Crataegus species"))
        #expect(visible.localizedCaseInsensitiveContains("must not be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present full defoliation as a standard"))
        #expect(visible.localizedCaseInsensitiveContains("white flowers"))
        #expect(visible.localizedCaseInsensitiveContains("red fruit"))
        #expect(visible.localizedCaseInsensitiveContains("Thorns are an important natural characteristic"))
        #expect(visible.localizedCaseInsensitiveContains("fire blight"))
        #expect(visible.localizedCaseInsensitiveContains("Take particular care around thorns"))
        #expect(!profile.commonNames.contains("Hawthorn"))
    }

    @Test func alnusGlutinosaProfileIsCompleteBlackAlderIdentity() {
        let profile = AlnusGlutinosaSpeciesProfile.profile
        #expect(profile.scientificName == "Alnus glutinosa")
        #expect(profile.primaryCommonName == "Black Alder")
        #expect(profile.commonNames.contains("Common Alder"))
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.growthStrength == "Strong")
        #expect(profile.traits.growthSpeed == "Fast")
        #expect(profile.traits.bonsaiSuitability == "Good to Excellent")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Alnus incana"))
        #expect(visible.localizedCaseInsensitiveContains("must not be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("woody cones"))
        #expect(visible.localizedCaseInsensitiveContains("permanently waterlogged"))
        #expect(visible.localizedCaseInsensitiveContains("adequate oxygen"))
        #expect(visible.localizedCaseInsensitiveContains("moderate to high"))
        #expect(!profile.commonNames.contains("European Alder"))
    }

    @Test func alnusIncanaProfileIsCompleteGreyAlderIdentity() {
        let profile = AlnusIncanaSpeciesProfile.profile
        #expect(profile.scientificName == "Alnus incana")
        #expect(profile.primaryCommonName == "Grey Alder")
        #expect(profile.commonNames.contains("Gray Alder"))
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Europe, northern and central Asia, and parts of North America depending on recognised subspecies and regional classification.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Strong")
        #expect(profile.traits.growthSpeed == "Fast")
        #expect(profile.traits.leafSize == "Deciduous · Medium")
        #expect(profile.traits.ramificationPotential == "Good with refinement")
        #expect(profile.traits.backBudding == "Moderate to Good")
        #expect(profile.traits.rootDevelopment == "Strong")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Fast when allowed to grow freely")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Alnus incana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.alnusGlutinosa)
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Alnus glutinosa"))
        #expect(visible.localizedCaseInsensitiveContains("Nordic"))
        #expect(visible.localizedCaseInsensitiveContains("Northern Europe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not merge"))
        #expect(visible.localizedCaseInsensitiveContains("permanently stagnant"))
        #expect(visible.localizedCaseInsensitiveContains("characteristic alder cones"))
        #expect(visible.localizedCaseInsensitiveContains("Do not refine prematurely"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that completely bare old branches"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Naturalistic"))
        #expect(visible.localizedCaseInsensitiveContains("moderate to high during active growth"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("moderate in naturalistic material"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "fruit" })
    }

    @Test func tiliaCordataProfileIsCompleteSmallLeavedLimeIdentity() {
        let profile = TiliaCordataSpeciesProfile.profile
        #expect(profile.scientificName == "Tilia cordata")
        #expect(profile.primaryCommonName == "Small-leaved Lime")
        #expect(profile.commonNames.contains("Littleleaf Linden"))
        #expect(profile.commonNames.contains("Small-leaved Linden"))
        #expect(profile.family == "Malvaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Europe and western Asia.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate to Fast")
        #expect(profile.traits.leafSize == "Deciduous · Medium")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Good")
        #expect(profile.traits.rootDevelopment == "Good")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Strong")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Tilia cordata"))
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Tilia platyphyllos"))
        #expect(visible.localizedCaseInsensitiveContains("heart-shaped"))
        #expect(visible.localizedCaseInsensitiveContains("Leaf size"))
        #expect(visible.localizedCaseInsensitiveContains("Nordic"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every old or bare branch"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Naturalistic"))
        #expect(visible.localizedCaseInsensitiveContains("moderate to high during active growth"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("medium bonsai"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func ginkgoBilobaProfileIsCompleteGinkgoIdentity() {
        let profile = GinkgoBilobaSpeciesProfile.profile
        #expect(profile.scientificName == "Ginkgo biloba")
        #expect(profile.primaryCommonName == "Ginkgo")
        #expect(profile.commonNames.contains("Maidenhair Tree"))
        #expect(profile.family == "Ginkgoaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous gymnosperm")
        #expect(profile.originSummary == "China.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.leafSize == "Deciduous · Medium")
        #expect(profile.traits.ramificationPotential == "Moderate")
        #expect(profile.traits.backBudding == "Moderate")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Good potential with long-term development")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Ginkgo biloba"))
        #expect(profile.libraryCategory == .nonFloweringDeciduous)
        #expect(profile.libraryCategory != .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("gymnosperm"))
        #expect(visible.localizedCaseInsensitiveContains("fan-shaped"))
        #expect(visible.localizedCaseInsensitiveContains("Do not place Ginkgo biloba in Conifers"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe it as a flowering tree"))
        #expect(visible.localizedCaseInsensitiveContains("not botanical fruit"))
        #expect(visible.localizedCaseInsensitiveContains("Do not classify it as a conifer"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every old or bare branch"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Long-term development"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "fruit" })
    }

    @Test func acerGinnalaProfileIsCompleteAmurMapleIdentity() {
        let profile = AcerGinnalaSpeciesProfile.profile
        #expect(profile.scientificName == "Acer ginnala")
        #expect(profile.primaryCommonName == "Amur Maple")
        #expect(profile.commonNames.contains("Siberian Maple"))
        #expect(profile.family == "Sapindaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Northeastern Asia, including parts of China, Mongolia, Korea and the Russian Far East.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Very Good")
        #expect(profile.traits.difficulty == "Beginner to Intermediate")
        #expect(profile.traits.beginnerSuitability == "Good")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Deciduous · Small")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Good")
        #expect(profile.traits.rootDevelopment == "Good")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Acer ginnala"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.acerPalmatum)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.acerCampestre)
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Acer palmatum"))
        #expect(visible.localizedCaseInsensitiveContains("Acer campestre"))
        #expect(visible.localizedCaseInsensitiveContains("Acer tataricum"))
        #expect(visible.localizedCaseInsensitiveContains("avoid creating duplicate species records"))
        #expect(visible.localizedCaseInsensitiveContains("autumn colour"))
        #expect(visible.localizedCaseInsensitiveContains("smaller bonsai"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every old or bare branch"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func betulaPendulaProfileIsCompleteSilverBirchIdentity() {
        let profile = BetulaPendulaSpeciesProfile.profile
        #expect(profile.scientificName == "Betula pendula")
        #expect(profile.primaryCommonName == "Silver Birch")
        #expect(profile.commonNames.contains("European White Birch"))
        #expect(profile.commonNames.contains("Weeping Birch"))
        #expect(!profile.commonNames.contains("Common Birch"))
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Europe and parts of western and northern Asia.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate to Advanced")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate to Fast")
        #expect(profile.traits.leafSize == "Deciduous · Small to Medium")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Moderate")
        #expect(profile.traits.rootDevelopment == "Moderate")
        #expect(profile.traits.nebariPotential == "Moderate potential")
        #expect(profile.traits.trunkDevelopment == "Moderate to Fast when grown freely")
        #expect(profile.traits.barkDevelopment == "Excellent and highly distinctive")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Betula pendula"))
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Betula pubescens"))
        #expect(visible.localizedCaseInsensitiveContains("Nordic"))
        #expect(visible.localizedCaseInsensitiveContains("Weeping Birch should only be used cautiously"))
        #expect(visible.localizedCaseInsensitiveContains("Fagus"))
        #expect(visible.localizedCaseInsensitiveContains("Carpinus"))
        #expect(visible.localizedCaseInsensitiveContains("Protect the natural bark character"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid damaging the characteristic bark"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every bare or old branch"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Naturalistic"))
        #expect(visible.localizedCaseInsensitiveContains("moderate to high during active growth"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("moderate in naturalistic material"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func betulaPubescensProfileIsCompleteDownyBirchIdentity() {
        let profile = BetulaPubescensSpeciesProfile.profile
        #expect(profile.scientificName == "Betula pubescens")
        #expect(profile.primaryCommonName == "Downy Birch")
        #expect(profile.commonNames.contains("European Downy Birch"))
        #expect(profile.commonNames.contains("White Birch"))
        #expect(profile.family == "Betulaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous tree")
        #expect(profile.originSummary == "Northern and temperate Europe and Asia.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate to Fast")
        #expect(profile.traits.leafSize == "Deciduous · Small to Medium")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Moderate to Good")
        #expect(profile.traits.rootDevelopment == "Good")
        #expect(profile.traits.nebariPotential == "Moderate to Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate to Fast")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Betula pubescens"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.betulaPendula)
        #expect(profile.libraryCategory == .nonFloweringDeciduous)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Betula pendula"))
        #expect(visible.localizedCaseInsensitiveContains("Norway"))
        #expect(visible.localizedCaseInsensitiveContains("Northern Europe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not merge"))
        #expect(visible.localizedCaseInsensitiveContains("permanently stagnant"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as routine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that all old or bare branches"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Naturalistic"))
        #expect(visible.localizedCaseInsensitiveContains("moderate to high during active growth"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func buxusSempervirensProfileIsCompleteEuropeanBoxIdentity() {
        let profile = BuxusSempervirensSpeciesProfile.profile
        #expect(profile.scientificName == "Buxus sempervirens")
        #expect(profile.primaryCommonName == "European Box")
        #expect(profile.commonNames.contains("Common Box"))
        #expect(profile.commonNames.contains("Boxwood"))
        #expect(profile.family == "Buxaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen broadleaf shrub or small tree")
        #expect(profile.originSummary == "Europe, North Africa and Western Asia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.growthStrength == "Slow")
        #expect(profile.traits.growthSpeed == "Slow")
        #expect(profile.traits.leafSize == "Evergreen · Small leaves")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good to Excellent under healthy conditions")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Slow")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate during prolonged severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Buxus sempervirens"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Japanese Box"))
        #expect(visible.localizedCaseInsensitiveContains("Chinese Box"))
        #expect(visible.localizedCaseInsensitiveContains("do not replace European Box"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Buxus sempervirens as requiring permanent indoor protection"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior growth"))
        #expect(visible.localizedCaseInsensitiveContains("hedge-like"))
        #expect(visible.localizedCaseInsensitiveContains("box tree moth"))
        #expect(visible.localizedCaseInsensitiveContains("box blight"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid unnecessary artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed to cold"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(!visible.localizedCaseInsensitiveContains("Excellent carving"))
    }

    @Test func phillyreaAngustifoliaProfileIsCompleteNarrowLeavedMockPrivetIdentity() {
        let profile = PhillyreaAngustifoliaSpeciesProfile.profile
        #expect(profile.scientificName == "Phillyrea angustifolia")
        #expect(profile.primaryCommonName == "Narrow-leaved Mock Privet")
        #expect(profile.commonNames.contains("Narrow-leaved Phillyrea"))
        #expect(!profile.commonNames.contains("False Olive"))
        #expect(profile.family == "Oleaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean broadleaf shrub or small tree")
        #expect(profile.originSummary == "Mediterranean region.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Naturally narrow leaves")
        #expect(profile.traits.ramificationPotential == "Good to Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Selective leaf management possible · Complete defoliation not routine")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Phillyrea angustifolia"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.oleaEuropaea)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Olea europaea"))
        #expect(visible.localizedCaseInsensitiveContains("Ligustrum"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe this species as a true privet"))
        #expect(visible.localizedCaseInsensitiveContains("is not a true privet"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Mediterranean drought adaptation"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Phillyrea angustifolia as universally frost hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior growth"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid excessive artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("does not replace Narrow-leaved Mock Privet"))
        #expect(!visible.localizedCaseInsensitiveContains("False Olive"))
    }

    @Test func pistaciaLentiscusProfileIsCompleteMasticTreeIdentity() {
        let profile = PistaciaLentiscusSpeciesProfile.profile
        #expect(profile.scientificName == "Pistacia lentiscus")
        #expect(profile.primaryCommonName == "Mastic Tree")
        #expect(profile.commonNames.contains("Mastic"))
        #expect(profile.commonNames.contains("Lentisk"))
        #expect(profile.family == "Anacardiaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean shrub or small tree")
        #expect(profile.originSummary == "Mediterranean region.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.growthSpeed == "Slow to Moderate")
        #expect(profile.traits.ramificationPotential == "Good to Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.leafSize == "Evergreen · Compound leaves with small leaflets")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Pistacia lentiscus"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Pistacia terebinthus"))
        #expect(visible.localizedCaseInsensitiveContains("compound"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerance in nature"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Pistacia lentiscus as universally frost hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior growth"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid excessive artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("do not replace Mastic Tree"))
    }

    @Test func podocarpusMacrophyllusProfileIsCompleteBuddhistPineIdentity() {
        let profile = PodocarpusMacrophyllusSpeciesProfile.profile
        #expect(profile.scientificName == "Podocarpus macrophyllus")
        #expect(profile.primaryCommonName == "Buddhist Pine")
        #expect(profile.commonNames.contains("Japanese Yew"))
        #expect(profile.commonNames.contains("Yew Podocarpus"))
        #expect(profile.family == "Podocarpaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen broadleaf-like conifer")
        #expect(profile.originSummary == "East Asia.")
        #expect(!profile.traits.deciduous)
        #expect(!profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Reduced seasonal growth rather than a strong temperate dormancy")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.difficulty == "Beginner to Intermediate")
        #expect(profile.traits.beginnerSuitability == "Good")
        #expect(profile.traits.growthStrength == "Moderate")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Evergreen · Long narrow leaves")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.barkDevelopment == "Good mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not applicable as routine management")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High in prolonged or severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Podocarpus macrophyllus"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.taxusBaccata)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.pinusThunbergii)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Taxus"))
        #expect(visible.localizedCaseInsensitiveContains("Pinus"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Podocarpus macrophyllus as a true pine"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe it as a true yew"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat the foliage as if it were pine needles"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every bare branch will reliably produce new growth"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Podocarpus macrophyllus as universally hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior foliage"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid unnecessary artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("do not replace Buddhist Pine"))
        #expect(visible.localizedCaseInsensitiveContains("Outdoor cultivation is preferred"))
    }

    @Test func malusSylvestrisProfileIsCompleteEuropeanCrabAppleIdentity() {
        let profile = MalusSylvestrisSpeciesProfile.profile
        #expect(profile.scientificName == "Malus sylvestris")
        #expect(profile.primaryCommonName == "European Crab Apple")
        #expect(profile.commonNames.contains("Wild Apple"))
        #expect(profile.family == "Rosaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering and fruiting broadleaf tree")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.defoliation == "Not recommended as routine management")

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Malus domestica"))
        #expect(visible.localizedCaseInsensitiveContains("must not be treated as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present full defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("white to pale pink"))
        #expect(visible.localizedCaseInsensitiveContains("small apple-like fruit"))
        #expect(visible.localizedCaseInsensitiveContains("Selective fruit reduction"))
        #expect(visible.localizedCaseInsensitiveContains("apple scab"))
        #expect(!profile.commonNames.contains("Crab Apple"))
    }

    @Test func oleaEuropaeaProfileIsCompleteOliveIdentity() {
        let profile = OleaEuropaeaSpeciesProfile.profile
        #expect(profile.scientificName == "Olea europaea")
        #expect(profile.primaryCommonName == "Olive")
        #expect(profile.commonNames.contains("European Olive"))
        #expect(profile.commonNames.contains("Common Olive"))
        #expect(profile.family == "Oleaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean tree")
        #expect(profile.originSummary == "Mediterranean region and adjoining parts of western Asia and Africa.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good to Excellent under healthy conditions")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "High in prolonged freezing conditions, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Olea europaea"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("var. sylvestris"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerance in the landscape"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Olea europaea as frost hardy in all climates"))
        #expect(visible.localizedCaseInsensitiveContains("Live vein structure must be respected"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe aggressive carving as mandatory"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func oleaEuropaeaVarSylvestrisProfileIsCompleteWildOliveIdentity() {
        let profile = OleaEuropaeaVarSylvestrisSpeciesProfile.profile
        #expect(profile.scientificName == "Olea europaea var. sylvestris")
        #expect(profile.primaryCommonName == "Wild Olive")
        #expect(profile.commonNames.contains("Wild Olive Tree"))
        #expect(profile.commonNames.contains("Oleaster"))
        #expect(profile.family == "Oleaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean tree")
        #expect(profile.originSummary == "Mediterranean region.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Excellent under healthy conditions")
        #expect(profile.traits.trunkDevelopment == "Slow to Moderate")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.traits.rootFrostSensitivity == "High in prolonged freezing conditions, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Olea europaea var. sylvestris"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.oleaEuropaea)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "taxonomy-naming" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("distinct from the cultivated Olive"))
        #expect(visible.localizedCaseInsensitiveContains("Do not claim that every Wild Olive automatically has better"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that every tree sold as Wild Olive has identical botanical origin"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerance in nature"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Wild Olive as universally frost hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Live vein structure must be protected"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe aggressive carving as mandatory"))
        #expect(visible.localizedCaseInsensitiveContains("Collected or mature material"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func quercusIlexProfileIsCompleteHolmOakIdentity() {
        let profile = QuercusIlexSpeciesProfile.profile
        #expect(profile.scientificName == "Quercus ilex")
        #expect(profile.primaryCommonName == "Holm Oak")
        #expect(profile.commonNames.contains("Evergreen Oak"))
        #expect(profile.commonNames.contains("Holly Oak"))
        #expect(profile.family == "Fagaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean oak")
        #expect(profile.originSummary == "Mediterranean region.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.ramificationPotential == "Good to Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.defoliation == "Selective leaf management possible · Complete defoliation not routine")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Quercus ilex"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.quercusRobur)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Quercus suber"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerance in nature"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Quercus ilex as universally frost hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Leaf size can vary"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior growth"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid excessive artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func quercusSuberProfileIsCompleteCorkOakIdentity() {
        let profile = QuercusSuberSpeciesProfile.profile
        #expect(profile.scientificName == "Quercus suber")
        #expect(profile.primaryCommonName == "Cork Oak")
        #expect(profile.commonNames.contains("Mediterranean Cork Oak"))
        #expect(profile.family == "Fagaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen Mediterranean oak")
        #expect(profile.originSummary == "Western Mediterranean region.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.barkDevelopment == "Exceptional mature character")
        #expect(profile.traits.defoliation == "Selective leaf management possible · Complete defoliation not routine")
        #expect(profile.traits.rootFrostSensitivity == "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Quercus suber"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.quercusIlex)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.quercusRobur)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(visible.localizedCaseInsensitiveContains("Quercus ilex"))
        #expect(visible.localizedCaseInsensitiveContains("Quercus robur"))
        #expect(visible.localizedCaseInsensitiveContains("cork bark"))
        #expect(visible.localizedCaseInsensitiveContains("Do not confuse the characteristic cork bark with ordinary mature oak bark"))
        #expect(visible.localizedCaseInsensitiveContains("Do not promise mature cork bark"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("drought tolerance in nature"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe Quercus suber as universally frost hardy"))
        #expect(visible.localizedCaseInsensitiveContains("Preserve useful interior growth"))
        #expect(visible.localizedCaseInsensitiveContains("Avoid excessive artificial carving"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are significantly more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("does not replace Cork Oak"))
    }

    @Test func chamaecyparisPisiferaProfileIsCompleteSawaraCypressIdentity() {
        let profile = ChamaecyparisPisiferaSpeciesProfile.profile
        #expect(profile.scientificName == "Chamaecyparis pisifera")
        #expect(profile.primaryCommonName == "Sawara Cypress")
        #expect(profile.commonNames == ["Sawara Cypress"])
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Vigorous depending on form and growing conditions")
        #expect(profile.traits.growthSpeed == "Moderate to Vigorous — strongly form and climate dependent")
        #expect(profile.traits.leafSize == "Evergreen · Scale-like foliage · Green to blue-green at species level")
        #expect(profile.traits.ramificationPotential == "Dense and fine branching possible with gradual development")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for trunk and branch development")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Chamaecyparis pisifera"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisLawsoniana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisObtusa)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisNootkatensis)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis lawsoniana"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis obtusa"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis nootkatensis"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus"))
        #expect(visible.localizedCaseInsensitiveContains("Japan"))
        #expect(visible.localizedCaseInsensitiveContains("scale-like"))
        #expect(visible.localizedCaseInsensitiveContains("cultivar"))
        #expect(visible.localizedCaseInsensitiveContains("green to blue-green"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("three-dimensional"))
        #expect(visible.localizedCaseInsensitiveContains("shearing"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(visible.localizedCaseInsensitiveContains("green blob"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func chamaecyparisNootkatensisProfileIsCompleteNootkaCypressIdentity() {
        let profile = ChamaecyparisNootkatensisSpeciesProfile.profile
        #expect(profile.scientificName == "Chamaecyparis nootkatensis")
        #expect(profile.primaryCommonName == "Nootka Cypress")
        #expect(profile.commonNames.contains("Nootka Cypress"))
        #expect(profile.commonNames.contains("Yellow-Cedar"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Western North America, from coastal Alaska and British Columbia south through the Pacific Northwest and into northern California.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Very High")
        #expect(profile.traits.bonsaiSuitability == "Good for naturalistic and windswept forms")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Slow to Moderate")
        #expect(profile.traits.growthSpeed == "Slow to Moderate — long-term development characteristic")
        #expect(profile.traits.leafSize == "Evergreen · Scale-like foliage · Green to blue-green")
        #expect(profile.traits.ramificationPotential == "Fine branching possible with gradual development")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development and pendulous branch positioning")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Chamaecyparis nootkatensis"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisLawsoniana)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisObtusa)
        #expect(profile.speciesID != SpeciesPreviewData.id(named: "Chamaecyparis nootkantensis"))
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Callitropsis"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis lawsoniana"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis obtusa"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis pisifera"))
        #expect(visible.localizedCaseInsensitiveContains("Alaska"))
        #expect(visible.localizedCaseInsensitiveContains("British Columbia"))
        #expect(visible.localizedCaseInsensitiveContains("pendulous"))
        #expect(visible.localizedCaseInsensitiveContains("Yellow-Cedar"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("three-dimensional"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 4 — Branch character"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(visible.localizedCaseInsensitiveContains("refine rather than contradict"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func chamaecyparisLawsonianaProfileIsCompleteLawsonCypressIdentity() {
        let profile = ChamaecyparisLawsonianaSpeciesProfile.profile
        #expect(profile.scientificName == "Chamaecyparis lawsoniana")
        #expect(profile.primaryCommonName == "Lawson Cypress")
        #expect(profile.commonNames == ["Lawson Cypress"])
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Southwestern Oregon and northwestern California, USA.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "High")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Vigorous depending on conditions")
        #expect(profile.traits.growthSpeed == "Moderate to Vigorous — strongly climate and site dependent")
        #expect(profile.traits.leafSize == "Evergreen · Scale-like foliage · Green to blue-green (variable)")
        #expect(profile.traits.ramificationPotential == "Dense fine branching possible")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.wiring == "Useful for structural development and foliage positioning")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Chamaecyparis lawsoniana"))
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisObtusa)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(!profile.commonNames.contains("Lawson's Cypress"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use Lawson's Cypress"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis obtusa"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis pisifera"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis nootkatensis"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus"))
        #expect(visible.localizedCaseInsensitiveContains("Oregon"))
        #expect(visible.localizedCaseInsensitiveContains("California"))
        #expect(visible.localizedCaseInsensitiveContains("scale-like"))
        #expect(visible.localizedCaseInsensitiveContains("cultivar"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("three-dimensional"))
        #expect(visible.localizedCaseInsensitiveContains("shearing"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func chamaecyparisObtusaProfileIsCompleteHinokiCypressIdentity() {
        let profile = ChamaecyparisObtusaSpeciesProfile.profile
        #expect(profile.scientificName == "Chamaecyparis obtusa")
        #expect(profile.primaryCommonName == "Hinoki Cypress")
        #expect(profile.commonNames.contains("Hinoki"))
        #expect(profile.commonNames.contains("Japanese Hinoki Cypress"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Chamaecyparis obtusa (Hinoki)"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis lawsoniana"))
        #expect(visible.localizedCaseInsensitiveContains("Thuja"))
        #expect(visible.localizedCaseInsensitiveContains("Juniperus"))
        #expect(visible.localizedCaseInsensitiveContains("fan-like sprays"))
        #expect(visible.localizedCaseInsensitiveContains("bare old interior wood"))
        #expect(visible.localizedCaseInsensitiveContains("Do not apply broadleaf defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("winter desiccation"))
        #expect(visible.localizedCaseInsensitiveContains("should not be managed as a drought-tolerant juniper"))
    }

    @Test func cryptomeriaJaponicaProfileIsCompleteJapaneseCedarIdentity() {
        let profile = CryptomeriaJaponicaSpeciesProfile.profile
        #expect(profile.scientificName == "Cryptomeria japonica")
        #expect(profile.primaryCommonName == "Japanese Cedar")
        #expect(profile.commonNames.contains("Japanese Cryptomeria"))
        #expect(profile.commonNames.contains("Sugi"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Conifer")
        #expect(profile.originSummary == "Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Required")
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Intermediate")
        #expect(profile.traits.beginnerSuitability == "Moderate")
        #expect(profile.traits.growthStrength == "Moderate to Strong")
        #expect(profile.traits.growthSpeed == "Moderate")
        #expect(profile.traits.leafSize == "Evergreen conifer · Awl-shaped foliage arranged densely around the shoots")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Moderate to Good")
        #expect(profile.traits.rootDevelopment == "Good")
        #expect(profile.traits.nebariPotential == "Good potential")
        #expect(profile.traits.trunkDevelopment == "Moderate")
        #expect(profile.traits.barkDevelopment == "Excellent mature character")
        #expect(profile.traits.wiring == "Good")
        #expect(profile.traits.defoliation == "Not applicable")
        #expect(profile.traits.rootFrostSensitivity == "Moderate in shallow bonsai containers during prolonged severe freezing")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cryptomeria japonica"))
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Cedrus"))
        #expect(visible.localizedCaseInsensitiveContains("not a true cedar"))
        #expect(visible.localizedCaseInsensitiveContains("fibrous bark"))
        #expect(visible.localizedCaseInsensitiveContains("awl-shaped"))
        #expect(visible.localizedCaseInsensitiveContains("interior foliage"))
        #expect(visible.localizedCaseInsensitiveContains("Do not use uniform hedge-like shearing"))
        #expect(visible.localizedCaseInsensitiveContains("Do not artificially damage healthy bark"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Do not assume that completely bare old wood"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("prolonged severe freezing"))
        #expect(visible.localizedCaseInsensitiveContains("Produces cones"))
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "bark-trunk" })
    }

    @Test func cupressusArizonicaProfileIsCompleteArizonaCypressIdentity() {
        let profile = CupressusArizonicaSpeciesProfile.profile
        #expect(CupressusArizonicaSpeciesProfile.botanicalLibraryName == "Cupressus arizonica")
        #expect(profile.scientificName == "Cupressus arizonica")
        #expect(profile.primaryCommonName == "Arizona Cypress")
        #expect(profile.commonNames == ["Arizona Cypress"])
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "Southwestern United States and northern Mexico.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Good")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low to Moderate")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cupressus arizonica"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.cupressusArizonica)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.cupressusMacrocarpa)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Hesperocyparis"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus macrocarpa"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus sempervirens"))
        #expect(visible.localizedCaseInsensitiveContains("Leyland"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis"))
        #expect(visible.localizedCaseInsensitiveContains("glaucous"))
        #expect(visible.localizedCaseInsensitiveContains("desert drought bonsai"))
        #expect(visible.localizedCaseInsensitiveContains("scale-like"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(profile.sections.contains { $0.id == "taxonomic-context" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func cupressusMacrocarpaProfileIsCompleteMontereyCypressIdentity() {
        let profile = CupressusMacrocarpaSpeciesProfile.profile
        #expect(CupressusMacrocarpaSpeciesProfile.botanicalLibraryName == "Cupressus macrocarpa")
        #expect(profile.scientificName == "Cupressus macrocarpa")
        #expect(profile.primaryCommonName == "Monterey Cypress")
        #expect(profile.commonNames == ["Monterey Cypress"])
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "A very restricted native range on the central California coast near Monterey.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Good — especially naturalistic and windswept designs")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cupressus macrocarpa"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.cupressusMacrocarpa)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.cupressusArizonica)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Hesperocyparis"))
        #expect(visible.localizedCaseInsensitiveContains("Monterey"))
        #expect(visible.localizedCaseInsensitiveContains("windswept"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus arizonica"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus sempervirens"))
        #expect(visible.localizedCaseInsensitiveContains("Leyland"))
        #expect(visible.localizedCaseInsensitiveContains("Nootka"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis"))
        #expect(visible.localizedCaseInsensitiveContains("vigorous"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(profile.sections.contains { $0.id == "taxonomic-context" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func cupressusSempervirensProfileIsCompleteItalianCypressIdentity() {
        let profile = CupressusSempervirensSpeciesProfile.profile
        #expect(CupressusSempervirensSpeciesProfile.botanicalLibraryName == "Cupressus sempervirens")
        #expect(profile.scientificName == "Cupressus sempervirens")
        #expect(profile.primaryCommonName == "Italian Cypress")
        #expect(profile.commonNames == ["Italian Cypress", "Mediterranean Cypress"])
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer")
        #expect(profile.originSummary == "The eastern Mediterranean region and adjacent western Asia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Good — upright, columnar and naturalistic forms where material supports them")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cupressus sempervirens"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.cupressusSempervirens)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.cupressusMacrocarpa)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("Mediterranean"))
        #expect(visible.localizedCaseInsensitiveContains("columnar"))
        #expect(visible.localizedCaseInsensitiveContains("universal for the species"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus arizonica"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus macrocarpa"))
        #expect(visible.localizedCaseInsensitiveContains("Leyland"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis"))
        #expect(visible.localizedCaseInsensitiveContains("scale-like"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(profile.sections.contains { $0.id == "taxonomic-context" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func cupressusLeylandiiProfileIsCompleteLeylandCypressIdentity() {
        let profile = CupressusLeylandiiSpeciesProfile.profile
        #expect(CupressusLeylandiiSpeciesProfile.botanicalLibraryName == "Cupressus x Leylandii")
        #expect(profile.scientificName == "Cupressus × leylandii")
        #expect(profile.scientificName.contains("×"))
        #expect(profile.primaryCommonName == "Leyland Cypress")
        #expect(profile.commonNames == ["Leyland Cypress"])
        #expect(profile.synonyms.contains("Cupressus x Leylandii"))
        #expect(profile.synonyms.contains("× Cuprocyparis leylandii"))
        #expect(profile.family == "Cupressaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen conifer · Horticultural hybrid")
        #expect(profile.originSummary == "Artificial horticultural hybrid, historically associated with Cupressus macrocarpa and Nootka Cypress (Callitropsis/Chamaecyparis nootkatensis).")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Moderate — vigour and form dependent")
        #expect(profile.traits.difficulty == "Advanced")
        #expect(profile.traits.beginnerSuitability == "Low")
        #expect(profile.traits.backBudding == "Limited and unreliable from completely bare old wood")
        #expect(profile.traits.defoliation == "Not applicable as a routine technique")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cupressus x Leylandii"))
        #expect(profile.speciesID == BotanicalKnowledgeIDs.cupressusLeylandii)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.cupressusMacrocarpa)
        #expect(profile.speciesID != BotanicalKnowledgeIDs.chamaecyparisNootkatensis)
        #expect(profile.libraryCategory == .conifers)

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
                + profile.synonyms
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(visible.localizedCaseInsensitiveContains("horticultural hybrid"))
        #expect(visible.localizedCaseInsensitiveContains("Cupressus macrocarpa"))
        #expect(visible.localizedCaseInsensitiveContains("Nootka"))
        #expect(visible.localizedCaseInsensitiveContains("Cuprocyparis"))
        #expect(visible.localizedCaseInsensitiveContains("Hesperotropsis"))
        #expect(visible.localizedCaseInsensitiveContains("vigour"))
        #expect(visible.localizedCaseInsensitiveContains("Chamaecyparis"))
        #expect(visible.localizedCaseInsensitiveContains("Taxus"))
        #expect(visible.localizedCaseInsensitiveContains("old leafless wood"))
        #expect(visible.localizedCaseInsensitiveContains("bare old"))
        #expect(visible.localizedCaseInsensitiveContains("Do not recommend routine defoliation"))
        #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable"))
        #expect(visible.localizedCaseInsensitiveContains("universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 1 — Establishment"))
        #expect(visible.localizedCaseInsensitiveContains("Stage 7 — Maintenance"))
        #expect(profile.sections.contains { $0.id == "taxonomic-context" })
        #expect(profile.sections.contains { $0.id == "deadwood-potential" })
        #expect(profile.sections.contains { $0.id == "trunk-development" })
        #expect(profile.sections.contains { $0.id == "cultivars" })
    }

    @Test func rhododendronIndicumProfileIsCompleteSatsukiAzaleaIdentity() {
        let profile = RhododendronIndicumSpeciesProfile.profile
        #expect(profile.scientificName == "Rhododendron indicum")
        #expect(profile.primaryCommonName == "Satsuki Azalea")
        #expect(profile.commonNames.contains("Japanese Azalea"))
        #expect(profile.family == "Ericaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen to semi-evergreen flowering shrub")
        #expect(profile.originSummary == "Japan.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.rootDevelopment == "Fine and fibrous")
        #expect(profile.traits.rootFrostSensitivity == "High in shallow bonsai containers")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Rhododendron indicum"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "flower-management" })
        #expect(visible.localizedCaseInsensitiveContains("evergreen to semi-evergreen"))
        #expect(visible.localizedCaseInsensitiveContains("Kinsai"))
        #expect(visible.localizedCaseInsensitiveContains("not botanically identical"))
        #expect(visible.localizedCaseInsensitiveContains("acidic"))
        #expect(visible.localizedCaseInsensitiveContains("Water quality"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Older branches may become increasingly rigid"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai containers expose roots"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func chaenomelesJaponicaProfileIsCompleteJapaneseQuinceIdentity() {
        let profile = ChaenomelesJaponicaSpeciesProfile.profile
        #expect(profile.scientificName == "Chaenomeles japonica")
        #expect(profile.primaryCommonName == "Japanese Quince")
        #expect(profile.commonNames.contains("Japanese Flowering Quince"))
        #expect(profile.commonNames.contains("Dwarf Japanese Quince"))
        #expect(profile.family == "Rosaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering shrub")
        #expect(profile.originSummary == "Japan.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Good")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.rootDevelopment == "Strong")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Chaenomeles japonica"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "fruit" })
        #expect(profile.sections.contains { $0.id == "thorns" })
        #expect(visible.localizedCaseInsensitiveContains("Chaenomeles speciosa"))
        #expect(visible.contains("Chaenomeles × superba"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat all flowering quince as identical"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Older branches may become increasingly rigid and brittle"))
        #expect(visible.localizedCaseInsensitiveContains("Flower buds may be vulnerable to damaging late frost"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func wisteriaFloribundaProfileIsCompleteJapaneseWisteriaIdentity() {
        let profile = WisteriaFloribundaSpeciesProfile.profile
        #expect(profile.scientificName == "Wisteria floribunda")
        #expect(profile.primaryCommonName == "Japanese Wisteria")
        #expect(profile.family == "Fabaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering woody climber")
        #expect(profile.originSummary == "Japan.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.growthStrength == "Very Strong")
        #expect(profile.traits.growthSpeed == "Fast")
        #expect(profile.traits.ramificationPotential == "Good with correct management")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Wisteria floribunda"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "flower-management" })
        #expect(profile.sections.contains { $0.id == "fruit" })
        #expect(visible.localizedCaseInsensitiveContains("Wisteria sinensis"))
        #expect(visible.localizedCaseInsensitiveContains("woody climber"))
        #expect(visible.localizedCaseInsensitiveContains("Do not promise flowering after a specific number of years"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("vigorous seasonal thickening"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func forsythiaIntermediaProfileIsCompleteHybridForsythiaIdentity() {
        let profile = ForsythiaIntermediaSpeciesProfile.profile
        #expect(profile.scientificName == "Forsythia × intermedia")
        #expect(profile.primaryCommonName == "Forsythia")
        #expect(profile.commonNames.contains("Border Forsythia"))
        #expect(profile.commonNames.contains("Hybrid Forsythia"))
        #expect(profile.family == "Oleaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering shrub · Hybrid")
        #expect(profile.originSummary == "Horticultural hybrid of East Asian parent species.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Good to Excellent")
        #expect(profile.traits.growthStrength == "Strong")
        #expect(profile.traits.growthSpeed == "Fast")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Forsythia × intermedia"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "flower-management" })
        #expect(visible.contains("Forsythia × intermedia"))
        #expect(visible.localizedCaseInsensitiveContains("Forsythia suspensa"))
        #expect(visible.localizedCaseInsensitiveContains("Forsythia viridissima"))
        #expect(visible.localizedCaseInsensitiveContains("horticultural hybrid"))
        #expect(visible.localizedCaseInsensitiveContains("not a naturally occurring independent botanical species"))
        #expect(visible.localizedCaseInsensitiveContains("Do not treat back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Flowers generally appear on wood formed during the previous"))
        #expect(visible.localizedCaseInsensitiveContains("Flower buds can be vulnerable"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func cotoneasterHorizontalisProfileIsCompleteRocksprayIdentity() {
        let profile = CotoneasterHorizontalisSpeciesProfile.profile
        #expect(profile.scientificName == "Cotoneaster horizontalis")
        #expect(profile.primaryCommonName == "Rockspray Cotoneaster")
        #expect(profile.commonNames.contains("Wall Cotoneaster"))
        #expect(profile.family == "Rosaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Deciduous flowering and fruiting shrub")
        #expect(profile.originSummary == "China.")
        #expect(profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Cotoneaster horizontalis"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "fruit" })
        #expect(visible.localizedCaseInsensitiveContains("herringbone"))
        #expect(visible.localizedCaseInsensitiveContains("other Cotoneaster species"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Heavy fruit production can consume resources"))
        #expect(visible.localizedCaseInsensitiveContains("Older branches become progressively less flexible"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func pyracanthaCoccineaProfileIsCompleteScarletFirethornIdentity() {
        let profile = PyracanthaCoccineaSpeciesProfile.profile
        #expect(profile.scientificName == "Pyracantha coccinea")
        #expect(profile.primaryCommonName == "Scarlet Firethorn")
        #expect(profile.commonNames.contains("Firethorn"))
        #expect(profile.family == "Rosaceae")
        #expect(profile.cultivarID == nil)
        #expect(profile.knowledgeStatus == .reviewed)
        #expect(profile.plantType == "Evergreen to semi-evergreen thorny shrub")
        #expect(profile.originSummary == "Southern Europe and parts of western Asia.")
        #expect(!profile.traits.deciduous)
        #expect(profile.traits.winterDormancyRequired)
        #expect(profile.traits.winterHardiness == "Seasonal rest required in temperate climates")
        #expect(profile.traits.bonsaiSuitability == "Excellent")
        #expect(profile.traits.ramificationPotential == "Excellent")
        #expect(profile.traits.backBudding == "Good under healthy conditions")
        #expect(profile.traits.defoliation == "Not routine management")
        #expect(profile.speciesID == SpeciesPreviewData.id(named: "Pyracantha coccinea"))

        let visible = (
            [
                profile.scientificName,
                profile.primaryCommonName,
                profile.family,
                profile.plantType,
                profile.originSummary,
                profile.summaryLine,
                profile.principleNote,
                profile.sourcesNote,
            ]
                + profile.attentionHighlights
                + profile.sections.flatMap(\.paragraphs)
                + profile.sections.flatMap(\.bullets)
        ).joined(separator: "\n")
        for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
            #expect(!visible.contains(forbidden))
        }
        #expect(profile.sections.contains { $0.id == "cultivars" })
        #expect(profile.sections.contains { $0.id == "thorns" })
        #expect(profile.sections.contains { $0.id == "fruit" })
        #expect(visible.localizedCaseInsensitiveContains("Do not assume all Firethorn sold in nurseries"))
        #expect(visible.localizedCaseInsensitiveContains("uniformly evergreen"))
        #expect(visible.localizedCaseInsensitiveContains("Do not describe back-budding as guaranteed"))
        #expect(visible.localizedCaseInsensitiveContains("Do not present complete defoliation as standard"))
        #expect(visible.localizedCaseInsensitiveContains("Do not water according to a fixed timetable"))
        #expect(visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil recipe"))
        #expect(visible.localizedCaseInsensitiveContains("Heavy fruit production can consume substantial resources"))
        #expect(visible.localizedCaseInsensitiveContains("Thorns must be considered during wiring"))
        #expect(visible.localizedCaseInsensitiveContains("Shallow bonsai roots are more exposed"))
        #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
    }

    @Test func batchNordicAndGardenSpeciesProfilesAreReviewedAndLinked() {
        let profiles: [(SpeciesProfile, String, UUID)] = [
            (BerberisThunbergiiSpeciesProfile.profile, "Berberis thunbergii", BotanicalKnowledgeIDs.berberisThunbergii),
            (BerberisVulgarisSpeciesProfile.profile, "Berberis vulgaris", BotanicalKnowledgeIDs.berberisVulgaris),
            (CedrusAtlanticaSpeciesProfile.profile, "Cedrus atlantica", BotanicalKnowledgeIDs.cedrusAtlantica),
            (CedrusDeodaraSpeciesProfile.profile, "Cedrus deodara", BotanicalKnowledgeIDs.cedrusDeodara),
            (CedrusLibaniSpeciesProfile.profile, "Cedrus libani", BotanicalKnowledgeIDs.cedrusLibani),
            (CorylusAvellanaSpeciesProfile.profile, "Corylus avellana", BotanicalKnowledgeIDs.corylusAvellana),
            (FicusCaricaSpeciesProfile.profile, "Ficus carica", BotanicalKnowledgeIDs.ficusCarica),
            (FicusMicrocarpaSpeciesProfile.profile, "Ficus microcarpa", BotanicalKnowledgeIDs.ficusMicrocarpa),
            (FraxinusExcelsiorSpeciesProfile.profile, "Fraxinus excelsior", BotanicalKnowledgeIDs.fraxinusExcelsior),
            (IlexAquifoliumSpeciesProfile.profile, "Ilex aquifolium", BotanicalKnowledgeIDs.ilexAquifolium),
            (IlexCrenataSpeciesProfile.profile, "Ilex crenata", BotanicalKnowledgeIDs.ilexCrenata),
            (LigustrumOvalifoliumSpeciesProfile.profile, "Ligustrum ovalifolium", BotanicalKnowledgeIDs.ligustrumOvalifolium),
            (LigustrumVulgareSpeciesProfile.profile, "Ligustrum vulgare", BotanicalKnowledgeIDs.ligustrumVulgare),
            (MetasequoiaGlyptostroboidesSpeciesProfile.profile, "Metasequoia glyptostroboides", BotanicalKnowledgeIDs.metasequoiaGlyptostroboides),
            (PopulusTremulaSpeciesProfile.profile, "Populus tremula", BotanicalKnowledgeIDs.populusTremula),
            (PrunusAviumSpeciesProfile.profile, "Prunus avium", BotanicalKnowledgeIDs.prunusAvium),
            (PrunusMumeSpeciesProfile.profile, "Prunus mume", BotanicalKnowledgeIDs.prunusMume),
            (PrunusPadusSpeciesProfile.profile, "Prunus padus", BotanicalKnowledgeIDs.prunusPadus),
            (PrunusSpinosaSpeciesProfile.profile, "Prunus spinosa", BotanicalKnowledgeIDs.prunusSpinosa),
            (PunicaGranatumSpeciesProfile.profile, "Punica granatum", BotanicalKnowledgeIDs.punicaGranatum),
            (PyrusCommunisSpeciesProfile.profile, "Pyrus communis", BotanicalKnowledgeIDs.pyrusCommunis),
            (SalixAlbaSpeciesProfile.profile, "Salix alba", BotanicalKnowledgeIDs.salixAlba),
            (SalixBabylonicaSpeciesProfile.profile, "Salix babylonica", BotanicalKnowledgeIDs.salixBabylonica),
            (SalixCapreaSpeciesProfile.profile, "Salix caprea", BotanicalKnowledgeIDs.salixCaprea),
            (SambucusNigraSpeciesProfile.profile, "Sambucus nigra", BotanicalKnowledgeIDs.sambucusNigra),
            (SequoiaSempervirensSpeciesProfile.profile, "Sequoia sempervirens", BotanicalKnowledgeIDs.sequoiaSempervirens),
            (SerissaJaponicaSpeciesProfile.profile, "Serissa japonica", BotanicalKnowledgeIDs.serissaJaponica),
            (SorbusAucupariaSpeciesProfile.profile, "Sorbus aucuparia", BotanicalKnowledgeIDs.sorbusAucuparia),
            (StewartiaMonadelphaSpeciesProfile.profile, "Stewartia monadelpha", BotanicalKnowledgeIDs.stewartiaMonadelpha),
            (StewartiaPseudocamelliaSpeciesProfile.profile, "Stewartia pseudocamellia", BotanicalKnowledgeIDs.stewartiaPseudocamellia),
            (ThujaOccidentalisSpeciesProfile.profile, "Thuja occidentalis", BotanicalKnowledgeIDs.thujaOccidentalis),
            (ThujaPlicataSpeciesProfile.profile, "Thuja plicata", BotanicalKnowledgeIDs.thujaPlicata),
            (ViburnumOpulusSpeciesProfile.profile, "Viburnum opulus", BotanicalKnowledgeIDs.viburnumOpulus)
        ]
        for (profile, scientificName, speciesID) in profiles {
            #expect(profile.scientificName == scientificName)
            #expect(profile.cultivarID == nil)
            #expect(profile.knowledgeStatus == .reviewed)
            #expect(profile.speciesID == speciesID)
            #expect(profile.speciesID == SpeciesPreviewData.id(named: scientificName))
            let visible = (
                [profile.scientificName, profile.primaryCommonName, profile.family, profile.summaryLine, profile.principleNote]
                    + profile.attentionHighlights
                    + profile.sections.flatMap(\.paragraphs)
            ).joined(separator: "\n")
            for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
                #expect(!visible.contains(forbidden))
            }
            #expect(visible.localizedCaseInsensitiveContains("fixed watering timetable") || visible.localizedCaseInsensitiveContains("Avoid fixed watering"))
            #expect(visible.localizedCaseInsensitiveContains("universal soil recipe") || visible.localizedCaseInsensitiveContains("Do not prescribe one universal soil"))
            #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
        }
    }


    @Test func batchTropicalIndoorSpeciesProfilesAreReviewedAndLinked() {
        let profiles: [(SpeciesProfile, String, UUID)] = [
            (FicusBenjaminaSpeciesProfile.profile, "Ficus benjamina", BotanicalKnowledgeIDs.ficusBenjamina),
            (FicusReligiosaSpeciesProfile.profile, "Ficus religiosa", BotanicalKnowledgeIDs.ficusReligiosa),
            (FicusRubiginosaSpeciesProfile.profile, "Ficus rubiginosa", BotanicalKnowledgeIDs.ficusRubiginosa),
            (SageretiaTheaSpeciesProfile.profile, "Sageretia thea", BotanicalKnowledgeIDs.sageretiaThea),
            (EhretiaMicrophyllaSpeciesProfile.profile, "Ehretia microphylla", BotanicalKnowledgeIDs.ehretiaMicrophylla),
            (ScheffleraArboricolaSpeciesProfile.profile, "Schefflera arboricola", BotanicalKnowledgeIDs.scheffleraArboricola),
            (BougainvilleaGlabraSpeciesProfile.profile, "Bougainvillea glabra", BotanicalKnowledgeIDs.bougainvilleaGlabra),
            (PortulacariaAfraSpeciesProfile.profile, "Portulacaria afra", BotanicalKnowledgeIDs.portulacariaAfra),
            (AdeniumObesumSpeciesProfile.profile, "Adenium obesum", BotanicalKnowledgeIDs.adeniumObesum),
            (LagerstroemiaIndicaSpeciesProfile.profile, "Lagerstroemia indica", BotanicalKnowledgeIDs.lagerstroemiaIndica),
            (MyrtusCommunisSpeciesProfile.profile, "Myrtus communis", BotanicalKnowledgeIDs.myrtusCommunis),
            (CitrusLimonSpeciesProfile.profile, "Citrus limon", BotanicalKnowledgeIDs.citrusLimon),
            (MurrayaPaniculataSpeciesProfile.profile, "Murraya paniculata", BotanicalKnowledgeIDs.murrayaPaniculata),
            (TamarindusIndicaSpeciesProfile.profile, "Tamarindus indica", BotanicalKnowledgeIDs.tamarindusIndica),
            (MalpighiaCoccigeraSpeciesProfile.profile, "Malpighia coccigera", BotanicalKnowledgeIDs.malpighiaCoccigera),
            (ConocarpusErectusSpeciesProfile.profile, "Conocarpus erectus", BotanicalKnowledgeIDs.conocarpusErectus),
            (BucidaSpinosaSpeciesProfile.profile, "Bucida spinosa", BotanicalKnowledgeIDs.bucidaSpinosa),
            (CrassulaOvataSpeciesProfile.profile, "Crassula ovata", BotanicalKnowledgeIDs.crassulaOvata),
            (PremnaMicrophyllaSpeciesProfile.profile, "Premna microphylla", BotanicalKnowledgeIDs.premnaMicrophylla),
            (TriphasiaTrifoliaSpeciesProfile.profile, "Triphasia trifolia", BotanicalKnowledgeIDs.triphasiaTrifolia),
            (SyzygiumPaniculatumSpeciesProfile.profile, "Syzygium paniculatum", BotanicalKnowledgeIDs.syzygiumPaniculatum),
            (PsidiumGuajavaSpeciesProfile.profile, "Psidium guajava", BotanicalKnowledgeIDs.psidiumGuajava),
            (JacarandaMimosifoliaSpeciesProfile.profile, "Jacaranda mimosifolia", BotanicalKnowledgeIDs.jacarandaMimosifolia)
        ]
        for (profile, scientificName, speciesID) in profiles {
            #expect(profile.scientificName == scientificName)
            #expect(profile.cultivarID == nil)
            #expect(profile.knowledgeStatus == .reviewed)
            #expect(profile.speciesID == speciesID)
            #expect(profile.speciesID == SpeciesPreviewData.id(named: scientificName))
            let visible = (
                [profile.scientificName, profile.primaryCommonName, profile.family, profile.summaryLine, profile.principleNote]
                    + profile.attentionHighlights
                    + profile.sections.flatMap(\.paragraphs)
            ).joined(separator: "\n")
            for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
                #expect(!visible.contains(forbidden))
            }
            #expect(visible.localizedCaseInsensitiveContains("fixed watering") || visible.localizedCaseInsensitiveContains("Avoid fixed watering"))
            #expect(visible.localizedCaseInsensitiveContains("universal soil"))
            #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
            #expect(visible.localizedCaseInsensitiveContains("frost") || visible.localizedCaseInsensitiveContains("warm"))
        }
    }

    @Test func batchSouthernHemisphereSpeciesProfilesAreReviewedAndLinked() {
        let profiles: [(SpeciesProfile, String, UUID)] = [
            (MetrosiderosExcelsaSpeciesProfile.profile, "Metrosideros excelsa", BotanicalKnowledgeIDs.metrosiderosExcelsa),
            (LeptospermumScopariumSpeciesProfile.profile, "Leptospermum scoparium", BotanicalKnowledgeIDs.leptospermumScoparium),
            (CallistemonCitrinusSpeciesProfile.profile, "Callistemon citrinus", BotanicalKnowledgeIDs.callistemonCitrinus),
            (MelaleucaQuinquenerviaSpeciesProfile.profile, "Melaleuca quinquenervia", BotanicalKnowledgeIDs.melaleucaQuinquenervia),
            (BanksiaIntegrifoliaSpeciesProfile.profile, "Banksia integrifolia", BotanicalKnowledgeIDs.banksiaIntegrifolia),
            (GrevilleaRobustaSpeciesProfile.profile, "Grevillea robusta", BotanicalKnowledgeIDs.grevilleaRobusta),
            (AraucariaAraucanaSpeciesProfile.profile, "Araucaria araucana", BotanicalKnowledgeIDs.araucariaAraucana),
            (NothofagusAntarcticaSpeciesProfile.profile, "Nothofagus antarctica", BotanicalKnowledgeIDs.nothofagusAntarctica),
            (EugeniaUnifloraSpeciesProfile.profile, "Eugenia uniflora", BotanicalKnowledgeIDs.eugeniaUniflora),
            (PhyllanthusMyrtifoliusSpeciesProfile.profile, "Phyllanthus myrtifolius", BotanicalKnowledgeIDs.phyllanthusMyrtifolius),
            (BurseraSimarubaSpeciesProfile.profile, "Bursera simaruba", BotanicalKnowledgeIDs.burseraSimaruba),
            (DelonixRegiaSpeciesProfile.profile, "Delonix regia", BotanicalKnowledgeIDs.delonixRegia),
            (SennaSurattensisSpeciesProfile.profile, "Senna surattensis", BotanicalKnowledgeIDs.sennaSurattensis),
            (TipuanaTipuSpeciesProfile.profile, "Tipuana tipu", BotanicalKnowledgeIDs.tipuanaTipu),
            (CasuarinaEquisetifoliaSpeciesProfile.profile, "Casuarina equisetifolia", BotanicalKnowledgeIDs.casuarinaEquisetifolia),
            (EucalyptusGunniiSpeciesProfile.profile, "Eucalyptus gunnii", BotanicalKnowledgeIDs.eucalyptusGunnii),
            (AcaciaBaileyanaSpeciesProfile.profile, "Acacia baileyana", BotanicalKnowledgeIDs.acaciaBaileyana),
            (SyzygiumAustraleSpeciesProfile.profile, "Syzygium australe", BotanicalKnowledgeIDs.syzygiumAustrale)
        ]
        for (profile, scientificName, speciesID) in profiles {
            #expect(profile.scientificName == scientificName)
            #expect(profile.cultivarID == nil)
            #expect(profile.knowledgeStatus == .reviewed)
            #expect(profile.speciesID == speciesID)
            #expect(profile.speciesID == SpeciesPreviewData.id(named: scientificName))
            let visible = (
                [profile.scientificName, profile.primaryCommonName, profile.family, profile.summaryLine, profile.principleNote]
                    + profile.attentionHighlights
                    + profile.sections.flatMap(\.paragraphs)
            ).joined(separator: "\n")
            for forbidden in ["Draft", "Under Review", "Coming Soon", "TODO", "TBD"] {
                #expect(!visible.contains(forbidden))
            }
            #expect(visible.localizedCaseInsensitiveContains("fixed watering") || visible.localizedCaseInsensitiveContains("Avoid fixed watering"))
            #expect(visible.localizedCaseInsensitiveContains("universal soil"))
            #expect(visible.localizedCaseInsensitiveContains("Care → Pest Management"))
            #expect(visible.localizedCaseInsensitiveContains("frost") || visible.localizedCaseInsensitiveContains("winter") || visible.localizedCaseInsensitiveContains("warm") || visible.localizedCaseInsensitiveContains("temperate"))
        }
    }

}
