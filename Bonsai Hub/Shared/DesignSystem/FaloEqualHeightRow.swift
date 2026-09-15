//
//  FaloEqualHeightRow.swift
//  Bonsai World
//
//  Shared row layout — children share the tallest height so card bottoms align
//  (Dashboard and Tree Overview 4-column grids).
//

import SwiftUI

/// Lays out children in a row at the tallest child’s height.
struct FaloEqualHeightRow<Content: View>: View {
    var spacing: CGFloat
    @ViewBuilder var content: () -> Content

    var body: some View {
        FaloEqualHeightRowLayout(spacing: spacing) {
            content()
        }
    }
}

private struct FaloEqualHeightRowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let widths = subviewWidths(proposal: proposal, subviews: subviews)
        let height = zip(subviews, widths).map { subview, width in
            subview.sizeThatFits(ProposedViewSize(width: width, height: nil)).height
        }.max() ?? 0

        let totalWidth = widths.reduce(0, +) + spacing * CGFloat(subviews.count - 1)
        return CGSize(width: totalWidth, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }

        let widths = subviewWidths(
            proposal: ProposedViewSize(width: bounds.width, height: bounds.height),
            subviews: subviews
        )
        let height = bounds.height
        var x = bounds.minX

        for (subview, width) in zip(subviews, widths) {
            subview.place(
                at: CGPoint(x: x, y: bounds.minY),
                anchor: .topLeading,
                proposal: ProposedViewSize(width: width, height: height)
            )
            x += width + spacing
        }
    }

    private func subviewWidths(proposal: ProposedViewSize, subviews: Subviews) -> [CGFloat] {
        let count = CGFloat(subviews.count)
        let spacingTotal = spacing * max(0, count - 1)
        let proposedWidth = proposal.width ?? .infinity

        let ideals = subviews.map { subview -> CGFloat in
            let ideal = subview.sizeThatFits(ProposedViewSize(width: nil, height: nil)).width
            let minW = subview.sizeThatFits(ProposedViewSize(width: 0, height: nil)).width
            return max(ideal, minW)
        }

        let idealsTotal = ideals.reduce(0, +)

        // When the parent proposes a finite width, keep declared `.frame(width:)` ideals
        // only if they fit; otherwise scale them down so later columns stay on-screen.
        if proposedWidth.isFinite, proposedWidth > spacingTotal {
            let available = proposedWidth - spacingTotal
            if idealsTotal > 0, idealsTotal <= available + 0.5 {
                return ideals
            }
            if idealsTotal > 0 {
                let scale = available / idealsTotal
                return ideals.map { $0 * scale }
            }
            return Array(repeating: available / count, count: subviews.count)
        }

        if idealsTotal <= 0 {
            let available = max(0, (proposedWidth.isFinite ? proposedWidth : 0) - spacingTotal)
            return Array(repeating: available / max(count, 1), count: subviews.count)
        }
        return ideals
    }
}