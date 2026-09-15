//
//  MinimalXLSXReader.swift
//  Bonsai World
//
//  Reads workbooks produced by MinimalXLSXWriter (shared strings + sheet XML).
//

import Foundation

enum MinimalXLSXReaderError: Error {
    case unzipFailed
    case unreadableWorkbook
}

enum MinimalXLSXReader {
    struct Sheet {
        var name: String
        var rows: [[String]]
    }

    struct Workbook {
        var sheets: [Sheet]

        func sheet(named name: String) -> Sheet? {
            sheets.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        }
    }

    static func read(from url: URL) throws -> Workbook {
        let workspace = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-import-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: true)
        defer {
            _ = try? FileManager.default.removeItem(at: workspace)
        }

        try unzip(url, to: workspace)

        let sharedStringsURL = workspace.appendingPathComponent("xl/sharedStrings.xml")
        let sharedStrings: [String]
        if FileManager.default.fileExists(atPath: sharedStringsURL.path) {
            sharedStrings = parseSharedStrings(try String(contentsOf: sharedStringsURL, encoding: .utf8))
        } else {
            sharedStrings = []
        }

        let workbookURL = workspace.appendingPathComponent("xl/workbook.xml")
        let sheetNames = parseSheetNames(try String(contentsOf: workbookURL, encoding: .utf8))

        var sheets: [Sheet] = []
        for (index, name) in sheetNames.enumerated() {
            let sheetURL = workspace.appendingPathComponent("xl/worksheets/sheet\(index + 1).xml")
            guard FileManager.default.fileExists(atPath: sheetURL.path) else { continue }
            let xml = try String(contentsOf: sheetURL, encoding: .utf8)
            sheets.append(Sheet(name: name, rows: parseWorksheet(xml, sharedStrings: sharedStrings)))
        }
        return Workbook(sheets: sheets)
    }

    // MARK: - Unzip

    private static func unzip(_ archive: URL, to directory: URL) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
        process.arguments = ["-x", "-k", archive.path, directory.path]
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw MinimalXLSXReaderError.unzipFailed
        }
    }

    // MARK: - Shared strings

    private static func parseSharedStrings(_ xml: String) -> [String] {
        guard let siRegex = try? NSRegularExpression(pattern: "<si>(.*?)</si>", options: [.dotMatchesLineSeparators]) else {
            return []
        }
        let range = NSRange(xml.startIndex..<xml.endIndex, in: xml)
        return siRegex.matches(in: xml, range: range).compactMap { match in
            guard let swiftRange = Range(match.range(at: 1), in: xml) else { return nil }
            let fragment = String(xml[swiftRange])
            return extractText(from: fragment)
        }
    }

    private static func extractText(from fragment: String) -> String {
        guard let textRegex = try? NSRegularExpression(
            pattern: "<t(?: xml:space=\"preserve\")?>(.*?)</t>",
            options: [.dotMatchesLineSeparators]
        ) else { return "" }
        let range = NSRange(fragment.startIndex..<fragment.endIndex, in: fragment)
        let parts = textRegex.matches(in: fragment, range: range).compactMap { match -> String? in
            guard let swiftRange = Range(match.range(at: 1), in: fragment) else { return nil }
            return unescapeXML(String(fragment[swiftRange]))
        }
        return parts.joined()
    }

    // MARK: - Workbook / worksheet

    private static func parseSheetNames(_ xml: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: "<sheet name=\"([^\"]+)\"", options: []) else {
            return []
        }
        let range = NSRange(xml.startIndex..<xml.endIndex, in: xml)
        return regex.matches(in: xml, range: range).compactMap { match in
            guard let swiftRange = Range(match.range(at: 1), in: xml) else { return nil }
            return unescapeXML(String(xml[swiftRange]))
        }
    }

    private static func parseWorksheet(_ xml: String, sharedStrings: [String]) -> [[String]] {
        guard let rowRegex = try? NSRegularExpression(pattern: "<row r=\"(\\d+)\">(.*?)</row>", options: [.dotMatchesLineSeparators]) else {
            return []
        }
        let range = NSRange(xml.startIndex..<xml.endIndex, in: xml)
        var grid: [Int: [Int: String]] = [:]
        var maxRow = 0
        var maxColumn = 0

        for match in rowRegex.matches(in: xml, range: range) {
            guard
                let rowRange = Range(match.range(at: 1), in: xml),
                let cellsRange = Range(match.range(at: 2), in: xml),
                let rowNumber = Int(xml[rowRange])
            else { continue }

            let rowIndex = rowNumber - 1
            maxRow = max(maxRow, rowIndex)
            let cellsFragment = String(xml[cellsRange])
            for (columnIndex, value) in parseCells(cellsFragment, sharedStrings: sharedStrings) {
                maxColumn = max(maxColumn, columnIndex)
                grid[rowIndex, default: [:]][columnIndex] = value
            }
        }

        guard maxRow >= 0 else { return [] }

        return (0...maxRow).map { row in
            (0...maxColumn).map { column in
                grid[row, default: [:]][column, default: ""]
            }
        }
    }

    private static func parseCells(_ fragment: String, sharedStrings: [String]) -> [(Int, String)] {
        guard let cellRegex = try? NSRegularExpression(
            pattern: "<c r=\"([A-Z]+)(\\d+)\"(?: t=\"([^\"]+)\")?>(.*?)</c>",
            options: [.dotMatchesLineSeparators]
        ) else { return [] }

        let range = NSRange(fragment.startIndex..<fragment.endIndex, in: fragment)
        return cellRegex.matches(in: fragment, range: range).compactMap { match in
            guard
                let lettersRange = Range(match.range(at: 1), in: fragment),
                let contentRange = Range(match.range(at: 4), in: fragment)
            else { return nil }

            let letters = String(fragment[lettersRange])
            let columnIndex = columnIndex(fromLetters: letters)
            let content = String(fragment[contentRange])
            let cellType = match.range(at: 3).location != NSNotFound
                ? String(fragment[Range(match.range(at: 3), in: fragment)!])
                : nil

            if cellType == "s", let index = parseValueIndex(content), sharedStrings.indices.contains(index) {
                return (columnIndex, sharedStrings[index])
            }
            if cellType == "inlineStr" {
                return (columnIndex, extractText(from: content))
            }
            if let value = parseValueText(content) {
                return (columnIndex, value)
            }
            return (columnIndex, "")
        }
    }

    private static func parseValueIndex(_ content: String) -> Int? {
        guard
            let regex = try? NSRegularExpression(pattern: "<v>(\\d+)</v>"),
            let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..<content.endIndex, in: content)),
            let range = Range(match.range(at: 1), in: content)
        else { return nil }
        return Int(content[range])
    }

    private static func parseValueText(_ content: String) -> String? {
        guard
            let regex = try? NSRegularExpression(pattern: "<v>(.*?)</v>", options: [.dotMatchesLineSeparators]),
            let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..<content.endIndex, in: content)),
            let range = Range(match.range(at: 1), in: content)
        else { return nil }
        return unescapeXML(String(content[range]))
    }

    private static func columnIndex(fromLetters letters: String) -> Int {
        letters.unicodeScalars.reduce(0) { value, scalar in
            value * 26 + Int(scalar.value - 65 + 1)
        } - 1
    }

    private static func unescapeXML(_ value: String) -> String {
        value
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&amp;", with: "&")
    }
}
