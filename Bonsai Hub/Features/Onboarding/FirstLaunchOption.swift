//
//  FirstLaunchOption.swift
//  Bonsai World
//
//  Extensible catalog of First Launch Wizard choices.
//  Add future options here (iCloud, Restore Backup, Sample Library) without redesigning the welcome UI.
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
    static let createInICloudID = "firstLaunch.createInICloud"
    static let restoreBackupID = "firstLaunch.restoreBackup"
    static let createSampleID = "firstLaunch.createSample"

    /// Primary actions shown on the Welcome screen (order matters).
    static var primaryOptions: [FirstLaunchOption] {
        [
            FirstLaunchOption(
                id: createNewID,
                title: "Create New Library",
                subtitle: "Choose a folder and create a Bonsai World Library.",
                systemImage: "plus.rectangle.on.folder",
                availability: .available
            ),
            FirstLaunchOption(
                id: openExistingID,
                title: "Open Existing Library",
                subtitle: "Select a Bonsai World Library you already have.",
                systemImage: "folder",
                availability: .available
            )
        ]
    }

    /// Reserved for later — rendered as disabled / Coming soon when shown.
    static var futureOptions: [FirstLaunchOption] {
        [
            FirstLaunchOption(
                id: createInICloudID,
                title: "Create in iCloud Drive",
                subtitle: "Keep your library in iCloud for Mac and iPhone.",
                systemImage: "icloud",
                availability: .comingSoon
            ),
            FirstLaunchOption(
                id: restoreBackupID,
                title: "Restore Backup",
                subtitle: "Restore from a Bonsai World backup.",
                systemImage: "arrow.counterclockwise",
                availability: .comingSoon
            ),
            FirstLaunchOption(
                id: createSampleID,
                title: "Create Sample Library",
                subtitle: "Start with example trees to explore the app.",
                systemImage: "leaf",
                availability: .comingSoon
            )
        ]
    }
}
