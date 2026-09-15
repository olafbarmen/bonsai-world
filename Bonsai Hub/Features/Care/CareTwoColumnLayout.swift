//
//  CareTwoColumnLayout.swift
//  Bonsai World
//
//  Shared Care workspace layout — primary (due / attention) beside secondary
//  (recent / guidance) so long lists do not bury the other column.
//
//  Uses a plain HStack (not ViewThatFits) — ViewThatFits inside ScrollView
//  asserted on macOS when measuring both branches.
//

import SwiftUI

struct CareTwoColumnLayout<Primary: View, Secondary: View>: View {
    var primary: Primary
    var secondary: Secondary

    init(
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.primary = primary()
        self.secondary = secondary()
    }

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                primary
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge + FaloSpacing.large) {
                secondary
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
