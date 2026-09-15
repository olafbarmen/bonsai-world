//
//  UserProfileView.swift
//  Bonsai World
//
//  Settings → User Profile — General + Gardens.
//  Default Garden is the geographic root for Maps / Weather / AI.
//

import AppKit
import SwiftUI

struct UserProfileView: View {
    @Environment(UserProfileStore.self) private var profile
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(ImageService.self) private var imageService

    @State private var gardenEditor: Garden?
    @State private var gardenPendingDelete: Garden?
    @State private var isChangingProfilePhoto = false

    var body: some View {
        @Bindable var profile = profile

        Form {
            Section {
                profilePhotoRow
            } header: {
                Text("Profile Photo")
            } footer: {
                Text("Shown in the sidebar. Choose a photo from your Mac, or remove it to use the default avatar.")
                    .font(FaloTypography.caption)
            }

            Section {
                TextField("Name", text: $profile.name)
                    .onChange(of: profile.name) { _, _ in
                        profile.noteProfileFieldsChanged()
                    }
                TextField("Email", text: $profile.email)
                    .textContentType(.emailAddress)
                    .onChange(of: profile.email) { _, _ in
                        profile.noteProfileFieldsChanged()
                    }
                Picker("Language", selection: $profile.language) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.menuTitle).tag(language)
                    }
                }
                .onChange(of: profile.language) { _, _ in
                    profile.noteProfileFieldsChanged()
                }
            } header: {
                Text("General")
            } footer: {
                Text("Email is optional. Name and photo are saved in your library and included in ZIP backups.")
                    .font(FaloTypography.caption)
            }

            Section {
                ForEach(profile.gardens) { garden in
                    gardenRow(garden)
                }

                Button("Add Garden") {
                    gardenEditor = profile.blankGardenDraft()
                }
            } header: {
                Text("Gardens")
            } footer: {
                Text("The Default Garden sets map context and future Weather / AI. Address opens the map area; Garden Position is placed manually and is the reference for Locations.")
                    .font(FaloTypography.caption)
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .bonsaiWorkspaceNavigationTitle("User Profile")
        .sheet(item: $gardenEditor) { garden in
            GardenEditorSheet(garden: garden)
                .environment(profile)
        }
        .confirmationDialog(
            "Delete Garden?",
            isPresented: Binding(
                get: { gardenPendingDelete != nil },
                set: { if !$0 { gardenPendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let gardenPendingDelete {
                    profile.deleteGarden(id: gardenPendingDelete.id)
                }
                gardenPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                gardenPendingDelete = nil
            }
        } message: {
            Text("Locations linked to this Garden keep their coordinates, but you must reassign them to another Garden.")
        }
        .onDisappear {
            profile.flushProfileToOpenLibrary()
        }
    }

    private var profilePhotoRow: some View {
        HStack(spacing: FaloSpacing.medium) {
            UserProfilePhotoMark(
                imageID: profile.profileImageID,
                imageService: imageService,
                size: 48
            )

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Button(profile.profileImageID == nil ? "Choose Profile Photo…" : "Change Profile Photo…") {
                    Task { await changeProfilePhoto() }
                }
                .disabled(isChangingProfilePhoto)

                if profile.profileImageID != nil {
                    Button("Remove Photo", role: .destructive) {
                        Task { await removeProfilePhoto() }
                    }
                    .disabled(isChangingProfilePhoto)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func changeProfilePhoto() async {
        isChangingProfilePhoto = true
        defer { isChangingProfilePhoto = false }
        do {
            let asset = try await imageImportService.importProfileImageFromFinder()
            let previousID = profile.profileImageID
            profile.profileImageID = asset.id
            profile.noteProfileFieldsChanged()
            if let previousID, previousID != asset.id {
                try? await imageService.deletePhoto(id: previousID)
            }
        } catch is ImageImportError {
            // Cancelled or unsupported — leave current photo.
        } catch {
            // Leave current photo on unexpected failure.
        }
    }

    private func removeProfilePhoto() async {
        guard let id = profile.profileImageID else { return }
        profile.profileImageID = nil
        profile.noteProfileFieldsChanged()
        try? await imageService.deletePhoto(id: id)
    }

    private func gardenRow(_ garden: Garden) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            HStack {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    HStack(spacing: FaloSpacing.small) {
                        Text(garden.name)
                            .font(FaloTypography.body.weight(.semibold))
                        if garden.isDefault {
                            Text("Default")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                        if !garden.isActive {
                            Text("Inactive")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(garden.composedAddress.isEmpty ? "No address" : garden.composedAddress)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    Text(garden.hasGardenPosition ? "Position Set" : "Position Not Set")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    if let coordinate = garden.gardenPosition {
                        Text(String(format: "%.5f, %.5f", coordinate.latitude, coordinate.longitude))
                            .font(FaloTypography.caption.monospaced())
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer(minLength: FaloSpacing.medium)

                Menu {
                    Button("Edit") {
                        gardenEditor = garden
                    }
                    if !garden.isDefault {
                        Button("Make Default") {
                            profile.setDefaultGarden(id: garden.id)
                        }
                    }
                    Button(garden.isActive ? "Mark Inactive" : "Mark Active") {
                        profile.setGardenActive(id: garden.id, isActive: !garden.isActive)
                    }
                    if profile.gardens.count > 1 {
                        Divider()
                        Button("Delete", role: .destructive) {
                            gardenPendingDelete = garden
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .menuStyle(.borderlessButton)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}

/// Circular profile mark for Settings preview — same ImageService path as the sidebar.
private struct UserProfilePhotoMark: View {
    var imageID: UUID?
    let imageService: ImageService
    var size: CGFloat

    @State private var thumbnail: NSImage?

    var body: some View {
        let _ = imageService.presentationRevision
        Group {
            if let thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: size * 0.92, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(BonsaiWorldColors.accent.opacity(0.75))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .accessibilityHidden(true)
        .task(id: "\(imageID?.uuidString ?? "")-\(size)-\(imageService.presentationRevision)") {
            await loadThumbnail()
        }
    }

    private func loadThumbnail() async {
        guard let imageID else {
            thumbnail = nil
            return
        }
        let maxPixel = Int(size * 2.5)
        do {
            thumbnail = try await imageService.loadDisplayNSImage(
                for: imageID,
                context: .treeThumbnail,
                maxPixelSize: max(96, maxPixel)
            )
        } catch {
            thumbnail = nil
        }
    }
}

#Preview {
    let storage = StorageService.shared
    let catalog = ImagePreviewData()
    UserProfileView()
        .environment(UserProfileStore())
        .environment(ImageService(storage: storage, previewData: catalog))
        .environment(ImageImportService(storage: storage, imageCatalog: catalog))
}
