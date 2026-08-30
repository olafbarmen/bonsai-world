//
//  GalleryImageStatus.swift
//  Bonsai World
//
//  Shared status vocabulary for Images browser cards and Inspector.
//

import SwiftUI

/// Canonical status labels — identical language on every surface.
enum GalleryImageStatusLabel {
    static let primary = "Primary"
    static let featured = "Featured"
    static let attached = "Attached"
    static let aiReviewed = "AI Reviewed"
}

/// Unified status strip — fixed height, consistent placement on every card.
struct GalleryImageStatusArea: View {
    let entry: GalleryEntry
    let showsFeatured: Bool

    var body: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            if entry.hasTreeContext {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.attached,
                    systemImage: "link"
                )
            }
            if entry.isPrimary {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.primary,
                    systemImage: "star.fill"
                )
            }
            if showsFeatured, entry.isFeatured {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.featured,
                    systemImage: "sparkles"
                )
            }
            Spacer(minLength: 0)
        }
        .frame(height: GalleryLayout.statusRowHeight, alignment: .leading)
    }
}

/// Inspector status row — same labels; includes inactive-state messaging.
struct GalleryImageInspectorStatusArea: View {
    let entry: GalleryEntry
    let showsFeatured: Bool

    var body: some View {
        GalleryImageStatusFlowLayout(spacing: FaloSpacing.xSmall) {
            if entry.hasTreeContext {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.attached,
                    systemImage: "link"
                )
            }
            if entry.isPrimary {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.primary,
                    systemImage: "star.fill"
                )
            }
            if showsFeatured, entry.isFeatured {
                GalleryStatusChip(
                    title: GalleryImageStatusLabel.featured,
                    systemImage: "sparkles"
                )
            }
            if !entry.hasTreeContext, !entry.isPrimary, !(showsFeatured && entry.isFeatured) {
                Text("No status flags")
                    .font(FaloTypography.caption)
                    .foregroundStyle(FaloColors.textSecondary)
            }
        }
    }
}

struct GalleryStatusChip: View {
    let title: String
    let systemImage: String
    var isPlaceholder: Bool = false

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption2.weight(.medium))
            .labelStyle(.titleAndIcon)
            .foregroundStyle(isPlaceholder ? FaloColors.textSecondary.opacity(0.45) : FaloColors.textSecondary)
            .padding(.horizontal, FaloSpacing.xSmall)
            .padding(.vertical, 2)
            .background(Color.primary.opacity(isPlaceholder ? 0.03 : 0.05), in: Capsule())
            .lineLimit(1)
    }
}

// MARK: - Flow layout

struct GalleryImageStatusFlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(
        proposal: ProposedViewSize,
        subviews: Subviews
    ) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
