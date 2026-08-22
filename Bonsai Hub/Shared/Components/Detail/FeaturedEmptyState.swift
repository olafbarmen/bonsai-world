//
//  FeaturedEmptyState.swift
//  Bonsai World
//
//  Attractive empty state for module lists and Detail sections.
//

import SwiftUI

struct FeaturedEmptyState<Actions: View>: View {
    let title: String
    var systemImage: String
    var description: String
    @ViewBuilder var actions: () -> Actions

    init(
        title: String,
        systemImage: String,
        description: String,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
        self.actions = actions
    }

    var body: some View {
        VStack(spacing: FaloSpacing.large) {
            Image(systemName: systemImage)
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .accessibilityHidden(true)

            VStack(spacing: FaloSpacing.small) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(description)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 360)
            }

            actions()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(FaloSpacing.xxLarge)
        .accessibilityElement(children: .contain)
    }
}

extension FeaturedEmptyState where Actions == EmptyView {
    init(title: String, systemImage: String, description: String) {
        self.init(title: title, systemImage: systemImage, description: description) {
            EmptyView()
        }
    }
}

#Preview {
    FeaturedEmptyState(
        title: "No Collections yet",
        systemImage: "square.stack.3d.up",
        description: "Use Quick Actions → New Collection to create a group."
    )
}
