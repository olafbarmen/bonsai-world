//
//  MobileMoreView.swift
//  Bonsai World
//
//  More tab — Settings. Field worlds live on Home.
//

import SwiftUI

struct MobileMoreView: View {
    var onOpenSettings: () -> Void

    var body: some View {
        List {
            Section {
                Button {
                    onOpenSettings()
                } label: {
                    HStack {
                        Label("Settings", systemImage: "gearshape")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(BonsaiWorldColors.textTertiary)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground(BonsaiWorldColors.surface)
                .accessibilityLabel("Settings")
                .accessibilityHint("Opens Settings sheet")
            } footer: {
                Text("Library stays on this device. Export or Import in Settings.")
                    .font(FaloTypography.caption)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("More")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        MobileMoreView(onOpenSettings: {})
    }
}
