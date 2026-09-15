//
//  BotanicalKnowledgeIDs.swift
//  Bonsai World
//
//  Permanent Botanical Library IDs for Species Knowledge profiles.
//  These UUIDs match the historical name-stable PreviewData seeds (list 2 / 3)
//  so existing Trees keep their links. Do not regenerate from display names —
//  renaming Reference Data must never change these constants.
//

import Foundation

/// Stable IDs linking Knowledge Species Profiles ↔ Botanical Library Species / Cultivar.
enum BotanicalKnowledgeIDs {
    // MARK: - Species (PreviewData list 2)

    static let abiesAlba = UUID(uuidString: "9eeedc52-a988-5f8b-a4e9-ca796c096b41")!
    static let abiesBalsamea = UUID(uuidString: "3ac851f9-7ae9-5bda-bc01-e9f6b964ce97")!
    static let abiesBorisiiRegis = UUID(uuidString: "af606130-e1af-5505-b46f-e4600ce455d7")!
    static let abiesConcolor = UUID(uuidString: "6dc6f397-3b4b-5262-97ba-be77a70eacf1")!
    static let abiesFirma = UUID(uuidString: "961751e0-b231-55af-843f-2546ac0907ef")!
    static let abiesGrandis = UUID(uuidString: "d797077c-e430-5c5f-9b1b-35004b64c599")!
    static let abiesKoreana = UUID(uuidString: "d659164c-f53f-5bd4-b54a-39ce8b45d7ab")!
    static let abiesLasiocarpa = UUID(uuidString: "31568791-1ca3-59b6-91d8-85fe62598bc1")!
    static let abiesNordmanniana = UUID(uuidString: "af5f854f-834e-5f4a-8419-ddde82c3ce36")!
    static let abiesPinsapo = UUID(uuidString: "05d46b2e-3282-58ee-92c3-b8da72c5b2c9")!
    static let abiesSachalinensis = UUID(uuidString: "9aae6e49-c767-5609-8f3b-1c6bc5c9173a")!
    static let abiesVeitchii = UUID(uuidString: "a68ebbb2-3d0f-5909-b0d0-a4499fbffad2")!
    static let acerBuergerianum = UUID(uuidString: "45c2e300-3af5-501b-ab63-c4b2de12a688")!
    static let acerCampestre = UUID(uuidString: "f24546f8-f9c5-5096-a840-0836c129123e")!
    static let acerGinnala = UUID(uuidString: "e4e73dc3-9872-5311-9bb9-89a852509fa8")!
    static let acerJaponicum = UUID(uuidString: "df56df6b-a07a-5e73-afa4-c988a3751ca7")!
    static let acerPalmatum = UUID(uuidString: "f25bcc54-1264-50ae-91f5-2e5de8c43532")!
    static let alnusGlutinosa = UUID(uuidString: "36f213ed-e550-5a57-bde5-12b64a014bcf")!
    static let alnusIncana = UUID(uuidString: "b51a0241-6e8d-5597-a856-d2758400d983")!
    static let betulaPendula = UUID(uuidString: "f922d562-acc7-53b2-8c4b-229663fc47ef")!
    static let betulaPubescens = UUID(uuidString: "d0cb8f80-fac6-57b5-acd5-a254ea283f67")!
    static let buxusSempervirens = UUID(uuidString: "e1266ab5-77a2-5143-817e-eb45a063e508")!
    static let carpinusBetulus = UUID(uuidString: "b2161372-2631-513c-8777-fd105e167a84")!
    static let carpinusCoreana = UUID(uuidString: "73f37bc2-cbb9-5df7-84d0-e1a8024e8767")!
    static let chaenomelesJaponica = UUID(uuidString: "f993dc76-84cf-5560-b04f-fa35c8ea3f8c")!
    static let chamaecyparisLawsoniana = UUID(uuidString: "96bf08ae-1e3f-5407-a4d4-7686494054b7")!
    static let chamaecyparisNootkatensis = UUID(uuidString: "f4a5882a-b598-5147-a3bc-87a1a887ed57")!
    static let chamaecyparisObtusa = UUID(uuidString: "db136059-6c2a-54fb-b542-8f965c608823")!
    static let chamaecyparisPisifera = UUID(uuidString: "93ec1a5f-02cf-5d93-a2a2-069b427b98d6")!
    static let cotoneasterHorizontalis = UUID(uuidString: "bca57f5e-8268-5c22-88df-e792cfca5346")!
    static let crataegusMonogyna = UUID(uuidString: "dc08e20a-310b-5dac-93ab-6b37575c5c8d")!
    static let cryptomeriaJaponica = UUID(uuidString: "3f6c85e3-8182-5e3a-b719-ee904c92f5c6")!
    static let cupressusArizonica = UUID(uuidString: "6d40134a-e892-548d-b349-94e21e8048b4")!
    static let cupressusLeylandii = UUID(uuidString: "0b7141df-42b2-55a6-b320-5fe18e818ff7")!
    static let cupressusMacrocarpa = UUID(uuidString: "7715a86a-abbb-5a20-830c-39d262f7c281")!
    static let cupressusSempervirens = UUID(uuidString: "b84c7313-5505-5430-be72-007256e1f666")!
    static let fagusSylvatica = UUID(uuidString: "faf5677b-4ca4-5f5c-b607-224abd5d6965")!
    static let forsythiaIntermedia = UUID(uuidString: "c9e6774a-a746-52de-b949-877459591a35")!
    static let ginkgoBiloba = UUID(uuidString: "caebafd8-bc70-5ae8-af7c-fbc866a7ef44")!
    static let juniperusChinensis = UUID(uuidString: "1ff518cd-f8c8-5b9a-96f4-bc2273a018cd")!
    static let juniperusCommunis = UUID(uuidString: "1cb34275-fbda-5d86-a54d-9b2697359d5d")!
    static let juniperusProcumbens = UUID(uuidString: "f782b768-37a0-556a-8dcb-97761675fa4c")!
    static let juniperusRigida = UUID(uuidString: "9015db2e-bd9f-5e58-9864-ccd75ef8172f")!
    static let juniperusSabina = UUID(uuidString: "85402864-9e58-5f74-a00f-572fa88fb4bc")!
    static let juniperusSquamata = UUID(uuidString: "630da61d-2635-5336-819c-dec3289f0c27")!
    static let larixDecidua = UUID(uuidString: "618b3dee-c529-58ea-997e-12f1848da8f0")!
    static let larixKaempferi = UUID(uuidString: "86670163-f0f3-5cc8-b209-713e0657da6d")!
    static let larixMarschlinsii = UUID(uuidString: "953b517f-88f6-5068-bd98-ae5e6ce98aea")!
    static let malusSylvestris = UUID(uuidString: "9f155f53-782b-5509-8c0f-1c82ceb5916b")!
    static let oleaEuropaea = UUID(uuidString: "5fb3a234-0fd0-5112-bbe2-0457da9354a1")!
    static let oleaEuropaeaVarSylvestris = UUID(uuidString: "fe1e251a-800a-5c57-8dd8-0e16ff944e53")!
    static let phillyreaAngustifolia = UUID(uuidString: "499751d3-a05d-54e1-954a-89bb729a1668")!
    static let piceaAbies = UUID(uuidString: "836f213a-85d0-5602-82a8-5efb884740ec")!
    static let piceaEngelmannii = UUID(uuidString: "4667ee09-2d9d-562b-8a33-84507c1d3462")!
    static let piceaGlauca = UUID(uuidString: "5b60d350-c1bd-5bda-abf6-1a34a32cfbcf")!
    static let piceaMariana = UUID(uuidString: "b0f99dac-dfe2-5252-88ad-cb41b78a5f85")!
    static let piceaOmorika = UUID(uuidString: "71d52e2e-4588-5adc-ae0a-446f69dd2c32")!
    static let piceaPungens = UUID(uuidString: "a85f7372-364f-5219-9d32-594a023a9500")!
    static let piceaSitchensis = UUID(uuidString: "9245e890-f451-55e0-9308-6b85a967208b")!
    static let pinusMugo = UUID(uuidString: "e5f67a42-e7ee-58a7-bc90-0cbf641b7817")!
    static let pinusParviflora = UUID(uuidString: "348aef03-c114-58f2-a84c-5e4f07896f82")!
    static let pinusSylvestris = UUID(uuidString: "12b5897d-9fa7-5934-af31-091c6e93d2d6")!
    static let pinusThunbergii = UUID(uuidString: "86f134e2-db11-5448-b0eb-0f5853cd093a")!
    static let pistaciaLentiscus = UUID(uuidString: "ff1134de-eb4c-571d-b5c4-6dd58bf279a0")!
    static let podocarpusMacrophyllus = UUID(uuidString: "8c0a78b1-5d68-50f9-8320-acb01380a028")!
    static let pyracanthaCoccinea = UUID(uuidString: "85bd912c-6330-5bce-bf8b-b9705b6565c5")!
    static let quercusIlex = UUID(uuidString: "744bdca1-dab0-5a64-87cd-a0f075b0da7a")!
    static let quercusRobur = UUID(uuidString: "683a1d18-1ab0-5d14-ac3e-3d9088926fb9")!
    static let quercusSuber = UUID(uuidString: "eb5ec11e-afc4-566e-86f1-6645b7f4b521")!
    static let rhododendronIndicum = UUID(uuidString: "84cffc4c-1c59-5eb8-98aa-7765ec459249")!
    static let taxusBaccata = UUID(uuidString: "6171cc13-67e7-584a-8c63-9abdf2b48ed5")!
    static let taxusCanadensis = UUID(uuidString: "298b3f22-cb84-59a5-a497-20396955eb5f")!
    static let taxusCuspidata = UUID(uuidString: "5d88ec82-bb3f-5295-a57b-b8298398c5b9")!
    static let taxusFloridana = UUID(uuidString: "ee8e0f67-59d7-51f4-a30c-5686801b9f9f")!
    static let taxusMedia = UUID(uuidString: "8a35b99c-177a-5abd-9184-0866ef53573e")!
    static let taxusWallichiana = UUID(uuidString: "bf9a202a-719c-51bb-a7ed-33fe7e9469ac")!
    static let tiliaCordata = UUID(uuidString: "11197e7f-0abf-5617-8d5a-365e39501c73")!
    static let ulmusMinor = UUID(uuidString: "2505b60d-7705-5c8f-88aa-5a4389532cb7")!
    static let ulmusParvifolia = UUID(uuidString: "05f9120d-0fc6-5b46-9083-9e79a5fe9236")!
    static let wisteriaFloribunda = UUID(uuidString: "5c048d34-275a-507c-af3a-b399b6b9fbe5")!
    static let zelkovaSerrata = UUID(uuidString: "ba3d5305-b604-5bfd-9806-bbff4a10c63a")!

