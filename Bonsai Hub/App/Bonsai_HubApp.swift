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
    @State private var referenceDataService: ReferenceDataService
    @State private var referenceDataManager: ReferenceDataManager
    @State private var botanicalService: BotanicalService
    @State private var storageService: StorageService
    @State private var libraryService: LibraryService
    @State private var imageService: ImageService
    @State private var imageImportService: ImageImportService
    @State private var treeService: TreeService
    @State private var measurementHistory: TreeMeasurementHistoryStore
    @State private var workService: WorkService
    @State private var growingIntelligence: GrowingIntelligenceService
    @State private var photoIndexStore: TreePhotoIndexStore
    @State private var bonsaiNameSequenceStore: BonsaiNameSequenceStore

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
        let referenceDataService = ReferenceDataService(previewData: referencePreviewData)
        let userProfile = UserProfileStore()

        _appState = State(initialValue: AppState())
        _userProfile = State(initialValue: userProfile)
        _appSettings = State(initialValue: AppSettings())
        _treeListColumnConfiguration = State(initialValue: TreeListColumnConfiguration())
        _previewData = State(initialValue: previewData)
        _referenceDataService = State(initialValue: referenceDataService)
        _referenceDataManager = State(
            initialValue: ReferenceDataManager(store: referencePreviewData)
        )
        _botanicalService = State(
            initialValue: BotanicalService(store: referencePreviewData)
        )
        _storageService = State(initialValue: storage)
        _libraryService = State(initialValue: library)
        _imageService = State(
            initialValue: ImageService(storage: storage, previewData: imageCatalog)
        )
        _imageImportService = State(
            initialValue: ImageImportService(storage: storage, imageCatalog: imageCatalog)
        )
        _treeService = State(initialValue: treeService)
        _measurementHistory = State(initialValue: measurementHistory)
        _photoIndexStore = State(initialValue: photoIndex)
        _bonsaiNameSequenceStore = State(initialValue: bonsaiNameSequences)
        _workService = State(
            initialValue: WorkService(referenceData: referenceDataService)
        )
        _growingIntelligence = State(
            initialValue: GrowingIntelligenceService(
                treeService: treeService,
                referenceData: referenceDataService,
                profile: userProfile
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
            .environment(imageImportService)
            .environment(treeService)
            .environment(measurementHistory)
            .environment(workService)
            .environment(growingIntelligence)
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
                    growingIntelligence = GrowingIntelligenceService(
                        treeService: service,
                        referenceData: referenceDataService,
                        profile: userProfile
                    )
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
                    .environment(imageImportService)
                    .environment(treeService)
                    .environment(measurementHistory)
                    .environment(workService)
                    .environment(growingIntelligence)
            }
        }
        .defaultSize(width: 1100, height: 760)
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
}
