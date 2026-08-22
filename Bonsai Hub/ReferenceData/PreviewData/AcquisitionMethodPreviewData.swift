//
//  AcquisitionMethodPreviewData.swift
//  Bonsai World
//
//  Reference Data — Acquisition Methods.
//

import Foundation

enum AcquisitionMethodPreviewData {
    static let all: [AcquisitionMethod] = ReferencePreviewSeed.names(list: 6, [
        "Nursery",
        "Garden Centre",
        "Bonsai Dealer",
        "Private Seller",
        "Friend",
        "Club Member",
        "Seed",
        "Cutting",
        "Air Layer",
        "Yamadori",
        "Gift",
        "Auction",
        "Online Marketplace",
        "Other",
    ]).map { AcquisitionMethod(id: $0.id, name: $0.name, sortOrder: $0.sortOrder) }
}
