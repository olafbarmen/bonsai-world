//
//  ModulePlaceholderView.swift
//  Bonsai World
//
//  Architecture Version 2 — navigation placeholder for routes not yet built.
//  Does not implement domain behaviour.
//

import SwiftUI

struct ModulePlaceholderView: View {
    let title: String
    var systemImage: String = "square.dashed"
    var purpose: String
    var items: [String] = []

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                Text(purpose)
                if !items.isEmpty {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Prepared for")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                        ForEach(items, id: \.self) { item in
                            Text("· \(item)")
                                .font(FaloTypography.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .frame(maxWidth: 420, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
        .navigationTitle(title)
    }
}
