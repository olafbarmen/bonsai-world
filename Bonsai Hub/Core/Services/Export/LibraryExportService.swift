//
//  LibraryExportService.swift
//  Bonsai World
//
//  Phase 1 export — whole library to ZIP or Excel.
//  Column set grows with the product — update when new Tree / Work fields ship.
//

import Foundation

enum LibraryExportService {
    private static let exportDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let exportTimestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    /// File-name date stamp using the grower’s current calendar day (not a cached formatter timezone).
    private static func exportDayStamp(for date: Date = .now) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func suggestedExcelFileName() -> String {
        "Bonsai World Library Export \(exportDayStamp()).xlsx"
    }

    static func suggestedZipFileName() -> String {
        "Bonsai World Library \(exportDayStamp()).zip"
    }

    /// Resolve reference-data labels on the main actor, then write on a background thread.
    @MainActor
    static func makeExcelSnapshot(
        trees: [Tree],
        workRecords: [WorkRecord],
        collections: [Collection],
        referenceData: ReferenceDataService
    ) -> LibraryExcelExportSnapshot {
        LibraryExcelExportSnapshot(
            treeRows: buildTreeRows(
                trees: trees,
                collections: collections,
                referenceData: referenceData
            ),
            workRows: buildWorkRows(
                workRecords: workRecords,
                trees: trees,
                referenceData: referenceData
            )
        )
    }

    /// Writes a prepared snapshot — safe off the main thread.
    static func writeExcel(snapshot: LibraryExcelExportSnapshot, to destinationURL: URL) throws {
        try withSecurityScopedAccess(to: destinationURL) {
            try MinimalXLSXWriter.write(
                sheets: [
                    MinimalXLSXWriter.Sheet(name: "Trees", rows: snapshot.treeRows),
                    MinimalXLSXWriter.Sheet(name: "Work", rows: snapshot.workRows),
                ],
                to: destinationURL
            )
            try verifyExportExists(at: destinationURL)
        }
    }

