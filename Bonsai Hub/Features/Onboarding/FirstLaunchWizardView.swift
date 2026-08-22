//
//  FirstLaunchWizardView.swift
//  Bonsai World
//
//  Welcome / first-launch flow when no valid library is ready.
//  Create New Library or Open Existing Library; future options via FirstLaunchOptionsCatalog.
//

import SwiftUI

struct FirstLaunchWizardView: View {
    @Environment(LibraryService.self) private var libraryService

    @State private var errorMessage: String?
    @State private var isWorking = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: FaloSpacing.xxLarge)

            VStack(spacing: FaloSpacing.large) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 64, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)

                VStack(spacing: FaloSpacing.small) {
                    Text("Welcome to \(WorldIdentity.appName)")
                        .font(.largeTitle.weight(.semibold))
                        .multilineTextAlignment(.center)

                    Text("Create a new Bonsai World Library or open one you already have. Your trees, images, and notes live in this library.")
                        .font(FaloTypography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 420)
                }
            }

            Spacer(minLength: FaloSpacing.xxLarge)

            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                ForEach(FirstLaunchOptionsCatalog.primaryOptions) { option in
                    FirstLaunchOptionRow(option: option) {
                        Task { await handle(option) }
                    }
                    .disabled(isWorking || !option.isEnabled)
                }

                if !FirstLaunchOptionsCatalog.futureOptions.isEmpty {
                    Divider()
                        .padding(.vertical, FaloSpacing.small)

                    Text("Coming Soon")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)

                    ForEach(FirstLaunchOptionsCatalog.futureOptions) { option in
                        FirstLaunchOptionRow(option: option) {}
                            .disabled(true)
                    }
                }
            }
            .frame(maxWidth: 480)

            if let errorMessage {
                Text(errorMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 480)
                    .padding(.top, FaloSpacing.large)
                    .accessibilityLabel("Error: \(errorMessage)")
            }

            Spacer(minLength: FaloSpacing.xxLarge)
        }
        .padding(FaloSpacing.xxLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }

    private func handle(_ option: FirstLaunchOption) async {
        errorMessage = nil
        isWorking = true
        defer { isWorking = false }

        do {
            switch option.id {
            case FirstLaunchOptionsCatalog.createNewID:
                _ = try await libraryService.createNewLibraryUsingFolderPicker()
            case FirstLaunchOptionsCatalog.openExistingID:
                _ = try await libraryService.openExistingLibraryUsingFolderPicker()
            default:
                break
            }
        } catch LibraryError.folderPickerCancelled {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Option row

private struct FirstLaunchOptionRow: View {
    let option: FirstLaunchOption
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: FaloSpacing.medium) {
                Image(systemName: option.systemImage)
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text(option.title)
                        .font(FaloTypography.body.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(option.subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)

                if case .comingSoon = option.availability {
                    Text("Coming Soon")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(FaloSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(Color.primary.opacity(option.isEnabled ? 0.04 : 0.02))
            )
            .overlay(
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .help(helpText)
        .opacity(option.isEnabled ? 1 : 0.65)
    }

    private var helpText: String {
        switch option.availability {
        case .available:
            return option.subtitle
        case .comingSoon:
            return "\(option.subtitle) — Coming soon"
        case .disabled(let reason):
            return reason ?? option.subtitle
        }
    }
}

#Preview {
    FirstLaunchWizardView()
        .environment(LibraryService(storage: StorageService.shared))
        .frame(width: 640, height: 720)
}
