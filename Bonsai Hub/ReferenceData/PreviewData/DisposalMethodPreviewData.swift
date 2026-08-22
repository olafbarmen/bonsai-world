//
//  DisposalMethodPreviewData.swift
//  Bonsai World
//
//  Reference Data — Disposal Methods.
//

import Foundation

enum DisposalMethodPreviewData {
    static let all: [DisposalMethod] = ReferencePreviewSeed.names(list: 9, [
        "Sold",
        "Gifted",
        "Donated",
        "Exchanged",
        "Died",
        "Lost",
        "Other",
    ]).map { DisposalMethod(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
