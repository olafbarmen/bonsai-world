//
//  TreeImageViewerContext.swift
//  Bonsai World
//
//  Session model for the Tree Image Viewer window.
//  Holds gallery identity + selection so future zoom / pan / next-previous /
//  slideshow / compare / before-after / history can attach without redesign.
//

import Foundation

/// Opens the dedicated Tree Image Viewer over Tree Detail.
struct TreeImageViewerContext: Identifiable, Codable, Hashable, Sendable {
    /// Stable window identity for this viewing session.
    var id: UUID
    /// Owning tree — return context after close stays on this tree.
    var treeID: UUID
    /// Ordered gallery (chronological / stored `imageIDs` order).
    var imageIDs: [UUID]
    /// Image shown as the main preview when the viewer opens.
    var selectedImageID: UUID

    // MARK: - Future extension points (not used yet)

    /// Reserved for before/after and side-by-side comparison.
    var comparisonImageID: UUID? = nil
    /// Reserved for viewer presentation modes (single, compare, slideshow, history).
    var presentationMode: TreeImageViewerPresentationMode = .single

    init(
        id: UUID = UUID(),
        treeID: UUID,
        imageIDs: [UUID],
        selectedImageID: UUID,
        comparisonImageID: UUID? = nil,
        presentationMode: TreeImageViewerPresentationMode = .single
    ) {
        self.id = id
        self.treeID = treeID
        self.imageIDs = imageIDs
        self.selectedImageID = selectedImageID
        self.comparisonImageID = comparisonImageID
        self.presentationMode = presentationMode
    }

    var selectedIndex: Int? {
        imageIDs.firstIndex(of: selectedImageID)
    }
}

/// Viewer modes reserved for future Photo Manager capabilities.
enum TreeImageViewerPresentationMode: String, Codable, Hashable, Sendable {
    case single
    case compare
    case beforeAfter
    case slideshow
    case history
}

/// Documented capabilities — architecture only; no UI wiring yet.
enum TreeImageViewerCapability: String, CaseIterable, Sendable {
    case zoom
    case pan
    case nextPrevious
    case slideshow
    case compare
    case beforeAfter
    case history
}

extension TreeImageViewerContext {
    static let windowID = "tree-image-viewer"
}
