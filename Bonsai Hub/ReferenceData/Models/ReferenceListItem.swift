//
//  ReferenceListItem.swift
//  Bonsai World
//
//  Shared shape for flat Reference Data libraries (Add / Edit / Delete / Active).
//  Botanical Genus / Species / Cultivar stay hierarchical and do not use this protocol.
//

import Foundation

/// Flat master-data row: identity, display name, ordering, and active flag.
protocol ReferenceListItem: Identifiable, Codable, Hashable, Sendable where ID == UUID {
    var id: UUID { get set }
    var name: String { get set }
    var sortOrder: Int { get set }
    var isActive: Bool { get set }

    init(id: UUID, name: String, sortOrder: Int, isActive: Bool)
}

extension ReferenceListItem {
    static func mapRecords(_ items: [Self]) -> [ReferenceDataRecord] {
        items
            .map {
                ReferenceDataRecord(
                    id: $0.id,
                    name: $0.name,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive
                )
            }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    static func upsert(_ draft: ReferenceDataDraft, into array: inout [Self]) {
        if let id = draft.entityID, let index = array.firstIndex(where: { $0.id == id }) {
            array[index].name = draft.name
            array[index].sortOrder = draft.sortOrder
            array[index].isActive = draft.isActive
        } else {
            array.append(
                Self(
                    id: UUID(),
                    name: draft.name,
                    sortOrder: draft.sortOrder,
                    isActive: draft.isActive
                )
            )
        }
    }

    static func setActive(_ id: UUID, isActive: Bool, in array: inout [Self]) {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        array[index].isActive = isActive
    }

    static func delete(_ id: UUID, from array: inout [Self]) {
        array.removeAll { $0.id == id }
    }
}

/// Name surface for pickers and Detail option mapping.
protocol ReferenceNamedItem {
    var name: String { get }
}

extension AcquisitionMethod: ReferenceNamedItem {}
extension DisposalMethod: ReferenceNamedItem {}
extension Supplier: ReferenceNamedItem {}
extension Country: ReferenceNamedItem {}
extension Style: ReferenceNamedItem {}
extension SizeClass: ReferenceNamedItem {}
extension TreeStatus: ReferenceNamedItem {}
extension WorkType: ReferenceNamedItem {}
extension DevelopmentStage: ReferenceNamedItem {}
extension LocationReference: ReferenceNamedItem {}
extension LocationType: ReferenceNamedItem {}
extension PotType: ReferenceNamedItem {}
extension LightCondition: ReferenceNamedItem {}
extension SoilComponent: ReferenceNamedItem {}
extension SoilMix: ReferenceNamedItem {}
extension FertilizerType: ReferenceNamedItem {}
extension InventoryPot: ReferenceNamedItem {}
extension Tool: ReferenceNamedItem {}
extension Wire: ReferenceNamedItem {}
extension Chemical: ReferenceNamedItem {}
