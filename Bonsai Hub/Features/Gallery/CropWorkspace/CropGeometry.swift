//
//  CropGeometry.swift
//  Bonsai World
//
//  Normalized crop rectangle math for the Crop Workspace canvas.
//

import CoreGraphics

enum CropGeometry {
    static let unitBounds = CGRect(x: 0, y: 0, width: 1, height: 1)

    /// Normalized width:height that yields `visualAspect` (pixel width / height) on `imageSize`.
    static func normalizedAspect(visualAspect: CGFloat, imageSize: CGSize) -> CGFloat {
        guard imageSize.width > 0, imageSize.height > 0, visualAspect > 0 else {
            return visualAspect
        }
        let pixelAspect = imageSize.width / imageSize.height
        return visualAspect / pixelAspect
    }

    /// Largest centered crop with the given aspect ratio inside unit bounds.
    static func centeredCrop(aspectRatio: CGFloat?, in bounds: CGRect = unitBounds) -> CGRect {
        guard let aspectRatio, aspectRatio > 0 else { return bounds }
        let boundsAspect = bounds.width / bounds.height

        var width: CGFloat
        var height: CGFloat
        if aspectRatio > boundsAspect {
            width = bounds.width
            height = width / aspectRatio
        } else {
            height = bounds.height
            width = height * aspectRatio
        }

        return CGRect(
            x: bounds.minX + (bounds.width - width) / 2,
            y: bounds.minY + (bounds.height - height) / 2,
            width: width,
            height: height
        )
    }

    /// Same center as `rect`, resized to `aspectRatio` (normalized width / height).
    static func matchingAspect(_ rect: CGRect, aspectRatio: CGFloat, in bounds: CGRect = unitBounds) -> CGRect {
        guard aspectRatio > 0 else { return clamp(rect, in: bounds) }

        let currentAspect = rect.width / max(rect.height, 0.001)
        var width: CGFloat
        var height: CGFloat
        if abs(currentAspect - aspectRatio) < 0.002 {
            width = rect.width
            height = rect.height
        } else if currentAspect > aspectRatio {
            height = rect.height
            width = height * aspectRatio
        } else {
            width = rect.width
            height = width / aspectRatio
        }

        let maxFitted = centeredCrop(aspectRatio: aspectRatio, in: bounds)
        if width > maxFitted.width + 0.0001 {
            width = maxFitted.width
            height = maxFitted.height
        }

        let fitted = CGRect(
            x: rect.midX - width / 2,
            y: rect.midY - height / 2,
            width: width,
            height: height
        )
        return clampedOrigin(fitted, in: bounds)
    }

    static func clampedOrigin(_ rect: CGRect, in bounds: CGRect) -> CGRect {
        var result = rect
        result.origin.x = min(max(result.origin.x, bounds.minX), bounds.maxX - result.width)
        result.origin.y = min(max(result.origin.y, bounds.minY), bounds.maxY - result.height)
        return result
    }

    /// Applies aspect lock when resizing from a handle.
    static func resize(
        rect: CGRect,
        handle: CropHandle,
        translation: CGSize,
        aspectRatio: CGFloat?,
        in bounds: CGRect = unitBounds
    ) -> CGRect {
        var next = rect

        switch handle {
        case .topLeft:
            next.origin.x += translation.width
            next.origin.y += translation.height
            next.size.width -= translation.width
            next.size.height -= translation.height
        case .top:
            next.origin.y += translation.height
            next.size.height -= translation.height
        case .topRight:
            next.size.width += translation.width
            next.origin.y += translation.height
            next.size.height -= translation.height
        case .right:
            next.size.width += translation.width
        case .bottomRight:
            next.size.width += translation.width
            next.size.height += translation.height
        case .bottom:
            next.size.height += translation.height
        case .bottomLeft:
            next.origin.x += translation.width
            next.size.width -= translation.width
            next.size.height += translation.height
        case .left:
            next.origin.x += translation.width
            next.size.width -= translation.width
        case .body:
            next.origin.x += translation.width
            next.origin.y += translation.height
        }

        if let aspectRatio, handle != .body {
            next = enforceAspect(next, handle: handle, aspectRatio: aspectRatio)
        }

        return clamp(next, in: bounds)
    }

    static func move(_ rect: CGRect, by translation: CGSize, in bounds: CGRect = unitBounds) -> CGRect {
        clamp(
            CGRect(
                x: rect.origin.x + translation.width,
                y: rect.origin.y + translation.height,
                width: rect.width,
                height: rect.height
            ),
            in: bounds
        )
    }

    static func viewRect(from normalized: CGRect, in imageFrame: CGRect) -> CGRect {
        CGRect(
            x: imageFrame.minX + normalized.minX * imageFrame.width,
            y: imageFrame.minY + normalized.minY * imageFrame.height,
            width: normalized.width * imageFrame.width,
            height: normalized.height * imageFrame.height
        )
    }

    static func normalizedRect(from viewRect: CGRect, in imageFrame: CGRect) -> CGRect {
        guard imageFrame.width > 0, imageFrame.height > 0 else { return unitBounds }
        return CGRect(
            x: (viewRect.minX - imageFrame.minX) / imageFrame.width,
            y: (viewRect.minY - imageFrame.minY) / imageFrame.height,
            width: viewRect.width / imageFrame.width,
            height: viewRect.height / imageFrame.height
        )
    }

    // MARK: - Private

    private static func enforceAspect(
        _ rect: CGRect,
        handle: CropHandle,
        aspectRatio: CGFloat
    ) -> CGRect {
        var result = rect
        let currentAspect = rect.width / max(rect.height, 0.001)

        if currentAspect > aspectRatio {
            result.size.width = result.height * aspectRatio
            if handle.isLeft {
                result.origin.x = rect.maxX - result.width
            }
        } else {
            result.size.height = result.width / aspectRatio
            if handle.isTop {
                result.origin.y = rect.maxY - result.height
            }
        }
        return result
    }

    private static func clamp(_ rect: CGRect, in bounds: CGRect) -> CGRect {
        let minSize: CGFloat = 0.08
        var result = rect
        result.size.width = max(result.width, minSize)
        result.size.height = max(result.height, minSize)

        if result.size.width > bounds.width {
            result.size.width = bounds.width
        }
        if result.size.height > bounds.height {
            result.size.height = bounds.height
        }

        result.origin.x = min(max(result.origin.x, bounds.minX), bounds.maxX - result.width)
        result.origin.y = min(max(result.origin.y, bounds.minY), bounds.maxY - result.height)
        return result
    }
}

/// Resize / move handles on the crop frame.
enum CropHandle: CaseIterable, Hashable {
    case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left, body

    var isCorner: Bool {
        switch self {
        case .topLeft, .topRight, .bottomLeft, .bottomRight: true
        default: false
        }
    }

    var isLeft: Bool {
        switch self {
        case .topLeft, .left, .bottomLeft: true
        default: false
        }
    }

    var isTop: Bool {
        switch self {
        case .topLeft, .top, .topRight: true
        default: false
        }
    }
}