    static let berberisThunbergii = UUID(uuidString: "26c85b36-48f4-540e-a2c1-338ada1c816e")!
    static let berberisVulgaris = UUID(uuidString: "2641cdd2-e4eb-5114-868a-4a85fe602694")!
    static let cedrusAtlantica = UUID(uuidString: "90e57ed4-3f42-5e56-b834-bbe24a5c47bd")!
    static let cedrusDeodara = UUID(uuidString: "d436de98-275b-5497-b1d2-f308bc09c9b9")!
    static let cedrusLibani = UUID(uuidString: "4f7daa42-8f4a-5fa5-9115-753f72bcd615")!
    static let corylusAvellana = UUID(uuidString: "b724bd37-a143-50c6-a482-29d5bec643f1")!
    static let ficusCarica = UUID(uuidString: "ffa825b0-f3e2-5e75-8394-abf32b346211")!
    static let ficusMicrocarpa = UUID(uuidString: "05083e9f-a41a-529d-9ccf-6e44b210cfe1")!
    static let fraxinusExcelsior = UUID(uuidString: "92fe1d43-8251-59e6-8263-478e1aedfbc5")!
    static let ilexAquifolium = UUID(uuidString: "14a359c5-9f03-5a4c-9708-678e6de70406")!
    static let ilexCrenata = UUID(uuidString: "cd12b23a-2bac-54e9-9db9-f682f2533c16")!
    static let ligustrumOvalifolium = UUID(uuidString: "843a6c4b-1bf6-5944-b605-795395f06d6d")!
    static let ligustrumVulgare = UUID(uuidString: "536fef75-a376-552d-8ca7-f027de109445")!
    static let metasequoiaGlyptostroboides = UUID(uuidString: "cdb9b0e1-e4ce-5514-8f65-efed957fde19")!
    static let populusTremula = UUID(uuidString: "2bf29963-8b15-57f4-bf68-f64289bc843b")!
    static let prunusAvium = UUID(uuidString: "a39acba2-7f51-5d9b-86b5-c19841fae1ce")!
    static let prunusMume = UUID(uuidString: "8fbed026-1f3c-55dd-bd49-52eae080323e")!
    static let prunusPadus = UUID(uuidString: "9804dbd4-db56-57e4-a2b0-15ebed5fdc87")!
    static let prunusSpinosa = UUID(uuidString: "dd85deb9-2f86-5bc1-be0b-8025b948ff26")!
    static let punicaGranatum = UUID(uuidString: "e6bbc433-8fa5-593a-b7d1-b34725284c62")!
    static let pyrusCommunis = UUID(uuidString: "108ab62d-6f2c-5cdd-83c7-fc893aba4724")!
    static let salixAlba = UUID(uuidString: "7fd4a7ac-3d99-579f-ad21-06dbfc7d45ab")!
    static let salixBabylonica = UUID(uuidString: "899f4468-c4d2-5471-8868-54b8b5d75db4")!
    static let salixCaprea = UUID(uuidString: "217b5e1e-80a1-5db2-82a2-ec40105cfa27")!
    static let sambucusNigra = UUID(uuidString: "7ab5989a-57f2-5915-ace4-c9827851581c")!
    static let sequoiaSempervirens = UUID(uuidString: "aa6f886b-6891-527a-a3f7-26fd5e141567")!
    static let serissaJaponica = UUID(uuidString: "d4389d64-ca48-50a8-b506-7facb6ea0b31")!
    static let sorbusAucuparia = UUID(uuidString: "f38b2caf-56b9-5f16-a12e-107a5fef8942")!
    static let stewartiaMonadelpha = UUID(uuidString: "45962737-d4e5-5f19-9230-d57509eb5404")!
    static let stewartiaPseudocamellia = UUID(uuidString: "69b46421-29c8-5940-858e-004c6bc1bf1b")!
    static let thujaOccidentalis = UUID(uuidString: "f5ca2e33-854d-5528-837c-85e606e3d206")!
    static let thujaPlicata = UUID(uuidString: "5ed5ba58-4e2d-5701-b632-b490ecfa8594")!
    static let viburnumOpulus = UUID(uuidString: "40def027-6298-5272-ae83-bafa49ac025c")!

