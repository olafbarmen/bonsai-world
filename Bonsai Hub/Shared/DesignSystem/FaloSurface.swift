//
//  FaloSurface.swift
//  Bonsai World
//
//  Raised informational surface (Dashboard cards today; other modules later).
//  Not for List / Form / Table — those stay native.
//

import SwiftUI

enum FaloSurface {
    static var cornerRadius: CGFloat { FaloRadius.large }
}

extension View {
    /// Quiet raised panel: World raised fill, hairline border, one shadow (Level 2).
    /// Content is clipped to the same continuous corner so edges stay round on all sides.
    func faloRaisedSurface() -> some View {
        let shape = RoundedRectangle(cornerRadius: FaloSurface.cornerRadius, style: .continuous)
        return self
            .clipShape(shape)
            .background {
                shape
                    .fill(BonsaiWorldColors.raisedSurface)
                    .shadow(
                        color: FaloShadow.color,
                        radius: FaloShadow.radius,
                        x: 0,
                        y: FaloShadow.y
                    )
            }
            .overlay {
                shape.strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
            }
    }
}
