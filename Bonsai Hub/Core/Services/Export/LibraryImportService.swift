//
//  LibraryImportService.swift
//  Bonsai World
//
//  Phase 1 import — ZIP library restore and Excel update/create.
//

import Foundation

enum LibraryImportError: Error, LocalizedError {
    case invalidWorkbook
    case missingTreesSheet
    case libraryFolderAlreadyExists
    case invalidLibraryPackage
    case unzipFailed
    case importCancelled
    case noOpenLibrary

    var errorDescription: String? {
        switch self {
        case .invalidWorkbook:
            "Choose an Excel .xlsx file — not a ZIP. For a full backup, use Load a backup (ZIP)."
        case .missingTreesSheet:
            "The workbook does not contain a Trees sheet."
        case .libraryFolderAlreadyExists:
            "A library folder with this name already exists at the chosen location."
        case .invalidLibraryPackage:
            "This ZIP is not a valid Bonsai World Library backup. Export a ZIP from Library Management, then choose that file."
        case .unzipFailed:
            "Could not open the ZIP file. Try choosing it again, or save a new backup and load that."
        case .importCancelled:
            "Import was cancelled."
        case .noOpenLibrary:
            "No library is open to restore into. Set Library Location first."
        }
    }
}

enum LibraryImportService {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    // MARK: - ZIP (in-place restore into the open library)

    /// Inspects a library ZIP in a temporary folder and returns a preview for replacing `currentLibraryRoot`.
    static func previewLibraryZip(
        sourceURL: URL,
        currentLibraryRoot: URL
    ) throws -> LibraryZipImportPreview {
        let workParent = try makeTemporaryWorkDirectory()
        defer { try? FileManager.default.removeItem(at: workParent) }

        let localZip = try copyZipIntoAppTemporaryFolder(sourceURL, workParent: workParent)
        let extractedRoot = try extractLocalZip(localZip, into: workParent, replaceExisting: true)
        let treeCount = try countTrees(in: extractedRoot)
        return LibraryZipImportPreview(
            treeCount: treeCount,
            libraryFolderName: Library.defaultName,
            destinationPath: currentLibraryRoot.path
        )
    }

    /// Replaces the open library package with the contents of a Bonsai World library ZIP.
    @discardableResult
    static func replaceOpenLibrary(
        fromZip sourceURL: URL,
        currentLibraryRoot: URL
    ) throws -> URL {
        let fileManager = FileManager.default
        let workParent = try makeTemporaryWorkDirectory()
        defer { try? fileManager.removeItem(at: workParent) }

        let localZip = try copyZipIntoAppTemporaryFolder(sourceURL, workParent: workParent)
        let extractedRoot = try extractLocalZip(localZip, into: workParent, replaceExisting: true)

        let backupRoot = currentLibraryRoot
            .deletingLastPathComponent()
            .appendingPathComponent(
                "\(Library.defaultName).pre-import-\(UUID().uuidString)",
                isDirectory: true
            )

        if fileManager.fileExists(atPath: currentLibraryRoot.path) {
            try fileManager.moveItem(at: currentLibraryRoot, to: backupRoot)
        }

        do {
            try fileManager.moveItem(at: extractedRoot, to: currentLibraryRoot)
            try? fileManager.removeItem(at: backupRoot)
        } catch {
            try? fileManager.removeItem(at: currentLibraryRoot)
            if fileManager.fileExists(atPath: backupRoot.path) {
                try? fileManager.moveItem(at: backupRoot, to: currentLibraryRoot)
            }
            throw error
        }

        try validateLibraryRoot(currentLibraryRoot)
        return currentLibraryRoot
    }

    private static func makeTemporaryWorkDirectory() throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-zip-import-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    /// Copies the user-selected ZIP into the app container while security scope is valid.
    private static func copyZipIntoAppTemporaryFolder(_ sourceURL: URL, workParent: URL) throws -> URL {
        try withSecurityScopedAccess(to: sourceURL) {
            let fileManager = FileManager.default
            let localZip = workParent.appendingPathComponent(
                "import-\(UUID().uuidString).zip",
                isDirectory: false
            )
            do {
                if fileManager.fileExists(atPath: localZip.path) {
                    try fileManager.removeItem(at: localZip)
                }
                try fileManager.copyItem(at: sourceURL, to: localZip)
            } catch {
                throw LibraryImportError.unzipFailed
            }
            return localZip
        }
    }

