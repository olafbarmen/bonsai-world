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
                        .overlay {
                            if library.isOpeningICloudLibrary {
                                ZStack {
                                    BonsaiWorldColors.canvas
                                    ProgressView("Opening iCloud library")
                                }
                                .ignoresSafeArea()
                            }
                        }
                        .onChange(of: scenePhase) { _, phase in
                            guard phase == .active else { return }
                            library.refreshFromDiskIfChanged()
                            guard MobileLibraryStore.locationPreference == .iCloud,
                                  !library.isUsingICloudDrive
                            else { return }
                            Task { @MainActor in
                                guard let iCloud = await MobileLibraryStore.iCloudDrive(),
                                      self.library?.isUsingICloudDrive == false
                                else { return }
                                self.library = DemoLibrary(store: iCloud)
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
}
