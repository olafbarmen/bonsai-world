//
//  BonsaiWorldMobileApp.swift
//  Bonsai World
//
//  iPhone + iPad entry. Demo library only — no sync yet.
//

import SwiftUI

@main
struct BonsaiWorldMobileApp: App {
    @State private var library = DemoLibrary()

    var body: some Scene {
        WindowGroup {
            MobileRootView()
                .environment(library)
        }
    }
}
