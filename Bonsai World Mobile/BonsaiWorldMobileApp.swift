//
//  BonsaiWorldMobileApp.swift
//  Bonsai World
//
//  iPhone + iPad entry. Local or iCloud library via DemoLibrary → MobileLibraryStore.
//  No CloudKit merge; ZIP remains the safety net.
//

import SwiftUI

@main
struct BonsaiWorldMobileApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var library: DemoLibrary?
    @State private var needsLibraryChoice = MobileLibraryStore.locationPreference == .undecided

    var body: some Scene {
        WindowGroup {
            Group {
                if let library {
                    MobileRootView()
                        .environment(library)
                        .task {
                            // Ensure Appearance theme from UserDefaults is applied at launch.
                            _ = MobileRegionalPreferences.shared
                            // onChange(scenePhase) skips the initial .active — pull shared catalog now.
                            library.pullSharedLibraryFromCloud(forceReload: true)
                        }
                        .overlay {
                            if library.isOpeningICloudLibrary {
                                ZStack {
                                    BonsaiWorldColors.canvas
                                    VStack(spacing: FaloSpacing.medium) {
                                        ProgressView("Opening iCloud library")
                                        Text("Waiting for Trees.json from iCloud. Demo data is not the shared library. Keep the app open — it will not switch to the On This iPhone copy.")
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                }
                                .ignoresSafeArea()
                                .task {
                                    await retryICloudLibraryIfStalled()
                                }
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .bonsaiMobileLibraryLocationDidChange)) { _ in
                            Task { @MainActor in
                                let store = await MobileLibraryStore.resolvedPreferred()
                                self.library = DemoLibrary(store: store)
                            }
                        }
                        .onChange(of: scenePhase) { _, phase in
                            guard phase == .active else { return }
                            Task { @MainActor in
                                await attachICloudStoreIfNeeded()
                                // Always force a Trees.json pull when returning to the app on iCloud.
                                self.library?.pullSharedLibraryFromCloud(forceReload: true)
                            }
                        }
                } else if needsLibraryChoice {
                    MobileICloudLibraryPrompt { preference in
                        MobileLibraryStore.locationPreference = preference
                        needsLibraryChoice = false
                    }
                } else {
                    ProgressView()
                        .task {
                            let store = await MobileLibraryStore.resolvedPreferred()
                            library = DemoLibrary(store: store)
                        }
                }
            }
        }
    }

    /// Keep CloudDocs registered and retry the real container until Trees.json is listed.
    /// Device never falls back to On This iPhone here — that left testers on a stale 94-tree local copy
    /// while Mac had already written Winter to iCloud.
    @MainActor
    private func retryICloudLibraryIfStalled() async {
        while library?.isOpeningICloudLibrary == true {
            #if targetEnvironment(simulator)
            let seconds: UInt64 = 2
            #else
            let seconds: UInt64 = 5
            #endif
            try? await Task.sleep(nanoseconds: seconds * 1_000_000_000)
            guard library?.isOpeningICloudLibrary == true else { return }

            _ = await BonsaiWorldICloudLibrary.resolveLibraryRootURL(timeout: 30)

            if let iCloud = await MobileLibraryStore.iCloudDrive() {
                iCloud.requestFreshTreesDownload()
                let currentPath = library?.iCloudLibraryRootPath
                let newPath = iCloud.rootURL.standardizedFileURL.path
                if currentPath != newPath || iCloud.treesFileState() == .ready {
                    library = DemoLibrary(store: iCloud)
                    continue
                }
            }
            #if targetEnvironment(simulator)
            if library?.isOpeningICloudLibrary == true,
               await MobileLibraryStore.iCloudDrive() == nil {
                library = DemoLibrary(store: .applicationSupport())
                return
            }
            #endif
            library?.pullSharedLibraryFromCloud()
        }
    }

    @MainActor
    private func attachICloudStoreIfNeeded() async {
        guard MobileLibraryStore.locationPreference == .iCloud else { return }
        guard let iCloud = await MobileLibraryStore.iCloudDrive() else { return }
        if library?.isUsingICloudDrive == true,
           library?.iCloudLibraryRootPath == iCloud.rootURL.standardizedFileURL.path,
           library?.isOpeningICloudLibrary != true {
            return
        }
        if library?.isOpeningICloudLibrary == true, iCloud.treesFileState() != .ready,
           library?.iCloudLibraryRootPath == iCloud.rootURL.standardizedFileURL.path {
            iCloud.requestFreshTreesDownload()
            library?.pullSharedLibraryFromCloud()
            return
        }
        library = DemoLibrary(store: iCloud)
    }
}
