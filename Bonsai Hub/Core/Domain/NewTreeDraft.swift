//
//  NewTreeDraft.swift
//  Bonsai World
//
//  Add Tree create-flow input. Shape only — no UI, platform, or persistence logic.
//  TreeService validates and constructs the Tree from this draft (see
//  ``TreeService/createTree(fromDraft:validLocationIDs:joiningCollectionIDs:)``)
//  so every platform's "Add Tree" UI shares the same validation rules.
//

import Foundation

/// Everything the Add Tree flow gathers before a ``Tree`` can be created.
struct NewTreeDraft: Sendable {
    var nickname: String = ""
    var botanicalName: String = ""
    var bonsaiName: String = ""

    /// Required — Add Tree cannot save without Genus and Species.
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?

    var styleID: UUID?
    var sizeClassID: UUID?
    var treeStatusID: UUID?

    /// Required — Add Tree cannot save without a chosen Location.
    var locationID: UUID?
    var soilMixID: UUID?
    var potTypeID: UUID?
    var lightConditionID: UUID?

    var acquisitionDate: Date?
    var acquisitionMethodID: UUID?
    var acquisitionSourceName: String = ""
    var purchasePrice: Decimal?
    var acquisitionNotes: String = ""
}
