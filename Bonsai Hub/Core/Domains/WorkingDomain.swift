//
//  WorkingDomain.swift
//  Bonsai World
//
//  Working domain identities — Domain-Driven terminology for Bonsai Hub.
//
//  These are working names (human garden language), not storage keys and not
//  UI chrome. Display strings live only in ``WorkingDomainCatalog`` so renaming
//  a domain requires editing the catalog — not models, services, or file paths.
//
//  Technical modules (AppRoute / AppModule, services, Reference Data) remain the
//  implementation bounded contexts; domains describe how growers think.
//

import Foundation

/// Stable domain identity. Prefer this over display strings in code.
///
/// Raw values are intentional plumbing IDs — do not show them to users.
/// To rename a domain for humans, change ``WorkingDomainCatalog`` only.
enum WorkingDomainID: String, CaseIterable, Identifiable, Hashable, Sendable {
    // MARK: Active working domains

    /// Practical care work — wiring, pruning, watering, fertilizing, winter work.
    case workshop
    /// Environment where trees grow — gardens, locations, microclimate.
    case habitat
    /// Creating and developing trees — propagation through refinement.
    case nursery
    /// Rule-based knowledge and recommendation engine (not AI).
    case growingIntelligence
    /// Digital assets — images, documents, notes, video, audio.
    case media

    // MARK: Reserved for later (architecture only — no module restructuring)

    case journal
    case learning
    case marketplace

    var id: Self { self }

    /// Domains that are actively named in the product architecture today.
    static var introduced: [WorkingDomainID] {
        [.workshop, .habitat, .nursery, .growingIntelligence, .media]
    }

    /// Domains reserved so future introduction does not require restructuring.
    static var reserved: [WorkingDomainID] {
        [.journal, .learning, .marketplace]
    }
}

/// Lifecycle of a working domain relative to shipped product surface.
enum WorkingDomainStatus: String, Hashable, Sendable {
    /// Named and mapped to existing technical modules / services.
    case active
    /// Identity reserved; no dedicated surface yet.
    case reserved
}