    static let adeniumObesum = UUID(uuidString: "e872c617-eeda-536f-aab8-9fdb21074541")!
    static let bougainvilleaGlabra = UUID(uuidString: "d0e01da1-e227-54b2-860d-3f275dbb354a")!
    static let bucidaSpinosa = UUID(uuidString: "1f3bbaec-fb8a-5777-a403-1a20c8bc2f5a")!
    static let citrusLimon = UUID(uuidString: "ea81371d-3940-5ec8-ae5d-89a05b6aaaa0")!
    static let conocarpusErectus = UUID(uuidString: "90cecefb-8570-53d2-9fd0-47e0d153b1a5")!
    static let crassulaOvata = UUID(uuidString: "03978f39-224e-566b-844d-145520cf3827")!
    static let ehretiaMicrophylla = UUID(uuidString: "2bbeaf21-946b-5a02-bd85-2572f5b326fa")!
    static let ficusBenjamina = UUID(uuidString: "8cb21a6d-83cb-549f-ab60-5ce2d670c4b1")!
    static let ficusReligiosa = UUID(uuidString: "b8d11f61-5149-5d6e-b17d-463e27f4c159")!
    static let ficusRubiginosa = UUID(uuidString: "339cf1ee-33b9-51c9-a8c3-6c2ed9033810")!
    static let jacarandaMimosifolia = UUID(uuidString: "c2ee6fde-2dce-5ecd-bcfb-db3c94da0a8e")!
    static let lagerstroemiaIndica = UUID(uuidString: "7bef3e3e-b6d6-5fff-8119-dc276a4a75a9")!
    static let malpighiaCoccigera = UUID(uuidString: "6eb000a6-57a9-57cf-bccb-5a43733083b8")!
    static let murrayaPaniculata = UUID(uuidString: "49803494-08b7-507f-a1c8-d8a4a916ee49")!
    static let myrtusCommunis = UUID(uuidString: "8e96443d-9b21-5e9a-9701-4091712b9ef5")!
    static let portulacariaAfra = UUID(uuidString: "19111bf3-fbe1-5fcf-929c-333567a1407e")!
    static let premnaMicrophylla = UUID(uuidString: "def51594-5377-5d1b-bc80-9e775a18b43d")!
    static let psidiumGuajava = UUID(uuidString: "20639aa4-403b-5a00-9343-5b1fa4855ff3")!
    static let sageretiaThea = UUID(uuidString: "a2cd7955-e4ef-55ea-bee2-65d450858a6b")!
    static let scheffleraArboricola = UUID(uuidString: "22d92de3-da33-55cd-8411-29fdb047dcbf")!
    static let syzygiumPaniculatum = UUID(uuidString: "bf8cbb7e-d7db-5f95-803a-2c304c22b9fb")!
    static let tamarindusIndica = UUID(uuidString: "3cf9394b-da70-5745-9fdd-4b56c944369d")!
    static let triphasiaTrifolia = UUID(uuidString: "2a48de63-0fac-514d-b8f1-e840510fd025")!

