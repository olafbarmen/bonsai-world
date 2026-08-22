//
//  OwnershipFieldLabels.swift
//  Bonsai World
//
//  Dynamic free-text field labels for Acquisition / Disposal methods.
//  Matches Reference Data method names (case-insensitive); falls back to a generic label.
//

import Foundation

enum OwnershipFieldLabels {

    /// Label for the acquisition free-text source field.
    static func acquisitionSourceLabel(methodName: String?) -> String {
        switch normalized(methodName) {
        case "nursery": "Nursery Name"
        case "garden centre", "garden center": "Nursery Name"
        case "bonsai dealer": "Dealer Name"
        case "private seller": "Seller Name"
        case "friend": "Friend Name"
        case "club member": "Member Name"
        case "seed": "Seed Supplier"
        case "cutting": "Source Tree"
        case "air layer": "Source Tree"
        case "yamadori": "Collection Area"
        case "gift": "Gift From"
        case "auction": "Auction Name"
        case "online marketplace": "Seller Name"
        case "other": "Source Name"
        default: "Source Name"
        }
    }

    /// Label for the disposal free-text party / detail field.
    static func disposalPartyLabel(methodName: String?) -> String {
        switch normalized(methodName) {
        case "sold": "Buyer"
        case "gifted": "Recipient"
        case "donated": "Organization"
        case "exchanged": "Exchange Partner"
        case "lost": "Description"
        case "died": "Cause"
        case "other": "Recipient"
        default: "Buyer / Recipient"
        }
    }

    private static func normalized(_ name: String?) -> String {
        (name ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
