//
//  ImagePresentationContext.swift
//  Bonsai World
//
//  Where a display crop is shown. One Original can have a crop per context.
//

import Foundation

/// Display surface for a non-destructive presentation crop.
enum ImagePresentationContext: String, Codable, Hashable, Sendable, CaseIterable {
    case treeThumbnail
    case galleryCard
    case dashboard
    case collectionCard
}