    /// Unpacks a ZIP that already lives inside the app temporary folder (sandbox-safe for `ditto`).
    private static func extractLocalZip(
        _ localZipURL: URL,
        into parentDirectory: URL,
        replaceExisting: Bool
    ) throws -> URL {
        let fileManager = FileManager.default
        let libraryRoot = parentDirectory.appendingPathComponent(Library.defaultName, isDirectory: true)
        if fileManager.fileExists(atPath: libraryRoot.path) {
            if replaceExisting {
                try fileManager.removeItem(at: libraryRoot)
            } else {
                throw LibraryImportError.libraryFolderAlreadyExists
            }
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
        process.arguments = ["-x", "-k", localZipURL.path, parentDirectory.path]
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            throw LibraryImportError.unzipFailed
        }
        guard process.terminationStatus == 0 else {
            throw LibraryImportError.unzipFailed
        }

        guard fileManager.fileExists(atPath: libraryRoot.path) else {
            throw LibraryImportError.invalidLibraryPackage
        }
        try validateLibraryRoot(libraryRoot)
        return libraryRoot
    }

    private static func validateLibraryRoot(_ root: URL) throws {
        for folder in LibraryPackageLayout.requiredRelativeFolders {
            var isDirectory: ObjCBool = false
            let url = root.appendingPathComponent(folder, isDirectory: true)
            guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue else {
                throw LibraryImportError.invalidLibraryPackage
            }
        }
        let treesURL = root.appendingPathComponent(LibraryPackageLayout.treesFileName)
        guard FileManager.default.fileExists(atPath: treesURL.path) else {
            throw LibraryImportError.invalidLibraryPackage
        }
    }

    /// Counts trees without requiring a full `Tree` model decode (preview only).
    private static func countTrees(in libraryRoot: URL) throws -> Int {
        let treesURL = libraryRoot.appendingPathComponent(LibraryPackageLayout.treesFileName)
        do {
            let data = try Data(contentsOf: treesURL)
            if let object = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let trees = object["trees"] as? [Any] {
                return trees.count
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryTreesFile.self, from: data).trees.count
        } catch let error as LibraryImportError {
            throw error
        } catch {
            throw LibraryImportError.invalidLibraryPackage
        }
    }

    // MARK: - Excel preview / apply

    @MainActor
    static func previewExcelImport(
        from url: URL,
        trees: [Tree],
        collections: [Collection],
        referenceData: ReferenceDataService
    ) throws -> LibraryExcelImportPreview {
        let workbook = try readWorkbook(from: url)
        guard let treesSheet = workbook.sheet(named: "Trees"), treesSheet.rows.count > 1 else {
            throw LibraryImportError.missingTreesSheet
        }

        var preview = LibraryExcelImportPreview()
        let headers = treesSheet.rows[0]
        let existingByID = Dictionary(uniqueKeysWithValues: trees.map { ($0.id, $0) })
        var reservedCreateNames = Set(trees.map { Self.normalizedBonsaiName($0.bonsaiName) }.filter { !$0.isEmpty })

        for (offset, row) in treesSheet.rows.dropFirst().enumerated() {
            let excelRow = offset + 2
            let fields = rowDictionary(headers: headers, values: row)
            if fields.values.allSatisfy(\.isEmpty) { continue }

            do {
                let plan = try TreeImportPlan(
                    fields: fields,
                    existingTrees: existingByID,
                    collections: collections,
                    referenceData: referenceData,
                    excelRow: excelRow
                )
                try Self.registerCreateNameIfNeeded(plan: plan, reservedCreateNames: &reservedCreateNames, excelRow: excelRow)
                switch plan.action {
                case .update: preview.treesToUpdate += 1
                case .create: preview.treesToCreate += 1
                }
            } catch let issue as LibraryImportIssue {
                preview.treesSkipped += 1
                preview.issues.append(issue)
            }
        }

        if let workSheet = workbook.sheet(named: "Work"), workSheet.rows.count > 1 {
            let workHeaders = workSheet.rows[0]
            let bonsaiNameToID = Dictionary(uniqueKeysWithValues: trees.map { ($0.bonsaiName, $0.id) })
            for (offset, row) in workSheet.rows.dropFirst().enumerated() {
                let excelRow = offset + 2
                let workFields = rowDictionary(headers: workHeaders, values: row)
                if workFields.values.allSatisfy(\.isEmpty) { continue }
                do {
                    _ = try parseWorkRecord(
                        fields: workFields,
                        bonsaiNameToID: bonsaiNameToID,
                        referenceData: referenceData,
                        excelRow: excelRow
                    )
                    preview.workToAdd += 1
                } catch let issue as LibraryImportIssue {
                    preview.workSkipped += 1
                    preview.issues.append(issue)
                }
            }
        }

        return preview
    }

