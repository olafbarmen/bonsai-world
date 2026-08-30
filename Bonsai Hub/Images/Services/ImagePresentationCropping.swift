//
//  ImagePresentationCropping.swift
//  Bonsai World
//
//  Pixel crop of an Original using a normalized (0…1) presentation rectangle.
//  Top-left origin, matching SwiftUI crop overlay. Never writes files.
//

import AppKit
import CoreGraphics
import Foundation
import ImageIO

enum ImagePresentationCropping {
    /// Returns `original` when the crop is full-frame or cannot be applied.
    static func croppedImage(from original: NSImage, normalizedCrop: CGRect) -> NSImage {
        let crop = sanitized(normalizedCrop)
        guard !isFullFrame(crop) else { return original }
        guard let cgImage = cgImage(from: original) else { return original }

        let pixelBounds = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        let pixelCrop = CGRect(
            x: crop.minX * pixelBounds.width,
            y: crop.minY * pixelBounds.height,
            width: crop.width * pixelBounds.width,
            height: crop.height * pixelBounds.height
        )
        .integral
        .intersection(pixelBounds)

        guard pixelCrop.width >= 1, pixelCrop.height >= 1,
              let cropped = cgImage.cropping(to: pixelCrop) else {
            return original
        }

        return NSImage(cgImage: cropped, size: NSSize(width: cropped.width, height: cropped.height))
    }

    /// Decode `data` off the hot path. When `maxPixelSize` is set, uses an ImageIO thumbnail
    /// so list cells never materialize a full-resolution Original.
    static func displayImage(
        from data: Data,
        normalizedCrop: CGRect,
        maxPixelSize: Int? = nil
    ) -> NSImage? {
        if let maxPixelSize {
            return thumbnail(from: data, normalizedCrop: normalizedCrop, maxPixelSize: maxPixelSize)
        }
        guard let original = NSImage(data: data) else { return nil }
        return croppedImage(from: original, normalizedCrop: normalizedCrop)
    }

    private static func thumbnail(
        from data: Data,
        normalizedCrop: CGRect,
        maxPixelSize: Int
    ) -> NSImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceShouldCacheImmediately: true
        ]
        guard let cgThumb = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
            return nil
        }
        let thumb = NSImage(
            cgImage: cgThumb,
            size: NSSize(width: cgThumb.width, height: cgThumb.height)
        )
        return croppedImage(from: thumb, normalizedCrop: normalizedCrop)
    }

    static func isFullFrame(_ crop: CGRect) -> Bool {
        let c = sanitized(crop)
        return c.minX <= 0.001
            && c.minY <= 0.001
            && c.maxX >= 0.999
            && c.maxY >= 0.999
    }

    private static func sanitized(_ crop: CGRect) -> CGRect {
        crop.standardized.intersection(CGRect(x: 0, y: 0, width: 1, height: 1))
    }

    private static func cgImage(from nsImage: NSImage) -> CGImage? {
        if let tiff = nsImage.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiff),
           let cgImage = bitmap.cgImage {
            return cgImage
        }

        var rect = CGRect(origin: .zero, size: nsImage.size)
        return nsImage.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
