//
//  MobileICloudLibraryPrompt.swift
//  Bonsai World
//
//  First launch (B2) — choose iCloud library with Mac, or keep data on this iPhone.
//

import SwiftUI

struct MobileICloudLibraryPrompt: View {
    var onChoose: (MobileLibraryStore.LocationPreference) -> Void

    private var iCloudAvailable: Bool { BonsaiWorldICloudLibrary.isAvailable }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Bonsai World can share one library with the Mac app through iCloud when you use the same Apple ID.")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                }

                Section {
                    Button {
                        onChoose(.iCloud)
                    } label: {
                        Label("Use iCloud with Mac", systemImage: "icloud")
                            .font(FaloTypography.body.weight(.semibold))
                            .foregroundStyle(
                                iCloudAvailable
                                    ? BonsaiWorldColors.accent
                                    : BonsaiWorldColors.textTertiary
                            )
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }
                    .disabled(!iCloudAvailable)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Use iCloud with Mac")
                    .accessibilityHint(
                        iCloudAvailable
                            ? "Opens the shared library in iCloud"
                            : "Sign in to iCloud on this iPhone to enable"
                    )

                    Button {
                        onChoose(.local)
                    } label: {
                        Label("Keep library on this iPhone", systemImage: "iphone")
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Keep library on this iPhone")
                } footer: {
                    Text(
                        iCloudAvailable
                            ? "Avoid editing on Mac and iPhone at the same time. You can change this later in Settings."
                            : "iCloud is not available. You can keep the library on this iPhone and turn on iCloud later in Settings."
                    )
                    .font(FaloTypography.caption)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MobileICloudLibraryPrompt { _ in }
}
