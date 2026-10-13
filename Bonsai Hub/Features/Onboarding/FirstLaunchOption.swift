//
//  FirstLaunchOption.swift
//  Bonsai World
//
//  Extensible catalog of First Launch Wizard choices.
//

import Foundation

/// One Welcome-screen choice. Availability gates future options.
struct FirstLaunchOption: Identifiable, Hashable, Sendable {
    let id: String
    var title: String
    var subtitle: String
    var systemImage: String
    var availability: ActionAvailability

    var isEnabled: Bool {
        if case .available = availability { return true }
        return false
    }
}

enum FirstLaunchOptionsCatalog {
    static let createNewID = "firstLaunch.createNew"
    static let openExistingID = "firstLaunch.openExisting"
    static let restoreBackupID = "firstLaunch.restoreBackup"
    static let createInICloudID = "firstLaunch.createInICloud"
    static let createSampleID = "firstLaunch.createSample"

    /// Primary actions shown on the Welcome screen (order matters).
    static var primaryOptions: [FirstLaunchOption] {
        var options: [FirstLaunchOption] = [
            FirstLaunchOption(
                id: createNewID,
                title: "I'm starting fresh",
                subtitle: "Create a new library for your trees.",
                systemImage: "leaf",
                availability: .available
            ),
            FirstLaunchOption(
                id: restoreBackupID,
                title: "I have a ZIP backup",
                subtitle: "Moved Mac, or restoring a safety copy.",
                systemImage: "doc.zipper",
                availability: .available
            ),
            FirstLaunchOption(
                id: openExistingID,
                title: "I already have a library on this Mac",
                subtitle: "Open a Bonsai World Library folder you already use.",
                systemImage: "folder",
                availability: .available
            )
        ]
        options.insert(
            FirstLaunchOption(
                id: createInICloudID,
                title: "Use iCloud with iPhone",
                subtitle: BonsaiWorldICloudLibrary.isAvailable
                    ? "Keep one library in iCloud for Mac and iPhone."
                    : "Sign in to iCloud on this Mac to enable.",
                systemImage: "icloud",
                availability: BonsaiWorldICloudLibrary.isAvailable ? .available : .comingSoon
            ),
            at: 1
        )
        return options
    }

    /// Reserved for later — rendered as disabled / Coming soon when shown.
    static var futureOptions: [FirstLaunchOption] {
        [
            FirstLaunchOption(
                id: createSampleID,
                title: "Create Sample Library",
                subtitle: "Start with example trees to explore the app.",
                systemImage: "square.stack.3d.up",
                availability: .comingSoon
            )
        ]
    }
}
