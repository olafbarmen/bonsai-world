//
//  DashboardHeaderView.swift
//  Bonsai World
//
//  Personal identity header above the My Trees hero.
//

import SwiftUI

struct DashboardHeaderView: View {
    let identity: DashboardIdentity

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.large) {
            logoMark

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(identity.brandName)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)

                Text(identity.collectionName)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)

                if let subtitle = identity.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
    }

    private var accessibilityLabelText: String {
        var parts = [identity.brandName, identity.collectionName]
        if let subtitle = identity.subtitle, !subtitle.isEmpty {
            parts.append(subtitle)
        }
        return parts.joined(separator: ", ")
    }

    @ViewBuilder
    private var logoMark: some View {
        if let logoAssetName = identity.logoAssetName {
            Image(logoAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous))
        } else {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 48))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)
                .frame(width: 56, height: 56)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    DashboardHeaderView(identity: .placeholder)
        .padding()
}