    /// Copies the entire active library package into a `.zip` archive — safe off the main thread.
    static func exportLibraryZip(libraryRootURL: URL, destinationURL: URL) throws {
        try withSecurityScopedAccess(to: destinationURL) {
            let tempZip = FileManager.default.temporaryDirectory
                .appendingPathComponent("bonsai-library-\(UUID().uuidString).zip")
            defer { try? FileManager.default.removeItem(at: tempZip) }

            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
            process.arguments = ["-c", "-k", "--sequesterRsrc", "--keepParent", libraryRootURL.path, tempZip.path]
            try process.run()
            process.waitUntilExit()
            guard process.terminationStatus == 0 else {
                throw LibraryExportError.zipFailed
            }

            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: tempZip, to: destinationURL)
            try verifyExportExists(at: destinationURL)
        }
    }

    private static func verifyExportExists(at url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw LibraryExportError.writeFailed
        }
    }

    private static func withSecurityScopedAccess<T>(to url: URL, _ work: () throws -> T) throws -> T {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }
        return try work()
    }

    // MARK: - Trees sheet

    @MainActor
    private static func buildTreeRows(
        trees: [Tree],
        collections: [Collection],
        referenceData: ReferenceDataService
    ) -> [[String]] {
        var rows: [[String]] = [treeColumnHeaders]

        let sorted = trees.sorted {
            $0.bonsaiName.localizedStandardCompare($1.bonsaiName) == .orderedAscending
        }

        for tree in sorted {
            rows.append(treeExportRow(for: tree, collections: collections, referenceData: referenceData))
        }
        return rows
    }

    private static let treeColumnHeaders: [String] = [
        "Tree ID",
        "Bonsai Name",
        "Botanical Name",
        "Nickname",
        "Genus",
        "Species",
        "Cultivar",
        "Style",
        "Size Class",
        "Tree Stage",
        "Health",
        "In Care",
        "Location",
        "Soil Mix",
        "Light Condition",
        "Pot Type",
        "Pot Length (mm)",
        "Pot Width (mm)",
        "Pot Height (mm)",
        "Pot Diameter (mm)",
        "Height (mm)",
        "Crown Width (mm)",
        "Nebari Width (mm)",
        "Trunk Diameter (mm)",
        "Acquisition Date",
        "Acquisition Method",
        "Acquisition Source",
        "Purchase Price",
        "Acquisition Notes",
        "Disposal Date",
        "Disposal Method",
        "Disposal Party",
        "Disposal Price",
        "Disposal Notes",
        "Vision Statement",
        "Vision Trunk Type",
        "Vision Trunk Note",
        "Vision Branch Type",
        "Vision Branch Note",
        "Vision Apex Type",
        "Vision Apex Note",
        "Vision Nebari Type",
        "Vision Nebari Note",
        "Vision Additional Characteristics",
        "Vision Notes",
        "Tree Notes",
        "Collections",
        "Image Count",
        "Primary Image ID",
        "Created",
        "Modified",
    ]

    @MainActor
    private static func treeExportRow(
        for tree: Tree,
        collections: [Collection],
        referenceData: ReferenceDataService
    ) -> [String] {
        let vision = tree.vision
        return [
            tree.id.uuidString,
            tree.bonsaiName,
            tree.botanicalName,
            tree.nickname,
            tree.genusID.flatMap { referenceData.genus(id: $0)?.name } ?? "",
            tree.speciesID.flatMap { referenceData.species(id: $0)?.name } ?? "",
            tree.cultivarID.flatMap { referenceData.cultivar(id: $0)?.name } ?? "",
            tree.styleID.flatMap { referenceData.style(id: $0)?.name } ?? "",
            tree.sizeClassID.flatMap { referenceData.sizeClass(id: $0)?.name } ?? "",
            tree.treeStageID.flatMap { referenceData.treeStage(id: $0)?.name } ?? "",
            tree.healthStatus.title,
            tree.isInCare ? "Yes" : "No",
            referenceData.location(id: tree.locationID)?.name ?? "",
            tree.soilMixID.flatMap { referenceData.soilMix(id: $0)?.name } ?? "",
            tree.lightConditionID.flatMap { referenceData.lightCondition(id: $0)?.name } ?? "",
            tree.potTypeID.flatMap { referenceData.potType(id: $0)?.name } ?? "",
            formatMillimetres(tree.potLengthMillimetres),
            formatMillimetres(tree.potWidthMillimetres),
            formatMillimetres(tree.potHeightMillimetres),
            formatMillimetres(tree.potDiameterMillimetres),
            formatMillimetres(tree.heightMillimetres),
            formatMillimetres(tree.crownWidthMillimetres),
            formatMillimetres(tree.nebariWidthMillimetres),
            formatMillimetres(tree.trunkDiameterMillimetres),
            tree.acquisitionDate.map { exportDateFormatter.string(from: $0) } ?? "",
            tree.acquisitionMethodID.flatMap { referenceData.acquisitionMethod(id: $0)?.name } ?? "",
            tree.acquisitionSourceName,
            formatDecimalAmount(tree.purchasePrice),
            tree.acquisitionNotes,
            tree.disposalDate.map { exportDateFormatter.string(from: $0) } ?? "",
            tree.disposalMethodID.flatMap { referenceData.disposalMethod(id: $0)?.name } ?? "",
            tree.disposalPartyName,
            formatDecimalAmount(tree.disposalPrice),
            tree.disposalNotes,
            vision?.statement ?? "",
            visionSlotType(vision?.trunkCharacteristic),
            visionSlotNote(vision?.trunkCharacteristic),
            visionSlotType(vision?.branchCharacteristic),
            visionSlotNote(vision?.branchCharacteristic),
            visionSlotType(vision?.apexCharacteristic),
            visionSlotNote(vision?.apexCharacteristic),
            visionSlotType(vision?.nebariCharacteristic),
            visionSlotNote(vision?.nebariCharacteristic),
            formatAdditionalCharacteristics(vision?.additionalCharacteristics ?? []),
            vision?.notes ?? "",
            tree.notes,
            collectionNames(for: tree.id, in: collections),
            String(tree.imageIDs.count),
            tree.primaryImageID?.uuidString ?? "",
            exportTimestampFormatter.string(from: tree.createdDate),
            exportTimestampFormatter.string(from: tree.modifiedDate),
        ]
    }

    // MARK: - Work sheet

    @MainActor
    private static func buildWorkRows(
        workRecords: [WorkRecord],
        trees: [Tree],
        referenceData: ReferenceDataService
    ) -> [[String]] {
        var rows: [[String]] = [[
            "Date",
            "Work Type",
            "Bonsai Names",
            "Tree Count",
            "Soil Mix",
            "Pot Type",
            "Wire",
            "Fertilizer Type",
            "Notes",
            "Created",
            "Modified",
        ]]

        let treeNames = Dictionary(uniqueKeysWithValues: trees.map { ($0.id, $0.bonsaiName) })
        let sorted = workRecords.sorted { $0.performedAt > $1.performedAt }

        for record in sorted {
            let names = record.treeIDs.compactMap { treeNames[$0] }.sorted().joined(separator: ", ")
            rows.append([
                exportTimestampFormatter.string(from: record.performedAt),
                referenceData.workType(id: record.workTypeID)?.name ?? "",
                names,
                String(record.treeIDs.count),
                record.soilMixID.flatMap { referenceData.soilMix(id: $0)?.name } ?? "",
                record.potTypeID.flatMap { referenceData.potType(id: $0)?.name } ?? "",
                record.wireID.flatMap { referenceData.wire(id: $0)?.name } ?? "",
                record.fertilizerTypeID.flatMap { referenceData.fertilizerType(id: $0)?.displayName } ?? "",
                record.notes,
                exportTimestampFormatter.string(from: record.createdDate),
                exportTimestampFormatter.string(from: record.modifiedDate),
            ])
        }
        return rows
    }

    // MARK: - Formatting

    private static func formatDecimalAmount(_ amount: Decimal?) -> String {
        guard let amount else { return "" }
        return NSDecimalNumber(decimal: amount).stringValue
    }

    private static func formatMillimetres(_ value: Int?) -> String {
        guard let value else { return "" }
        return String(value)
    }

    private static func visionSlotType(_ slot: VisionCharacteristicSlot?) -> String {
        slot?.kind.title ?? ""
    }

    private static func visionSlotNote(_ slot: VisionCharacteristicSlot?) -> String {
        slot?.text ?? ""
    }

    private static func formatAdditionalCharacteristics(_ characteristics: [VisionCharacteristic]) -> String {
        characteristics
            .map { "\($0.kind.title): \($0.text)" }
            .joined(separator: " | ")
    }

    private static func collectionNames(for treeID: UUID, in collections: [Collection]) -> String {
        collections
            .filter { $0.treeIDs.contains(treeID) }
            .map(\.name)
            .sorted()
            .joined(separator: ", ")
    }
}
