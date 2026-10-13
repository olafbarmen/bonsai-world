//
//  FirstLaunchWizardView.swift
//  Bonsai World
//
//  First-launch flow: start fresh, restore ZIP, or open an existing library.
//  New libraries propose the safe default place; user may choose another.
//

import SwiftUI
import UniformTypeIdentifiers

struct FirstLaunchWizardView: View {
    @Environment(LibraryService.self) private var libraryService
    @Environment(StorageService.self) private var storageService
    @Environment(UserProfileStore.self) private var userProfile

    @State private var step: Step = .welcome
    @State private var pendingAfterPlace: PlaceFollowUp = .openEmpty
    @State private var errorMessage: String?
    @State private var isWorking = false

    private enum Step {
        case welcome
        case proposePlace
    }

    private enum PlaceFollowUp {
        /// Create empty library and enter the app.
        case openEmpty
        /// Create library, then restore a ZIP into it.
        case restoreZip
    }

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
                    Text(headerTitle)
                        .font(.largeTitle.weight(.semibold))
                        .multilineTextAlignment(.center)

                    Text(headerSubtitle)
                        .font(FaloTypography.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 440)
                }
            }

            Spacer(minLength: FaloSpacing.xxLarge)

            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                switch step {
                case .welcome:
                    welcomeOptions
                case .proposePlace:
                    proposePlaceOptions
                }
            }
            .frame(maxWidth: 500)

            if let errorMessage {
                Text(errorMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.statusCritical)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 500)
                    .padding(.top, FaloSpacing.large)
                    .accessibilityLabel("Error: \(errorMessage)")
            }

            Spacer(minLength: FaloSpacing.xxLarge)
        }
        .padding(FaloSpacing.xxLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
    }

    private var headerTitle: String {
        switch step {
        case .welcome:
            "Welcome to \(WorldIdentity.appName)"
        case .proposePlace:
            "Where should your library live?"
        }
    }

    private var headerSubtitle: String {
        switch step {
        case .welcome:
            "Your trees, images, and notes live in one library. Choose how you want to begin."
        case .proposePlace:
            pendingAfterPlace == .restoreZip
                ? "First we create a place for the library. Then you choose your ZIP backup."
                : "Most people use the place Bonsai World suggests. You can change this later in Settings."
        }
    }

    @ViewBuilder
    private var welcomeOptions: some View {
        ForEach(FirstLaunchOptionsCatalog.primaryOptions) { option in
            FirstLaunchOptionRow(option: option) {
                Task { await handleWelcome(option) }
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

    @ViewBuilder
    private var proposePlaceOptions: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Suggested place")
                .font(FaloTypography.caption.weight(.medium))
                .foregroundStyle(.secondary)
            Text(StorageService.defaultLibraryPathDisplay)
                .font(FaloTypography.body.weight(.medium))
                .textSelection(.enabled)
        }
        .padding(FaloSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .fill(Color.primary.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        )

        FirstLaunchOptionRow(
            option: FirstLaunchOption(
                id: "firstLaunch.useSuggested",
                title: "Use this place",
                subtitle: "Recommended. Bonsai World remembers it for next time.",
                systemImage: "checkmark.circle",
                availability: .available
            )
        ) {
            Task { await useSuggestedPlace() }
        }
        .disabled(isWorking)

        FirstLaunchOptionRow(
            option: FirstLaunchOption(
                id: "firstLaunch.chooseOther",
                title: "Choose a different place…",
                subtitle: "For example an external drive or another folder.",
                systemImage: "folder.badge.gearshape",
                availability: .available
            )
        ) {
            Task { await chooseDifferentPlace() }
        }
        .disabled(isWorking)

        Button("Back") {
            errorMessage = nil
            step = .welcome
        }
        .buttonStyle(.plain)
        .font(FaloTypography.body)
        .foregroundStyle(.secondary)
        .disabled(isWorking)
        .padding(.top, FaloSpacing.small)
    }

    private func handleWelcome(_ option: FirstLaunchOption) async {
        errorMessage = nil

        switch option.id {
        case FirstLaunchOptionsCatalog.createNewID:
            pendingAfterPlace = .openEmpty
            step = .proposePlace
        case FirstLaunchOptionsCatalog.restoreBackupID:
            pendingAfterPlace = .restoreZip
            step = .proposePlace
        case FirstLaunchOptionsCatalog.openExistingID:
            isWorking = true
            defer { isWorking = false }
            do {
                _ = try await libraryService.openExistingLibraryUsingFolderPicker()
            } catch LibraryError.folderPickerCancelled {
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        case FirstLaunchOptionsCatalog.createInICloudID:
            isWorking = true
            defer { isWorking = false }
            do {
                _ = try libraryService.createOrOpenICloudLibrary()
            } catch {
                errorMessage = error.localizedDescription
            }
        default:
            break
        }
    }

    private func useSuggestedPlace() async {
        errorMessage = nil
        isWorking = true
        defer { isWorking = false }

        do {
            _ = try libraryService.createNewLibrary()
            try await finishAfterPlaceReady()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func chooseDifferentPlace() async {
        errorMessage = nil
        isWorking = true
        defer { isWorking = false }

        do {
            _ = try await libraryService.createNewLibraryUsingFolderPicker(kind: .customFolder)
            try await finishAfterPlaceReady()
        } catch LibraryError.folderPickerCancelled {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func finishAfterPlaceReady() async throws {
        switch pendingAfterPlace {
        case .openEmpty:
            return
        case .restoreZip:
            guard let currentRoot = storageService.libraryPackageRootURL else {
                throw LibraryImportError.noOpenLibrary
            }
            guard let zipURL = await ImportFilePanel.chooseFile(
                contentTypes: [UTType(filenameExtension: "zip") ?? .archive],
                prompt: "Choose ZIP"
            ) else {
                return
            }
            _ = try await Task.detached(priority: .userInitiated) {
                try LibraryImportService.replaceOpenLibrary(
                    fromZip: zipURL,
                    currentLibraryRoot: currentRoot
                )
            }.value
            libraryService.notifyLibraryContentsChanged()
            userProfile.reloadProfileAfterLibraryReplace(storageService)
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
        .environment(StorageService.shared)
        .frame(width: 640, height: 720)
}
