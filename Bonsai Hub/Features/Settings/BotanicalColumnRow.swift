//
//  BotanicalColumnRow.swift
//  Bonsai World
//
//  Compact row for Botanical Library columns.
//

import SwiftUI

struct BotanicalColumnRow: View {
    let title: String
    let isActive: Bool
    var onActiveChange: (Bool) -> Void

    var body: some View {
        HStack(spacing: FaloSpacing.small) {
            Text(title)
                .font(FaloTypography.body)
                .lineLimit(1)

            Spacer(minLength: FaloSpacing.small)

            Toggle(
                "Active",
                isOn: Binding(
                    get: { isActive },
                    set: { onActiveChange($0) }
                )
            )
            .labelsHidden()
            .toggleStyle(.switch)
            .controlSize(.mini)
            .help(isActive ? "Active" : "Inactive")
        }
        .padding(.vertical, 2)
        .opacity(isActive ? 1 : 0.55)
    }
}
