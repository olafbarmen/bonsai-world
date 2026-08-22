//
//  DashboardIdentity.swift
//  Bonsai World
//
//  Personal Dashboard identity — user logo, collection name, optional subtitle.
//

import Foundation

/// Presentation identity for the Dashboard personal header (placeholder / local only).
struct DashboardIdentity: Hashable, Sendable {
    /// User / studio name shown prominently.
    var brandName: String
    /// User-facing collection name under the brand.
    var collectionName: String
    /// Optional supporting line (e.g. region or motto).
    var subtitle: String?
    /// Future: custom logo asset identifier. `nil` = system mark.
    var logoAssetName: String?

    static let placeholder = DashboardIdentity(
        brandName: "Olaf Bonsai",
        collectionName: "My Bonsai Collection",
        subtitle: nil,
        logoAssetName: nil
    )
}
