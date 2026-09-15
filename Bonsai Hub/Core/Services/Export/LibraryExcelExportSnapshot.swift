//
//  LibraryExcelExportSnapshot.swift
//  Bonsai World
//
//  Pre-resolved spreadsheet rows — safe to write off the main thread.
//

import Foundation

struct LibraryExcelExportSnapshot: Sendable {
    var treeRows: [[String]]
    var workRows: [[String]]
}
