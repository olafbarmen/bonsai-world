//
//  ICloudLibraryPathTests.swift
//  Bonsai HubTests
//
//  Shared container path helpers used by iPhone to find Mac’s Trees.json.
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct ICloudLibraryPathTests {
    @Test func libraryRootFromTreesFileRequiresSharedContainerPath() {
        let valid = URL(fileURLWithPath:
            "/var/mobile/Library/Mobile Documents/iCloud~no~olafbarmen~BonsaiWorld/Documents/Bonsai World Library/Database/Trees.json"
        )
        let root = BonsaiWorldICloudLibrary.libraryRoot(containingTreesFile: valid)
        #expect(root?.lastPathComponent == BonsaiWorldICloudLibrary.libraryFolderName)

        let wrongName = URL(fileURLWithPath:
            "/var/mobile/Library/Mobile Documents/iCloud~no~olafbarmen~BonsaiWorld/Documents/Bonsai World Library/Database/Work.json"
        )
        #expect(BonsaiWorldICloudLibrary.libraryRoot(containingTreesFile: wrongName) == nil)

        let outsideContainer = URL(fileURLWithPath:
            "/tmp/Bonsai World Library/Database/Trees.json"
        )
        #expect(BonsaiWorldICloudLibrary.libraryRoot(containingTreesFile: outsideContainer) == nil)
    }

    @Test func materializeURLsAskContainerBeforeTreesFile() {
        let root = URL(fileURLWithPath:
            "/var/mobile/Library/Mobile Documents/iCloud~no~olafbarmen~BonsaiWorld/Documents/Bonsai World Library",
            isDirectory: true
        )
        let urls = BonsaiWorldICloudLibrary.materializeURLs(forLibraryRoot: root)
        #expect(urls.first?.lastPathComponent == "iCloud~no~olafbarmen~BonsaiWorld")
        #expect(urls.contains { $0.lastPathComponent == "Trees.json" })
        #expect(urls.firstIndex { $0.lastPathComponent == "iCloud~no~olafbarmen~BonsaiWorld" }!
            < urls.firstIndex { $0.lastPathComponent == "Trees.json" }!)
    }
}