    static let acaciaBaileyana = UUID(uuidString: "b5843e61-24eb-54eb-96f4-4412fe8a1c9d")!
    static let araucariaAraucana = UUID(uuidString: "1ede969c-9b1d-5aad-8654-ebc85d1c6950")!
    static let banksiaIntegrifolia = UUID(uuidString: "65acf544-8ab2-58f9-a7c6-82f2f376ef0e")!
    static let burseraSimaruba = UUID(uuidString: "dfac90ee-748b-5234-af85-37ae9e6c6eab")!
    static let callistemonCitrinus = UUID(uuidString: "6af7b0e4-2f1a-52f9-aeca-5439c01ccf82")!
    static let casuarinaEquisetifolia = UUID(uuidString: "e9b47b4a-4373-5048-b225-1cfdc57702c5")!
    static let delonixRegia = UUID(uuidString: "e1dc2ccb-4895-513c-8572-74f4b3c8af47")!
    static let eucalyptusGunnii = UUID(uuidString: "ecb4112c-9a4b-5250-9fd2-1f85be44723b")!
    static let eugeniaUniflora = UUID(uuidString: "bd502a16-e78a-5533-8928-29ad43231c82")!
    static let grevilleaRobusta = UUID(uuidString: "cd9c30b0-e79d-526f-9cd9-504641760141")!
    static let leptospermumScoparium = UUID(uuidString: "a5ca0feb-b376-5d6c-aecb-edbb71587a40")!
    static let melaleucaQuinquenervia = UUID(uuidString: "dd8870db-a8de-59b6-970a-da445b5f2255")!
    static let metrosiderosExcelsa = UUID(uuidString: "008a1ea6-8fd6-5cb0-9d14-a061f99f813c")!
    static let nothofagusAntarctica = UUID(uuidString: "dad61c32-c652-596d-8d00-65a68628475b")!
    static let phyllanthusMyrtifolius = UUID(uuidString: "88715fd7-e3cf-598f-aaa5-758d462ccfbd")!
    static let sennaSurattensis = UUID(uuidString: "db0387a4-6b20-5288-86bd-16a6d3ead1b4")!
    static let syzygiumAustrale = UUID(uuidString: "afaa5e34-d956-5bf2-8bdd-a5e7b48f111c")!
    static let tipuanaTipu = UUID(uuidString: "2ee1eb4e-e3ee-5e78-adb7-36e75def8527")!

    // MARK: - Cultivars (PreviewData list 3)

    static let juniperusChinensisBlaauw = UUID(uuidString: "f66a179c-28e9-5dc1-8029-34875cd9976c")!
    static let juniperusChinensisItoigawa = UUID(uuidString: "a1cfc2f5-1783-5c46-a936-14a9a07faba8")!
    static let juniperusChinensisKishu = UUID(uuidString: "56c391ef-0ff2-58ec-944c-76a1a89ddc50")!
    static let juniperusChinensisShimpaku = UUID(uuidString: "87f8d6b8-dea9-5ee0-8e20-a2ea0976603a")!
    static let juniperusChinensisStricta = UUID(uuidString: "eb166a11-16ff-563d-b109-de3d6bbb7277")!
    static let juniperusProcumbensGreenMound = UUID(uuidString: "f1fbdd0e-73e4-5f3b-83f3-72ccbf73e2c2")!
    static let juniperusSquamataBlueStar = UUID(uuidString: "7b9cc065-a129-56ae-a131-36d160fc0627")!
}