    @MainActor
    static func applyExcelImport(
        from url: URL,
        treeService: TreeService,
        workService: WorkService,
        referenceData: ReferenceDataService
    ) throws -> LibraryExcelImportPreview {
        let collections = treeService.collections
        let workbook = try readWorkbook(from: url)
        guard let treesSheet = workbook.sheet(named: "Trees"), treesSheet.rows.count > 1 else {
            throw LibraryImportError.missingTreesSheet
        }

        var result = LibraryExcelImportPreview()
        let headers = treesSheet.rows[0]
        let existingTrees = treeService.trees
        let existingByID = Dictionary(uniqueKeysWithValues: existingTrees.map { ($0.id, $0) })
        var reservedCreateNames = Set(
            existingTrees.map { Self.normalizedBonsaiName($0.bonsaiName) }.filter { !$0.isEmpty }
        )

        for (offset, row) in treesSheet.rows.dropFirst().enumerated() {
            let excelRow = offset + 2
            let fields = rowDictionary(headers: headers, values: row)
            if fields.values.allSatisfy(\.isEmpty) { continue }

            do {
                let plan = try TreeImportPlan(
                    fields: fields,
                    existingTrees: existingByID,
                    collections: collections,
                    referenceData: referenceData,
                    excelRow: excelRow
                )
                try Self.registerCreateNameIfNeeded(plan: plan, reservedCreateNames: &reservedCreateNames, excelRow: excelRow)
                switch plan.action {
                case .update(let tree):
                    _ = try treeService.updateTree(tree)
                    if !plan.collectionIDs.isEmpty {
                        try treeService.setCollectionMembership(treeID: tree.id, collectionIDs: plan.collectionIDs)
                    }
                    if let vision = plan.vision {
                        try treeService.updateVision(treeID: tree.id, vision: vision)
                    }
                    result.treesToUpdate += 1
                case .create(let tree):
                    let created = try treeService.createTree(tree, joiningCollectionIDs: plan.collectionIDs)
                    if let vision = plan.vision {
                        try treeService.updateVision(treeID: created.id, vision: vision)
                    }
                    result.treesToCreate += 1
                }
            } catch let issue as LibraryImportIssue {
                result.treesSkipped += 1
                result.issues.append(issue)
            } catch {
                result.treesSkipped += 1
                result.issues.append(
                    LibraryImportIssue(
                        sheet: "Trees",
                        row: excelRow,
                        message: (error as? LocalizedError)?.errorDescription
                            ?? error.localizedDescription
                    )
                )
            }
        }

        let bonsaiNameToID = Dictionary(uniqueKeysWithValues: treeService.trees.map { ($0.bonsaiName, $0.id) })
        if let workSheet = workbook.sheet(named: "Work"), workSheet.rows.count > 1 {
            let workHeaders = workSheet.rows[0]
            for (offset, row) in workSheet.rows.dropFirst().enumerated() {
                let excelRow = offset + 2
                let workFields = rowDictionary(headers: workHeaders, values: row)
                if workFields.values.allSatisfy(\.isEmpty) { continue }
                do {
                    let record = try parseWorkRecord(
                        fields: workFields,
                        bonsaiNameToID: bonsaiNameToID,
                        referenceData: referenceData,
                        excelRow: excelRow
                    )
                    try workService.importWorkRecord(record)
                    result.workToAdd += 1
                } catch let issue as LibraryImportIssue {
                    result.workSkipped += 1
                    result.issues.append(issue)
                }
            }
        }

        return result
    }

