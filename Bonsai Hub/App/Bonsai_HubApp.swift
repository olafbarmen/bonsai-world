//
//  Bonsai_HubApp.swift
//  Bonsai World
//

import SwiftUI

@main
struct Bonsai_HubApp: App {
    @State private var appState: AppState
    @State private var appSettings: AppSettings
    @State private var treeListColumnConfiguration: TreeListColumnConfiguration
    @State private var userProfile: UserProfileStore
    @State private var previewData: PreviewData
    @State private var referencePreviewData: ReferencePreviewData
    @State private var referenceDataService: ReferenceDataService
    @State private var referenceDataManager: ReferenceDataManager
    @State private var botanicalService: BotanicalService
    @State private var storageService: StorageService
    @State private var libraryService: LibraryService
    @State private var imageService: ImageService
    @State private var galleryService: GalleryService
    @State private var imageImportService: ImageImportService
    @State private var treeService: TreeService
    @State private var potService: PotService
    @State private var yamadoriService: YamadoriService
    @State private var seedStratificationCatalog: SeedStratificationCatalogService
    @State private var seedBatchService: SeedBatchService
    @State private var nurseryPropagationService: NurseryPropagationService
    @State private var mediaLibraryService: MediaLibraryService
    @State private var knowledgeResourceService: KnowledgeResourceService
    @State private var simpleCatalogService: SimpleCatalogService
    @State private var soilStockService: SoilStockService
    @State private var inventoryStockService: InventoryStockService
    @State private var measurementHistory: TreeMeasurementHistoryStore
    @State private var workService: WorkService
    @State private var journalService: JournalService
    @State private var taskService: TaskService
    @State private var growingIntelligence: GrowingIntelligenceService
    @State private var weatherService: WeatherService
    @State private var photoIndexStore: TreePhotoIndexStore
    @State private var bonsaiNameSequenceStore: BonsaiNameSequenceStore
    @State private var careNotificationService: CareNotificationService
    @State private var winterCareService: WinterCareService
    @State private var springCareService: SpringCareService
    @State private var greenhouseCareService: GreenhouseCareService
    @State private var fertilizerBagsService: FertilizerBagsService
    @State private var repottingCareService: RepottingCareService

