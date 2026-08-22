//
//  EmptyStateView.swift
//  Bonsai World
//
//  Compact empty state for Detail sections and lists.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    var systemImage: String?
    var description: String?

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack(alignment: .top, spacing: FaloSpacing.small) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .symbolRenderingMode(.hierarchical)
                        .frame(width: 22, height: 22, alignment: .center)
                }

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(title)
                        .font(FaloTypography.body)
                        .foregroundStyle(.secondary)

                    if let description, !description.isEmpty {
                        Text(description)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, FaloSpacing.small)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    EmptyStateView(
        title: "No Collections yet",
        systemImage: "square.stack.3d.up",
        description: "Collections that live here will appear in this list."
    )
    .padding()
    .frame(width: 420)
}