    // MARK: - Parsing helpers

    private static func readWorkbook(from url: URL) throws -> MinimalXLSXReader.Workbook {
        try withSecurityScopedAccess(to: url) {
            do {
                return try MinimalXLSXReader.read(from: url)
            } catch {
                throw LibraryImportError.invalidWorkbook
            }
        }
    }

    private static func rowDictionary(headers: [String], values: [String]) -> [String: String] {
        var dictionary: [String: String] = [:]
        for (index, header) in headers.enumerated() {
            let key = header.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !key.isEmpty else { continue }
            dictionary[key] = index < values.count ? values[index] : ""
        }
        return dictionary
    }

    @MainActor
    private static func parseWorkRecord(
        fields: [String: String],
        bonsaiNameToID: [String: UUID],
        referenceData: ReferenceDataService,
        excelRow: Int
    ) throws -> WorkRecord {
        let workTypeName = fields["Work Type", default: ""]
        guard let workTypeID = referenceData.workTypes.first(where: {
            $0.name.caseInsensitiveCompare(workTypeName) == .orderedSame
        })?.id else {
            throw importIssue(sheet: "Work", row: excelRow, message: "Unknown Work Type “\(workTypeName)”")
        }

        let treeNames = fields["Bonsai Names", default: ""]
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let treeIDs = try treeNames.map { name -> UUID in
            guard let id = bonsaiNameToID[name] else {
                throw importIssue(sheet: "Work", row: excelRow, message: "Unknown Bonsai Name “\(name)”")
            }
            return id
        }
        guard !treeIDs.isEmpty else {
            throw importIssue(sheet: "Work", row: excelRow, message: "Work row has no trees")
        }

        return WorkRecord(
            workTypeID: workTypeID,
            treeIDs: treeIDs,
            performedAt: parseTimestamp(fields["Date", default: ""]) ?? .now,
            notes: fields["Notes", default: ""],
            soilMixID: optionalNamedReference(named: fields["Soil Mix", default: ""], in: referenceData.soilMixes),
            potTypeID: optionalNamedReference(named: fields["Pot Type", default: ""], in: referenceData.potTypes),
            fertilizerTypeID: optionalFertilizerTypeReference(named: fields["Fertilizer Type", default: ""], in: referenceData.fertilizerTypes),
            wireID: optionalNamedReference(named: fields["Wire", default: ""], in: referenceData.wire)
        )
    }

    private static func importIssue(sheet: String, row: Int, message: String) -> LibraryImportIssue {
        LibraryImportIssue(sheet: sheet, row: row, message: message)
    }

    /// Case-insensitive form used by ``TreeService/isBonsaiNameInUse(_:excluding:)``.
    private static func normalizedBonsaiName(_ name: String) -> String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Ensures a Create does not reuse a library or earlier-in-file Bonsai Name.
    /// Updates are unchanged. On success, reserves the name for later rows in this import.
    private static func registerCreateNameIfNeeded(
        plan: TreeImportPlan,
        reservedCreateNames: inout Set<String>,
        excelRow: Int
    ) throws {
        guard case .create(let tree) = plan.action else { return }
        let displayName = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        let key = normalizedBonsaiName(displayName)
        guard !key.isEmpty else {
            throw LibraryImportIssue(
                sheet: "Trees",
                row: excelRow,
                message: "Bonsai Name is required for new trees"
            )
        }
        if reservedCreateNames.contains(key) {
            throw LibraryImportIssue(
                sheet: "Trees",
                row: excelRow,
                message: "Bonsai Name “\(displayName)” is already used"
            )
        }
        reservedCreateNames.insert(key)
    }