    init() {
        let previewData = PreviewData()
        let referencePreviewData = ReferencePreviewData()
        let storage = StorageService.shared
        let library = LibraryService(storage: storage)
        // Open last/default library when valid; otherwise First Launch Wizard.
        library.resolveLaunchLibrary()

        let imageCatalog = ImagePreviewData(storage: storage)
        let photoIndex = TreePhotoIndexStore(storage: storage)
        let bonsaiNameSequences = BonsaiNameSequenceStore(
            storage: storage,
            libraryPersistenceEnabled: library.isLibraryReady
        )
        let measurementHistory = TreeMeasurementHistoryStore(storage: storage)
        let treeService = Self.makeTreeService(
            previewData: previewData,
            storage: storage,
            libraryReady: library.isLibraryReady,
            photoIndex: photoIndex,
            bonsaiNameSequences: bonsaiNameSequences
        )
        treeService.repairBotanicalIdentity(
            genera: referencePreviewData.genus,
            species: referencePreviewData.species,
            cultivars: referencePreviewData.cultivars
        )
        treeService.reconcileMeasurementDimensions(using: measurementHistory)
        _ = TreeStageMigrationService.migrateIfNeeded(
            treeService: treeService,
            referencePreviewData: referencePreviewData
        )
        let gardenRepository = Self.makeGardenRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let locationRepository = Self.makeLocationRepository(
            storage: storage,
            libraryReady: library.isLibraryReady,
            referencePreviewData: referencePreviewData
        )
        let potBrandRepository = Self.makePotBrandRepository(
            storage: storage,
            libraryReady: library.isLibraryReady,
            referencePreviewData: referencePreviewData
        )

        let referenceDataService = ReferenceDataService(previewData: referencePreviewData)
        let userProfile = UserProfileStore(gardenRepository: gardenRepository)
        if library.isLibraryReady {
            userProfile.attachLibraryProfileStorage(storage)
        }

        let appSettings = AppSettings()
        _appState = State(initialValue: AppState())
        _userProfile = State(initialValue: userProfile)
        _appSettings = State(initialValue: appSettings)
        _treeListColumnConfiguration = State(initialValue: TreeListColumnConfiguration())
        _previewData = State(initialValue: previewData)
        _referencePreviewData = State(initialValue: referencePreviewData)
        _referenceDataService = State(initialValue: referenceDataService)
        let referenceDataManager = ReferenceDataManager(
            store: referencePreviewData,
            locationRepository: locationRepository,
            potBrandRepository: potBrandRepository
        )
        _referenceDataManager = State(initialValue: referenceDataManager)
        let botanicalService = BotanicalService(store: referencePreviewData)
        _botanicalService = State(initialValue: botanicalService)
        _storageService = State(initialValue: storage)
        _libraryService = State(initialValue: library)
        let imageService = ImageService(storage: storage, previewData: imageCatalog)
        _imageService = State(initialValue: imageService)
        _imageImportService = State(
            initialValue: ImageImportService(storage: storage, imageCatalog: imageCatalog)
        )
        _treeService = State(initialValue: treeService)
        let potRepository = Self.makePotRepository(storage: storage, libraryReady: library.isLibraryReady)
        let potService = PotService(repository: potRepository, treeService: treeService)
        _potService = State(initialValue: potService)
        let yamadoriRepository = Self.makeYamadoriRepository(storage: storage, libraryReady: library.isLibraryReady)
        let yamadoriService = YamadoriService(repository: yamadoriRepository, treeService: treeService)
        _yamadoriService = State(initialValue: yamadoriService)
        let seedStratificationCatalog = SeedStratificationCatalogService()
        _seedStratificationCatalog = State(initialValue: seedStratificationCatalog)
        _measurementHistory = State(initialValue: measurementHistory)
        _photoIndexStore = State(initialValue: photoIndex)
        _bonsaiNameSequenceStore = State(initialValue: bonsaiNameSequences)
        let workRepository = Self.makeWorkRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let workService = WorkService(referenceData: referenceDataService, workRepository: workRepository)
        _workService = State(initialValue: workService)
        let journalRepository = Self.makeJournalRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _journalService = State(initialValue: JournalService(journalRepository: journalRepository))
        let taskRepository = Self.makeTaskRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let scheduleRepository = Self.makeScheduleRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let taskService = TaskService(
            referenceData: referenceDataService,
            workService: workService,
            treeService: treeService,
            botanicalService: botanicalService,
            taskRepository: taskRepository,
            scheduleRepository: scheduleRepository
        )
        _taskService = State(initialValue: taskService)
        _winterCareService = State(
            initialValue: WinterCareService(
                treeService: treeService,
                taskService: taskService,
                workService: workService,
                appSettings: appSettings
            )
        )
        _springCareService = State(
            initialValue: SpringCareService(
                treeService: treeService,
                taskService: taskService,
                workService: workService,
                appSettings: appSettings
            )
        )
        _greenhouseCareService = State(
            initialValue: GreenhouseCareService(
                referenceData: referenceDataService,
                referenceDataManager: referenceDataManager,
                taskService: taskService,
                workService: workService,
                appSettings: appSettings
            )
        )
        _fertilizerBagsService = State(
            initialValue: FertilizerBagsService(
                treeService: treeService,
                taskService: taskService,
                workService: workService,
                appSettings: appSettings
            )
        )
        _repottingCareService = State(
            initialValue: RepottingCareService(
                treeService: treeService,
                taskService: taskService,
                workService: workService
            )
        )
        let seedBatchRepository = Self.makeSeedBatchRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _seedBatchService = State(
            initialValue: SeedBatchService(
                repository: seedBatchRepository,
                catalog: seedStratificationCatalog,
                treeService: treeService,
                taskService: taskService,
                referenceData: referenceDataService
            )
        )
        let nurseryPropagationRepository = Self.makeNurseryPropagationRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _nurseryPropagationService = State(
            initialValue: NurseryPropagationService(
                repository: nurseryPropagationRepository,
                treeService: treeService,
                referenceData: referenceDataService,
                taskService: taskService
            )
        )
        let mediaLibraryRepository = Self.makeMediaLibraryRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _mediaLibraryService = State(
            initialValue: MediaLibraryService(repository: mediaLibraryRepository)
        )
        let knowledgeResourceRepository = Self.makeKnowledgeResourceRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _knowledgeResourceService = State(
            initialValue: KnowledgeResourceService(repository: knowledgeResourceRepository)
        )
        let simpleCatalogRepository = Self.makeSimpleCatalogRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        _simpleCatalogService = State(
            initialValue: SimpleCatalogService(repository: simpleCatalogRepository)
        )
        let soilStockRepository = Self.makeSoilStockRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let soilStockService = SoilStockService(
            repository: soilStockRepository,
            taskService: taskService,
            referenceData: referenceDataService
        )
        _soilStockService = State(initialValue: soilStockService)
        let inventoryStockRepository = Self.makeInventoryStockRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let inventoryStockService = InventoryStockService(repository: inventoryStockRepository)
        _inventoryStockService = State(initialValue: inventoryStockService)
        _galleryService = State(
            initialValue: GalleryService(
                imageService: imageService,
                treeService: treeService,
                yamadoriService: yamadoriService,
                potService: potService,
                soilStockService: soilStockService,
                inventoryStockService: inventoryStockService,
                userProfile: userProfile
            )
        )
        _growingIntelligence = State(
            initialValue: GrowingIntelligenceService(
                treeService: treeService,
                referenceData: referenceDataService,
                profile: userProfile
            )
        )
        let weatherService = WeatherService(profile: userProfile)
        weatherService.startAutoRefresh()
        _weatherService = State(initialValue: weatherService)
        _careNotificationService = State(
            initialValue: CareNotificationService(
                taskService: taskService,
                scheduler: MacCareNotificationScheduler()
            )
        )
    }

