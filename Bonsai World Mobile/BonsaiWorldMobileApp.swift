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
    @State private var library: DemoLibrary?
    @State private var needsLibraryChoice = MobileLibraryStore.locationPreference == .undecided

    var body: some Scene {
        WindowGroup {
            Group {
                if let library {
                    MobileRootView()
                        .environment(library)
                } else if needsLibraryChoice {
                    MobileICloudLibraryPrompt { preference in
                        MobileLibraryStore.locationPreference = preference
                        needsLibraryChoice = false
                        library = DemoLibrary(store: .resolvedPreferred())
                    }
                } else {
                    ProgressView()
                        .task {
                            library = DemoLibrary(store: .resolvedPreferred())
                        }
                }
            }
        }
    }
}
