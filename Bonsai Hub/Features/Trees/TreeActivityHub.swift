//
//  TreeActivityHub.swift
//  Bonsai World
//
//  Tree activity kinds — registration is owned by the Tree; other modules consume.
//  Grower entry point: Context Tools → Add Work / Add Measurement / Add Photo
//  (not an in-page registration menu on Tree Detail).
//
//  Ownership rule (one action, one registration, many consumers):
//  • Tree — register activities on this bonsai
//  • Shaping — planning (consumes Tree registrations)
//  • Care — recommendations (consumes Tree registrations)
//  • Tasks — scheduling (consumes Tree registrations)
//  • Media — asset management (consumes photo/document registrations)
//  • Inventory — physical assets (consumes pot/tool assignments)
//  • Timeline — chronological history (read-only consumer; never registers)
//

import Foundation

/// Activity kinds for Tree registration (Context Tools and future hubs).
enum TreeActivityKind: String, CaseIterable, Identifiable {
    case work
    case care
    case measurement
    case photo
    case journal
    case document

    var id: Self { self }

    var title: String {
        switch self {
        case .work: "Work"
        case .care: "Care"
        case .measurement: "Measurement"
        case .photo: "Photo"
        case .journal: "Journal"
        case .document: "Document"
        }
    }

    /// Work, Measurement, Photo, and Journal have live Context Tools / sheet paths today.
    var isImplemented: Bool {
        switch self {
        case .work, .measurement, .photo, .journal: true
        case .care, .document: false
        }
    }
}