    /// Changes when Winter/Spring/Greenhouse Care scope or settings change — keeps system Tasks in sync.
    private var seasonalCareSyncToken: String {
        let treesKey = treeService.trees
            .map {
                "\($0.id.uuidString):\($0.placementStrategy.rawValue):\($0.seasonPlacement.rawValue):\($0.winterCareCompletedSteps.map(\.rawValue).joined(separator: ",")):\($0.springCareCompletedSteps.map(\.rawValue).joined(separator: ",")):\($0.lastFertilizerBagReplacedAt?.timeIntervalSince1970 ?? -1)"
            }
            .sorted()
            .joined(separator: "|")
        let locationsKey = referenceDataService.locations
            .map {
                "\($0.id.uuidString):\($0.environment.setting?.rawValue ?? ""):\($0.greenhouseSpringCheckYear.map(String.init) ?? "nil")"
            }
            .sorted()
            .joined(separator: "|")
        let weatherKey = weatherService.snapshot.map { String($0.fetchedAt.timeIntervalSince1970) } ?? "nil"
        // Do not include taskService.revision — sync writes Tasks and would loop forever.
        return "\(treesKey)|\(locationsKey)|\(referenceDataManager.revision)|\(weatherKey)|\(appSettings.winterCareReminderMonth)|\(appSettings.winterCareReminderDay)|\(appSettings.winterCareFrostCelsius)|\(appSettings.springCareReminderMonth)|\(appSettings.springCareReminderDay)|\(appSettings.greenhouseSpringReminderMonth)|\(appSettings.greenhouseSpringReminderDay)|\(appSettings.fertilizerBagsIntervalWeeks)"
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if libraryService.isLibraryReady {
            ContentView()
                } else {
                    FirstLaunchWizardView()
                }
            }
                .id(appSettings.theme)
                .bonsaiWorldChrome()
                .environment(appState)
            .environment(appSettings)
            .environment(treeListColumnConfiguration)
            .environment(userProfile)
            .environment(previewData)
            .environment(referenceDataService)
            .environment(referenceDataManager)
            .environment(botanicalService)
            .environment(storageService)
            .environment(libraryService)
            .environment(imageService)
            .environment(galleryService)
            .environment(imageImportService)
            .environment(treeService)
            .environment(potService)
            .environment(yamadoriService)
            .environment(seedStratificationCatalog)
            .environment(seedBatchService)
            .environment(nurseryPropagationService)
            .environment(mediaLibraryService)
            .environment(knowledgeResourceService)
            .environment(simpleCatalogService)
            .environment(soilStockService)
            .environment(inventoryStockService)
            .environment(measurementHistory)
            .environment(workService)
            .environment(journalService)
            .environment(taskService)
            .environment(winterCareService)
            .environment(springCareService)
            .environment(greenhouseCareService)
            .environment(fertilizerBagsService)
            .environment(repottingCareService)
            .environment(growingIntelligence)
            .environment(weatherService)
            .task(id: taskService.revision) {
                careNotificationService.refresh()
            }
            .task(id: seasonalCareSyncToken) {
                try? winterCareService.syncWinterCareTask(snapshot: weatherService.snapshot)
                try? springCareService.syncSpringCareTask()
                try? greenhouseCareService.syncGreenhouseSpringCheckTask()
                try? fertilizerBagsService.syncFertilizerBagsTask()
            }
            .task {
                // Cold launch with an already-open library never fires isLibraryReady onChange.
                // Only attach profile storage — full session attach is for library switches / ZIP restore.
                if libraryService.isLibraryReady {
                    userProfile.attachLibraryProfileStorage(storageService)
                }
            }
            .onChange(of: libraryService.isLibraryReady) { wasReady, isReady in
                guard isReady, !wasReady else { return }
                Task { @MainActor in
                    attachActiveLibrarySession()
                }
            }
            .onChange(of: libraryService.librarySessionRevision) { _, _ in
                guard libraryService.isLibraryReady else { return }
                Task { @MainActor in
                    attachActiveLibrarySession()
                }
            }
        }
        .windowResizability(.contentMinSize)
        .defaultSize(width: 1280, height: 840)

        WindowGroup(id: TreeImageViewerContext.windowID, for: TreeImageViewerContext.self) { $context in
            if let context {
                TreeImageViewerView(context: context)
                    .environment(imageService)
            }
        }
        .defaultSize(width: 960, height: 720)

        // Tree Workspace — full Bonsai World window per Tree (Blueprint §5.2.2–§5.2.4).
        // Shared Library / TreeService; independent AppState lives inside TreeWorkspaceWindowView.
        WindowGroup(id: TreeWorkspaceWindowContext.windowID, for: TreeWorkspaceWindowContext.self) { $context in
            if let context {
                TreeWorkspaceWindowView(treeID: context.treeID)
                    .id(appSettings.theme)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 1100, height: 760)

        // Yamadori trip workspace — full Bonsai World window per trip.
        WindowGroup(id: YamadoriTripWorkspaceWindowContext.windowID, for: YamadoriTripWorkspaceWindowContext.self) { $context in
            if let context {
                YamadoriTripWorkspaceWindowView(tripID: context.tripID)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 1100, height: 760)

        // Cuttings / Air Layers / Grafting — dedicated window per project (double-click).
        WindowGroup(id: NurseryPropagationWorkspaceWindowContext.windowID, for: NurseryPropagationWorkspaceWindowContext.self) { $context in
            if let context {
                NurseryPropagationWorkspaceWindowView(kind: context.kind, projectID: context.projectID)
                    .id(appSettings.theme)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 900, height: 700)

        // Seed Batch workspace — dedicated window per batch (double-click from list).
        WindowGroup(id: SeedBatchWorkspaceWindowContext.windowID, for: SeedBatchWorkspaceWindowContext.self) { $context in
            if let context {
                SeedBatchWorkspaceWindowView(batchID: context.batchID)
                    .id(appSettings.theme)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 900, height: 700)

        // Yamadori Find workspace — full Bonsai World window per Find.
        WindowGroup(id: YamadoriFindWorkspaceWindowContext.windowID, for: YamadoriFindWorkspaceWindowContext.self) { $context in
            if let context {
                YamadoriFindWorkspaceWindowView(findID: context.findID, tripID: context.tripID)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 1100, height: 760)

        // Image Workspace — full Bonsai World window per image (Blueprint §5.5).
        WindowGroup(id: ImageWorkspaceWindowContext.windowID, for: ImageWorkspaceWindowContext.self) { $context in
            if let context {
                ImageWorkspaceWindowView(imageID: context.imageID)
                    .environment(appSettings)
                    .environment(treeListColumnConfiguration)
                    .environment(userProfile)
                    .environment(previewData)
                    .environment(referenceDataService)
                    .environment(referenceDataManager)
                    .environment(botanicalService)
                    .environment(storageService)
                    .environment(libraryService)
                    .environment(imageService)
                    .environment(galleryService)
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(potService)
                    .environment(yamadoriService)
                    .environment(seedStratificationCatalog)
                    .environment(seedBatchService)
                    .environment(nurseryPropagationService)
                    .environment(mediaLibraryService)
                    .environment(knowledgeResourceService)
                    .environment(simpleCatalogService)
                    .environment(soilStockService)
                    .environment(inventoryStockService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(journalService)
                    .environment(taskService)
                    .environment(winterCareService)
                    .environment(fertilizerBagsService)
                    .environment(springCareService)
                    .environment(greenhouseCareService)
            .environment(repottingCareService)
                    .environment(growingIntelligence)
                    .environment(weatherService)
            }
        }
        .defaultSize(width: 1100, height: 760)

        // Crop Workspace — focused non-destructive crop for one Original (Blueprint §5.5).
        WindowGroup(id: CropWorkspaceWindowContext.windowID, for: CropWorkspaceWindowContext.self) { $context in
            if let context {
                CropWorkspaceView(imageID: context.imageID)
                    .environment(imageService)
                    .environment(appSettings)
                    .bonsaiWorldChrome()
            }
        }
        .defaultSize(width: 1180, height: 780)
    }

    @MainActor
    private func attachActiveLibrarySession() {
        bonsaiNameSequenceStore.setLibraryPersistenceEnabled(true)
        let service = Self.makeTreeService(
            previewData: previewData,
            storage: storageService,
            libraryReady: true,
            photoIndex: photoIndexStore,
            bonsaiNameSequences: bonsaiNameSequenceStore
        )
        service.repairBotanicalIdentity(
            genera: referencePreviewData.genus,
            species: referencePreviewData.species,
            cultivars: referencePreviewData.cultivars
        )
        treeService = service
        let potRepository = Self.makePotRepository(storage: storageService, libraryReady: true)
        potService = PotService(repository: potRepository, treeService: service)
        let yamadoriRepository = Self.makeYamadoriRepository(storage: storageService, libraryReady: true)
        yamadoriService = YamadoriService(repository: yamadoriRepository, treeService: service)
        imageService.attachStorage(storageService)
        growingIntelligence = GrowingIntelligenceService(
            treeService: service,
            referenceData: referenceDataService,
            profile: userProfile
        )

        let gardenRepository = Self.makeGardenRepository(
            storage: storageService,
            libraryReady: true
        )
        userProfile.attachLibraryGardenRepository(gardenRepository)
        userProfile.attachLibraryProfileStorage(storageService)

        let locationRepository = Self.makeLocationRepository(
            storage: storageService,
            libraryReady: true,
            referencePreviewData: referencePreviewData
        )
        referenceDataManager.attachLibraryLocationRepository(locationRepository)

        let potBrandRepository = Self.makePotBrandRepository(
            storage: storageService,
            libraryReady: true,
            referencePreviewData: referencePreviewData
        )
        referenceDataManager.attachLibraryPotBrandRepository(potBrandRepository)

        let workRepository = Self.makeWorkRepository(
            storage: storageService,
            libraryReady: true
        )
        workService.attachLibraryWorkRepository(workRepository)

        let journalRepository = Self.makeJournalRepository(
            storage: storageService,
            libraryReady: true
        )
        journalService.attachLibraryJournalRepository(journalRepository)

        let taskRepository = Self.makeTaskRepository(
            storage: storageService,
            libraryReady: true
        )
        taskService.attachLibraryTaskRepository(taskRepository)

        let scheduleRepository = Self.makeScheduleRepository(
            storage: storageService,
            libraryReady: true
        )
        taskService.attachLibraryScheduleRepository(scheduleRepository)

        seedBatchService = SeedBatchService(
            repository: Self.makeSeedBatchRepository(storage: storageService, libraryReady: true),
            catalog: seedStratificationCatalog,
            treeService: service,
            taskService: taskService,
            referenceData: referenceDataService
        )
        nurseryPropagationService = NurseryPropagationService(
            repository: Self.makeNurseryPropagationRepository(storage: storageService, libraryReady: true),
            treeService: service,
            referenceData: referenceDataService,
            taskService: taskService
        )
        mediaLibraryService.attachRepository(
            Self.makeMediaLibraryRepository(storage: storageService, libraryReady: true)
        )
        knowledgeResourceService.attachRepository(
            Self.makeKnowledgeResourceRepository(storage: storageService, libraryReady: true)
        )
        simpleCatalogService.attachRepository(
            Self.makeSimpleCatalogRepository(storage: storageService, libraryReady: true)
        )
        soilStockService = SoilStockService(
            repository: Self.makeSoilStockRepository(storage: storageService, libraryReady: true),
            taskService: taskService,
            referenceData: referenceDataService
        )
        inventoryStockService = InventoryStockService(
            repository: Self.makeInventoryStockRepository(storage: storageService, libraryReady: true)
        )
        galleryService = GalleryService(
            imageService: imageService,
            treeService: service,
            yamadoriService: yamadoriService,
            potService: potService,
            soilStockService: soilStockService,
            inventoryStockService: inventoryStockService,
            userProfile: userProfile
        )

        photoIndexStore.reload()
        measurementHistory.reload()
        bonsaiNameSequenceStore.reload()
        service.reconcileMeasurementDimensions(using: measurementHistory)
    }

    // MARK: - Repository bootstrap

    /// Preview catalog only before a library exists; library-backed once a library is ready.
    private static func makeTreeService(
        previewData: PreviewData,
        storage: StorageService,
        libraryReady: Bool,
        photoIndex: TreePhotoIndexStore,
        bonsaiNameSequences: BonsaiNameSequenceStore
    ) -> TreeService {
        let repository = makeTreeRepository(
            storage: storage,
            libraryReady: libraryReady,
            previewData: previewData,
            bonsaiNameSequences: bonsaiNameSequences
        )
        let collectionRepository = makeCollectionRepository(
            storage: storage,
            libraryReady: libraryReady,
            previewData: previewData
        )
        return TreeService(
            repository: repository,
            collectionRepository: collectionRepository,
            photoIndex: photoIndex,
            bonsaiNameSequences: bonsaiNameSequences
        )
    }

    private static func makeTreeRepository(
        storage: StorageService,
        libraryReady: Bool,
        previewData: PreviewData,
        bonsaiNameSequences: BonsaiNameSequenceStore
    ) -> any TreeRepository {
        guard libraryReady else {
            return PreviewTreeRepository(previewData: previewData)
        }

        let previewRepository = PreviewTreeRepository(previewData: previewData)
        let libraryRepository = LibraryTreeRepository(storage: storage)
        _ = TreeMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepository,
            libraryRepository: libraryRepository,
            bonsaiNameSequences: bonsaiNameSequences
        )
        return libraryRepository
    }

    private static func makeCollectionRepository(
        storage: StorageService,
        libraryReady: Bool,
        previewData: PreviewData
    ) -> any CollectionRepository {
        guard libraryReady else {
            return PreviewCollectionRepository(previewData: previewData)
        }

        let previewRepository = PreviewCollectionRepository(previewData: previewData)
        let libraryRepository = LibraryCollectionRepository(storage: storage)
        _ = CollectionMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepository,
            libraryRepository: libraryRepository
        )
        return libraryRepository
    }

    /// Preview/UserDefaults-backed only before a library exists; library-backed once ready.
    private static func makeGardenRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any GardenRepository {
        let userDefaultsRepository = UserDefaultsGardenRepository()
        guard libraryReady else {
            return userDefaultsRepository
        }

        let libraryRepository = LibraryGardenRepository(storage: storage)
        _ = GardenMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            sourceRepository: userDefaultsRepository,
            libraryRepository: libraryRepository
        )
        return libraryRepository
    }

    /// Preview catalog only before a library exists; library-backed once ready.
    /// Syncs `referencePreviewData.locations` from disk so `ReferenceDataService`'s
    /// direct in-memory reads reflect the persisted (possibly just-migrated) catalog.
    private static func makeLocationRepository(
        storage: StorageService,
        libraryReady: Bool,
        referencePreviewData: ReferencePreviewData
    ) -> any LocationRepository {
        let previewRepository = PreviewLocationRepository(store: referencePreviewData)
        guard libraryReady else {
            return previewRepository
        }

        let libraryRepository = LibraryLocationRepository(storage: storage)
        _ = LocationMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepository,
            libraryRepository: libraryRepository
        )
        referencePreviewData.locations = libraryRepository.getAllLocations()
        return libraryRepository
    }

    /// In-memory only before a library exists (no legacy data to migrate); library-backed
    /// once ready. Same shape as Garden/Location, minus a migration step.
    private static func makeWorkRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any WorkRepository {
        guard libraryReady else {
            return PreviewWorkRepository()
        }
        return LibraryWorkRepository(storage: storage)
    }

    private static func makeJournalRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any JournalRepository {
        guard libraryReady else {
            return PreviewJournalRepository()
        }
        return LibraryJournalRepository(storage: storage)
    }

    /// In-memory only before a library exists (no legacy data to migrate); library-backed
    /// once ready. Same shape as Work — Pot is a brand-new entity with no legacy data.
    private static func makePotRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any PotRepository {
        guard libraryReady else {
            return PreviewPotRepository()
        }
        return LibraryPotRepository(storage: storage)
    }

    private static func makeYamadoriRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any YamadoriRepository {
        guard libraryReady else {
            return PreviewYamadoriRepository()
        }
        return LibraryYamadoriRepository(storage: storage)
    }

    private static func makeSeedBatchRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any SeedBatchRepository {
        guard libraryReady else {
            return PreviewSeedBatchRepository()
        }
        return LibrarySeedBatchRepository(storage: storage)
    }

    private static func makeNurseryPropagationRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any NurseryPropagationRepository {
        guard libraryReady else {
            return PreviewNurseryPropagationRepository()
        }
        return LibraryNurseryPropagationRepository(storage: storage)
    }

    private static func makeMediaLibraryRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any MediaLibraryRepository {
        guard libraryReady else {
            return PreviewMediaLibraryRepository()
        }
        return LibraryMediaLibraryRepository(storage: storage)
    }

    private static func makeKnowledgeResourceRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any KnowledgeResourceRepository {
        guard libraryReady else {
            return PreviewKnowledgeResourceRepository()
        }
        return LibraryKnowledgeResourceRepository(storage: storage)
    }

    private static func makeSimpleCatalogRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any SimpleCatalogRepository {
        guard libraryReady else {
            return PreviewSimpleCatalogRepository()
        }
        return LibrarySimpleCatalogRepository(storage: storage)
    }

    private static func makeSoilStockRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any SoilStockRepository {
        guard libraryReady else {
            return PreviewSoilStockRepository()
        }
        return LibrarySoilStockRepository(storage: storage)
    }

    private static func makeInventoryStockRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any InventoryStockRepository {
        guard libraryReady else {
            return PreviewInventoryStockRepository()
        }
        return LibraryInventoryStockRepository(storage: storage)
    }

    /// Preview catalog only before a library exists; library-backed once ready.
    /// Seeds curated Brand/Maker reference data on first library attach when the
    /// catalog file is absent. Never overwrites an existing user catalog.
    private static func makePotBrandRepository(
        storage: StorageService,
        libraryReady: Bool,
        referencePreviewData: ReferencePreviewData
    ) -> any PotBrandRepository {
        let previewRepository = PreviewPotBrandRepository(store: referencePreviewData)
        guard libraryReady else {
            return previewRepository
        }

        let libraryRepository = LibraryPotBrandRepository(storage: storage)
        _ = PotBrandMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepository,
            libraryRepository: libraryRepository
        )
        referencePreviewData.potBrands = libraryRepository.getAllBrands()
        referencePreviewData.potMakers = libraryRepository.getAllMakers()
        return libraryRepository
    }

    /// In-memory only before a library exists (no legacy data to migrate); library-backed
    /// once ready. Same shape as Work.
    private static func makeTaskRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any TaskRepository {
        guard libraryReady else {
            return PreviewTaskRepository()
        }
        return LibraryTaskRepository(storage: storage)
    }

    /// In-memory only before a library exists (no legacy data to migrate); library-backed
    /// once ready. Same shape as Task/Work.
    private static func makeScheduleRepository(
        storage: StorageService,
        libraryReady: Bool
    ) -> any ScheduleRepository {
        guard libraryReady else {
            return PreviewScheduleRepository()
        }
        return LibraryScheduleRepository(storage: storage)
    }
}
