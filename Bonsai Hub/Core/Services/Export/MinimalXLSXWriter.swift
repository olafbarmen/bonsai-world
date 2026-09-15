//
//  MinimalXLSXWriter.swift
//  Bonsai World
//
//  Lightweight .xlsx writer (OOXML zip) — no third-party dependencies.
//

import Foundation

enum MinimalXLSXWriter {
    struct Sheet {
        var name: String
        var rows: [[String]]
    }

    static func write(sheets: [Sheet], to destinationURL: URL) throws {
        let workspace = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-export-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: workspace) }

        let sharedStrings = SharedStringTable(sheets: sheets)
        try writePackage(sheets: sheets, sharedStrings: sharedStrings, in: workspace)

        let tempArchive = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-export-\(UUID().uuidString).xlsx")
        defer { try? FileManager.default.removeItem(at: tempArchive) }

        try zipWorkspace(workspace, to: tempArchive)

        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.copyItem(at: tempArchive, to: destinationURL)
    }

    // MARK: - Package

    private static func writePackage(
        sheets: [Sheet],
        sharedStrings: SharedStringTable,
        in root: URL
    ) throws {
        let xl = root.appendingPathComponent("xl", isDirectory: true)
        let worksheets = xl.appendingPathComponent("worksheets", isDirectory: true)
        let rels = root.appendingPathComponent("_rels", isDirectory: true)
        let xlRels = xl.appendingPathComponent("_rels", isDirectory: true)
        let docProps = root.appendingPathComponent("docProps", isDirectory: true)
        try FileManager.default.createDirectory(at: worksheets, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: rels, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: xlRels, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: docProps, withIntermediateDirectories: true)

        try writeUTF8(contentTypesXML(sheetCount: sheets.count), to: root.appendingPathComponent("[Content_Types].xml"))
        try writeUTF8(packageRelsXML(), to: rels.appendingPathComponent(".rels"))
        try writeUTF8(corePropertiesXML(), to: docProps.appendingPathComponent("core.xml"))
        try writeUTF8(appPropertiesXML(), to: docProps.appendingPathComponent("app.xml"))
        try writeUTF8(workbookXML(sheets: sheets), to: xl.appendingPathComponent("workbook.xml"))
        try writeUTF8(stylesXML(), to: xl.appendingPathComponent("styles.xml"))
        try writeUTF8(sharedStrings.xml, to: xl.appendingPathComponent("sharedStrings.xml"))
        try writeUTF8(workbookRelsXML(sheetCount: sheets.count), to: xlRels.appendingPathComponent("workbook.xml.rels"))

        for (index, sheet) in sheets.enumerated() {
            let sheetURL = worksheets.appendingPathComponent("sheet\(index + 1).xml")
            try writeUTF8(
                worksheetXML(rows: sheet.rows, sharedStrings: sharedStrings),
                to: sheetURL
            )
        }
    }

    private static func writeUTF8(_ string: String, to url: URL) throws {
        try Data(string.utf8).write(to: url)
    }

    // MARK: - Shared strings

    private struct SharedStringTable {
        private(set) var strings: [String] = []
        private var indexByString: [String: Int] = [:]

        mutating func register(_ value: String) -> Int {
            let sanitized = sanitizeCellText(value)
            if let existing = indexByString[sanitized] {
                return existing
            }
            let nextIndex = strings.count
            strings.append(sanitized)
            indexByString[sanitized] = nextIndex
            return nextIndex
        }

        func index(for value: String) -> Int {
            let sanitized = sanitizeCellText(value)
            guard let existing = indexByString[sanitized] else {
                preconditionFailure("Shared string table missing value")
            }
            return existing
        }

        init(sheets: [Sheet]) {
            for sheet in sheets {
                for row in sheet.rows {
                    for value in row {
                        _ = register(value)
                    }
                }
            }
        }

        var xml: String {
            let entries = strings.map { value in
                let escaped = escapeXML(value)
                let needsPreserve = value.contains("\n")
                    || value.contains("\r")
                    || value.hasPrefix(" ")
                    || value.hasSuffix(" ")
                if needsPreserve {
                    return "<si><t xml:space=\"preserve\">\(escaped)</t></si>"
                }
                return "<si><t>\(escaped)</t></si>"
            }.joined()
            return """
            <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
            <sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="\(strings.count)" uniqueCount="\(strings.count)">
            \(entries)
            </sst>
            """
        }
    }

    // MARK: - XML

    private static func contentTypesXML(sheetCount: Int) -> String {
        var overrides = """
        <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
        <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
        <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
        <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
        <Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
        """
        for index in 1...sheetCount {
            overrides += """
            <Override PartName="/xl/worksheets/sheet\(index).xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
            """
        }
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
        <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
        <Default Extension="xml" ContentType="application/xml"/>
        \(overrides)
        </Types>
        """
    }

    private static func packageRelsXML() -> String {
        """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
        <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
        <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
        </Relationships>
        """
    }

    private static func corePropertiesXML() -> String {
        let created = ISO8601DateFormatter().string(from: .now)
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <dc:creator>Bonsai Hub</dc:creator>
        <dcterms:created xsi:type="dcterms:W3CDTF">\(created)</dcterms:created>
        </cp:coreProperties>
        """
    }

    private static func appPropertiesXML() -> String {
        """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
        <Application>Bonsai Hub</Application>
        </Properties>
        """
    }

    private static func stylesXML() -> String {
        """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <fonts count="1"><font><sz val="11"/><color theme="1"/><name val="Calibri"/><family val="2"/></font></fonts>
        <fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>
        <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
        <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
        <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
        <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
        </styleSheet>
        """
    }

    private static func workbookXML(sheets: [Sheet]) -> String {
        let sheetEntries = sheets.enumerated().map { index, sheet in
            let safeName = escapeXML(sheet.name.prefix(31))
            return "<sheet name=\"\(safeName)\" sheetId=\"\(index + 1)\" r:id=\"rId\(index + 1)\"/>"
        }.joined()
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
        <bookViews><workbookView activeTab="0"/></bookViews>
        <sheets>\(sheetEntries)</sheets>
        </workbook>
        """
    }

    private static func workbookRelsXML(sheetCount: Int) -> String {
        var rels = (1...sheetCount).map { index in
            "<Relationship Id=\"rId\(index)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet\(index).xml\"/>"
        }.joined()
        rels += "<Relationship Id=\"rId\(sheetCount + 1)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>"
        rels += "<Relationship Id=\"rId\(sheetCount + 2)\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings\" Target=\"sharedStrings.xml\"/>"
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
        \(rels)
        </Relationships>
        """
    }

    private static func worksheetXML(rows: [[String]], sharedStrings: SharedStringTable) -> String {
        let dimension = worksheetDimension(rows: rows)
        let rowXML = rows.enumerated().map { rowIndex, cells in
            let cellXML = cells.enumerated().map { columnIndex, value in
                let reference = cellReference(column: columnIndex, row: rowIndex)
                let stringIndex = sharedStrings.index(for: value)
                return "<c r=\"\(reference)\" t=\"s\"><v>\(stringIndex)</v></c>"
            }.joined()
            return "<row r=\"\(rowIndex + 1)\">\(cellXML)</row>"
        }.joined(separator: "\n")
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
        <dimension ref="\(dimension)"/>
        <sheetData>
        \(rowXML)
        </sheetData>
        </worksheet>
        """
    }

    private static func worksheetDimension(rows: [[String]]) -> String {
        guard let lastRow = rows.indices.last else { return "A1" }
        let lastColumn = max((rows.map(\.count).max() ?? 1) - 1, 0)
        return "A1:\(cellReference(column: lastColumn, row: lastRow))"
    }

    private static func sanitizeCellText(_ value: String) -> String {
        value.unicodeScalars.filter { scalar in
            scalar.value == 0x9 || scalar.value == 0xA || scalar.value == 0xD || scalar.value >= 0x20
        }.map(String.init).joined()
    }

    private static func cellReference(column: Int, row: Int) -> String {
        let letters = columnName(column)
        return "\(letters)\(row + 1)"
    }

    private static func columnName(_ index: Int) -> String {
        var result = ""
        var n = index
        while n >= 0 {
            result = String(UnicodeScalar(65 + (n % 26))!) + result
            n = n / 26 - 1
        }
        return result
    }

    private static func escapeXML(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private static func escapeXML(_ substring: Substring) -> String {
        escapeXML(String(substring))
    }

    // MARK: - Zip

    private static func zipWorkspace(_ workspace: URL, to destinationURL: URL) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
        process.currentDirectoryURL = workspace
        process.arguments = ["-r", "-X", "-q", destinationURL.path, "."]
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw LibraryExportError.zipFailed
        }
    }
}

enum LibraryExportError: Error, LocalizedError {
    case libraryUnavailable
    case zipFailed
    case writeFailed
    case exportCancelled

    var errorDescription: String? {
        switch self {
        case .libraryUnavailable:
            "No library folder is available to export."
        case .zipFailed:
            "The export archive could not be created."
        case .writeFailed:
            "The export file could not be saved to the chosen location."
        case .exportCancelled:
            "Export was cancelled."
        }
    }
}