    private static func withSecurityScopedAccess<T>(to url: URL, _ work: () throws -> T) throws -> T {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }
        return try work()
    }

    private static func parseDate(_ value: String) -> Date? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return dateFormatter.date(from: trimmed)
    }

    private static func parseTimestamp(_ value: String) -> Date? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return timestampFormatter.date(from: trimmed) ?? dateFormatter.date(from: trimmed)
    }

    private static func parseDecimal(_ value: String) -> Decimal? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Decimal(string: trimmed.replacingOccurrences(of: ",", with: "."))
    }

    private static func parseInt(_ value: String) -> Int? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Int(trimmed)
    }

    private static func optionalNamedReference<T>(
        named name: String,
        in items: [T]
    ) -> UUID? where T: ReferenceNamedItem & Identifiable, T.ID == UUID {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return items.first { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }?.id
    }

    private static func optionalFertilizerTypeReference(
        named name: String,
        in items: [FertilizerType]
    ) -> UUID? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return items.first {
            $0.displayName.caseInsensitiveCompare(trimmed) == .orderedSame
                || $0.name.caseInsensitiveCompare(trimmed) == .orderedSame
        }?.id
    }

    private static func requireNamedReference<T>(
        named name: String,
        in items: [T],
        sheet: String,
        row: Int,
        label: String
    ) throws -> UUID where T: ReferenceNamedItem & Identifiable, T.ID == UUID {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw importIssue(sheet: sheet, row: row, message: "\(label) is required")
        }
        guard let match = items.first(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            throw importIssue(sheet: sheet, row: row, message: "Unknown \(label) “\(trimmed)”")
        }
        return match.id
    }

    private static func optionalReference<T: ReferenceListItem>(named name: String, in items: [T]) -> UUID? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return items.first { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }?.id
    }

    // MARK: - Tree import plan

    @MainActor
    private struct TreeImportPlan {
        enum Action {
            case update(Tree)
            case create(Tree)
        }

        var action: Action
        var vision: TreeVision?
        var collectionIDs: Set<UUID>

        init(
            fields: [String: String],
            existingTrees: [UUID: Tree],
            collections: [Collection],
            referenceData: ReferenceDataService,
            excelRow: Int
        ) throws {
            let sheet = "Trees"
            let treeIDText = fields["Tree ID", default: ""].trimmingCharacters(in: .whitespacesAndNewlines)
            let parsedID = UUID(uuidString: treeIDText)

            if let parsedID, let existing = existingTrees[parsedID] {
                var tree = existing
                try Self.applyEditableFields(
                    to: &tree,
                    fields: fields,
                    referenceData: referenceData,
                    sheet: sheet,
                    row: excelRow
                )
                action = .update(tree)
                vision = Self.parseVision(fields: fields)
                collectionIDs = try Self.parseCollections(
                    fields: fields,
                    collections: collections,
                    sheet: sheet,
                    row: excelRow
                )
                return
            }

            if !treeIDText.isEmpty {
                throw LibraryImportIssue(
                    sheet: sheet,
                    row: excelRow,
                    message: "Unknown Tree ID “\(treeIDText)”"
                )
            }

            let bonsaiName = fields["Bonsai Name", default: ""].trimmingCharacters(in: .whitespacesAndNewlines)
            guard !bonsaiName.isEmpty else {
                throw LibraryImportIssue(sheet: sheet, row: excelRow, message: "Bonsai Name is required for new trees")
            }

            let genusID = try requireNamedReference(
                named: fields["Genus", default: ""],
                in: referenceData.genus,
                sheet: sheet,
                row: excelRow,
                label: "Genus"
            )
            let speciesID = try requireNamedReference(
                named: fields["Species", default: ""],
                in: referenceData.species,
                sheet: sheet,
                row: excelRow,
                label: "Species"
            )
            let locationID = try requireNamedReference(
                named: fields["Location", default: ""],
                in: referenceData.locations,
                sheet: sheet,
                row: excelRow,
                label: "Location"
            )

            var tree = Tree(
                botanicalName: fields["Botanical Name", default: ""],
                nickname: fields["Nickname", default: ""],
                bonsaiName: bonsaiName,
                genusID: genusID,
                speciesID: speciesID,
                locationID: locationID,
                createdDate: .now,
                modifiedDate: .now
            )
            if let cultivarName = Self.nonEmpty(fields["Cultivar", default: ""]) {
                tree.cultivarID = try Self.optionalReferenceID(
                    named: cultivarName,
                    in: referenceData.cultivars,
                    sheet: sheet,
                    row: excelRow,
                    label: "Cultivar"
                )
            }
            try Self.applyEditableFields(
                to: &tree,
                fields: fields,
                referenceData: referenceData,
                sheet: sheet,
                row: excelRow
            )
            action = .create(tree)
            vision = Self.parseVision(fields: fields)
            collectionIDs = try Self.parseCollections(
                fields: fields,
                collections: collections,
                sheet: sheet,
                row: excelRow
            )
        }

        static func applyEditableFields(
            to tree: inout Tree,
            fields: [String: String],
            referenceData: ReferenceDataService,
            sheet: String,
            row: Int
        ) throws {
            if let locationName = Self.nonEmpty(fields["Location", default: ""]) {
                tree.locationID = try requireNamedReference(
                    named: locationName,
                    in: referenceData.locations,
                    sheet: sheet,
                    row: row,
                    label: "Location"
                )
            }

            tree.nickname = fields["Nickname", default: ""]
            tree.styleID = try optionalReferenceID(
                named: fields["Style", default: ""],
                in: referenceData.styles,
                sheet: sheet,
                row: row,
                label: "Style"
            )
            tree.sizeClassID = try optionalReferenceID(
                named: fields["Size Class", default: ""],
                in: referenceData.sizeClasses,
                sheet: sheet,
                row: row,
                label: "Size Class"
            )
            tree.treeStageID = try optionalTreeStageID(
                named: fields["Tree Stage", default: fields["Growing Status", default: ""]],
                in: referenceData,
                sheet: sheet,
                row: row
            )
            tree.healthStatus = parseHealth(fields["Health", default: ""])
            tree.soilMixID = try optionalReferenceID(
                named: fields["Soil Mix", default: ""],
                in: referenceData.soilMixes,
                sheet: sheet,
                row: row,
                label: "Soil Mix"
            )
            tree.lightConditionID = try optionalReferenceID(
                named: fields["Light Condition", default: ""],
                in: referenceData.lightConditions,
                sheet: sheet,
                row: row,
                label: "Light Condition"
            )
            tree.potTypeID = try optionalReferenceID(
                named: fields["Pot Type", default: ""],
                in: referenceData.potTypes,
                sheet: sheet,
                row: row,
                label: "Pot Type"
            )
            tree.potLengthMillimetres = parseInt(fields["Pot Length (mm)", default: ""])
            tree.potWidthMillimetres = parseInt(fields["Pot Width (mm)", default: ""])
            tree.potHeightMillimetres = parseInt(fields["Pot Height (mm)", default: ""])
            tree.potDiameterMillimetres = parseInt(fields["Pot Diameter (mm)", default: ""])
            tree.heightMillimetres = parseInt(fields["Height (mm)", default: ""])
            tree.crownWidthMillimetres = parseInt(fields["Crown Width (mm)", default: ""])
            tree.nebariWidthMillimetres = parseInt(fields["Nebari Width (mm)", default: ""])
            tree.trunkDiameterMillimetres = parseInt(fields["Trunk Diameter (mm)", default: ""])
            tree.acquisitionDate = parseDate(fields["Acquisition Date", default: ""])
            tree.acquisitionMethodID = try optionalReferenceID(
                named: fields["Acquisition Method", default: ""],
                in: referenceData.acquisitionMethods,
                sheet: sheet,
                row: row,
                label: "Acquisition Method"
            )
            tree.acquisitionSourceName = fields["Acquisition Source", default: ""]
            tree.purchasePrice = parseDecimal(fields["Purchase Price", default: ""])
            tree.acquisitionNotes = fields["Acquisition Notes", default: ""]
            tree.disposalDate = parseDate(fields["Disposal Date", default: ""])
            tree.disposalMethodID = try optionalReferenceID(
                named: fields["Disposal Method", default: ""],
                in: referenceData.disposalMethods,
                sheet: sheet,
                row: row,
                label: "Disposal Method"
            )
            tree.disposalPartyName = fields["Disposal Party", default: ""]
            tree.disposalPrice = parseDecimal(fields["Disposal Price", default: ""])
            tree.disposalNotes = fields["Disposal Notes", default: ""]
            tree.notes = fields["Tree Notes", default: ""]

            if fields["In Care", default: ""].caseInsensitiveCompare("Yes") == .orderedSame {
                tree.disposalDate = nil
                tree.disposalMethodID = nil
                tree.disposalPartyName = ""
                tree.disposalPrice = nil
                tree.disposalNotes = ""
            }
        }

        static func parseVision(fields: [String: String]) -> TreeVision? {
            let statement = fields["Vision Statement", default: ""]
            let notes = fields["Vision Notes", default: ""]
            let additional = fields["Vision Additional Characteristics", default: ""]
            let hasFixedSlots = VisionFixedCharacteristic.allCases.contains { fixed in
                !fields["Vision \(fixed.title) Note", default: ""].isEmpty
                    || !fields["Vision \(fixed.title) Type", default: ""].isEmpty
            }
            guard !statement.isEmpty || !notes.isEmpty || !additional.isEmpty || hasFixedSlots else {
                return nil
            }

            var vision = TreeVision(
                statement: statement,
                notes: notes
            )
            for fixed in VisionFixedCharacteristic.allCases {
                let slot = VisionCharacteristicSlot(
                    kind: parseVisionKind(fields["Vision \(fixed.title) Type", default: ""]),
                    text: fields["Vision \(fixed.title) Note", default: ""]
                )
                vision.setSlot(fixed, to: slot)
            }
            if !additional.isEmpty {
                vision.additionalCharacteristics = additional
                    .split(separator: "|")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                    .map { fragment in
                        if let colon = fragment.firstIndex(of: ":") {
                            let kindText = String(fragment[..<colon]).trimmingCharacters(in: .whitespaces)
                            let text = String(fragment[fragment.index(after: colon)...]).trimmingCharacters(in: .whitespaces)
                            return VisionCharacteristic(kind: parseVisionKind(kindText), text: text)
                        }
                        return VisionCharacteristic(text: String(fragment))
                    }
            }
            return vision
        }

        static func parseCollections(
            fields: [String: String],
            collections: [Collection],
            sheet: String,
            row: Int
        ) throws -> Set<UUID> {
            let names = fields["Collections", default: ""]
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            var ids = Set<UUID>()
            for name in names {
                guard let collection = collections.first(where: {
                    $0.isManual && $0.name.caseInsensitiveCompare(name) == .orderedSame
                }) else {
                    throw LibraryImportIssue(sheet: sheet, row: row, message: "Unknown Collection “\(name)”")
                }
                ids.insert(collection.id)
            }
            return ids
        }

        static func optionalTreeStageID(
            named name: String,
            in referenceData: ReferenceDataService,
            sheet: String,
            row: Int
        ) throws -> UUID? {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }

            if let match = referenceData.treeStages.first(where: {
                $0.name.caseInsensitiveCompare(trimmed) == .orderedSame
            }) {
                return match.id
            }

            if let canonical = TreeStageLegacyCatalog.canonicalStageName(fromLegacyName: trimmed),
               let id = TreeStagePreviewData.id(for: canonical) {
                return id
            }

            throw LibraryImportIssue(sheet: sheet, row: row, message: "Unknown Tree Stage “\(trimmed)”")
        }

        static func optionalReferenceID<T>(
            named name: String,
            in items: [T],
            sheet: String,
            row: Int,
            label: String
        ) throws -> UUID? where T: ReferenceNamedItem & Identifiable, T.ID == UUID {
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }
            guard let match = items.first(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
                throw LibraryImportIssue(sheet: sheet, row: row, message: "Unknown \(label) “\(trimmed)”")
            }
            return match.id
        }

        static func parseHealth(_ value: String) -> TreeHealthStatus {
            TreeHealthStatus.allCases.first {
                $0.title.caseInsensitiveCompare(value) == .orderedSame
            } ?? .stable
        }

        static func parseVisionKind(_ value: String) -> VisionCharacteristicKind {
            VisionCharacteristicKind.allCases.first {
                $0.title.caseInsensitiveCompare(value) == .orderedSame
            } ?? .develop
        }

        static func nonEmpty(_ value: String) -> String? {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
    }
}

private extension Dictionary where Key == String, Value == String {
    subscript(_ key: String, default defaultValue: @autoclosure () -> String) -> String {
        self[key] ?? defaultValue()
    }
}
