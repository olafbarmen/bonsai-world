//
//  ICloudTreesCatalogLocator.swift
//  Bonsai World
//
//  Finds Database/Trees.json in the shared iCloud Documents container.
//  CloudDocs often has no local placeholder until a metadata query lists the file;
//  startDownloadingUbiquitousItem on a guessed path is then a no-op.
//

import Foundation

/// Discovers the Mac catalog via NSMetadataQuery (Apple’s iCloud Drive recipe).
final class ICloudTreesCatalogLocator: NSObject {
    private var query: NSMetadataQuery?
    var onFoundTreesFile: ((URL) -> Void)?

    func start() {
        guard query == nil else { return }
        let query = NSMetadataQuery()
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.predicate = NSPredicate(format: "%K == %@", NSMetadataItemFSNameKey, "Trees.json")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(queryDidChange(_:)),
            name: .NSMetadataQueryDidFinishGathering,
            object: query
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(queryDidChange(_:)),
            name: .NSMetadataQueryDidUpdate,
            object: query
        )
        self.query = query
        query.start()
        print("Bonsai World: started iCloud Trees.json metadata query")
    }

    func stop() {
        guard let query else { return }
        query.stop()
        NotificationCenter.default.removeObserver(self, name: .NSMetadataQueryDidFinishGathering, object: query)
        NotificationCenter.default.removeObserver(self, name: .NSMetadataQueryDidUpdate, object: query)
        self.query = nil
    }

    @objc private func queryDidChange(_ notification: Notification) {
        guard let query else { return }
        query.disableUpdates()
        defer { query.enableUpdates() }
        for raw in query.results {
            guard let item = raw as? NSMetadataItem,
                  let url = item.value(forAttribute: NSMetadataItemURLKey) as? URL,
                  BonsaiWorldICloudLibrary.libraryRoot(containingTreesFile: url) != nil
            else { continue }
            CloudDownload.forceRequest(url)
            let status = item.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String
            let ready = status == NSMetadataUbiquitousItemDownloadingStatusCurrent
                || status == NSMetadataUbiquitousItemDownloadingStatusDownloaded
                || FileManager.default.fileExists(atPath: url.path)
            if ready {
                print("Bonsai World: metadata query found Trees.json")
                onFoundTreesFile?(url)
                return
            }
            print("Bonsai World: metadata query listed Trees.json — downloading")
        }
    }

    deinit {
        stop()
    }
}
