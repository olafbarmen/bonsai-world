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
    @State private var measurementHistory: TreeMeasurementHistoryStore
    @State private var workService: WorkService
    @State private var taskService: TaskService
    @State private var growingIntelligence: GrowingIntelligenceService
    @State private var weatherService: WeatherService
    @State private var photoIndexStore: TreePhotoIndexStore
    @State private var bonsaiNameSequenceStore: BonsaiNameSequenceStore
    @State private var careNotificationService: CareNotificationService

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
        let gardenRepository = Self.makeGardenRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let locationRepository = Self.makeLocationRepository(
            storage: storage,
            libraryReady: library.isLibraryReady,
            referencePreviewData: referencePreviewData
        )

        let referenceDataService = ReferenceDataService(previewData: referencePreviewData)
        let userProfile = UserProfileStore(gardenRepository: gardenRepository)

        _appState = State(initialValue: AppState())
        _userProfile = State(initialValue: userProfile)
        _appSettings = State(initialValue: AppSettings())
        _treeListColumnConfiguration = State(initialValue: TreeListColumnConfiguration())
        _previewData = State(initialValue: previewData)
        _referencePreviewData = State(initialValue: referencePreviewData)
        _referenceDataService = State(initialValue: referenceDataService)
        _referenceDataManager = State(
            initialValue: ReferenceDataManager(store: referencePreviewData, locationRepository: locationRepository)
        )
        let botanicalService = BotanicalService(store: referencePreviewData)
        _botanicalService = State(initialValue: botanicalService)
        _storageService = State(initialValue: storage)
        _libraryService = State(initialValue: library)
        let imageService = ImageService(storage: storage, previewData: imageCatalog)
        _imageService = State(initialValue: imageService)
        _galleryService = State(
            initialValue: GalleryService(imageService: imageService, treeService: treeService)
        )
        _imageImportService = State(
            initialValue: ImageImportService(storage: storage, imageCatalog: imageCatalog)
        )
        _treeService = State(initialValue: treeService)
        _measurementHistory = State(initialValue: measurementHistory)
        _photoIndexStore = State(initialValue: photoIndex)
        _bonsaiNameSequenceStore = State(initialValue: bonsaiNameSequences)
        let workRepository = Self.makeWorkRepository(
            storage: storage,
            libraryReady: library.isLibraryReady
        )
        let workService = WorkService(referenceData: referenceDataService, workRepository: workRepository)
        _workService = State(initialValue: workService)
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

    var body: some Scene {
        WindowGroup {
            Group {
                if libraryService.isLibraryReady {
                    ContentView()
                } else {
                    FirstLaunchWizardView()
                }
            }
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
            .environment(measurementHistory)
            .environment(workService)
            .environment(taskService)
            .environment(growingIntelligence)
            .environment(weatherService)
            .task(id: taskService.revision) {
                careNotificationService.refresh()
            }
            .onChange(of: libraryService.isLibraryReady) { wasReady, isReady in
                guard isReady, !wasReady else { return }
                Task { @MainActor in
                    bonsaiNameSequenceStore.setLibraryPersistenceEnabled(true)
                    let service = Self.makeTreeService(
                        previewData: previewData,
                        storage: storageService,
                        libraryReady: true,
                        photoIndex: photoIndexStore,
                        bonsaiNameSequences: bonsaiNameSequenceStore
                    )
                    treeService = service
                    imageService.attachStorage(storageService)
                    galleryService = GalleryService(imageService: imageService, treeService: service)
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

                    let locationRepository = Self.makeLocationRepository(
                        storage: storageService,
                        libraryReady: true,
                        referencePreviewData: referencePreviewData
                    )
                    referenceDataManager.attachLibraryLocationRepository(locationRepository)

                    let workRepository = Self.makeWorkRepository(
                        storage: storageService,
                        libraryReady: true
                    )
                    workService.attachLibraryWorkRepository(workRepository)

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
                }
            }
        }

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
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(taskService)
                    .environment(growingIntelligence)
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
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(taskService)
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
            }
        }
        .defaultSize(width: 1180, height: 780)
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
