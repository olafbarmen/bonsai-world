//
//  MobileSettingsView.swift
//  Bonsai World
//
//  Field Settings sheet — local preferences only (no sync).
//

import SwiftUI
import UniformTypeIdentifiers
import UIKit

private struct MobileExportShareItem: Identifiable {
    let id = UUID()
    let url: URL
}

struct MobileSettingsView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var todayTasksEnabled = MobileTodayTasksNotifier.isEnabled
    @State private var confirmReset = false
    @State private var confirmClearPhotos = false
    @State private var confirmImport = false
    @State private var pendingImportURL: URL?
    @State private var isImportPickerPresented = false
    @State private var exportShareItem: MobileExportShareItem?
    @State private var exportErrorMessage: String?
    @State private var importErrorMessage: String?
    @State private var libraryLocationHint: String?
    @State private var iCloudAvailable = BonsaiWorldICloudLibrary.cachedLibraryRootURL() != nil

    private var appVersionLine: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: Binding(
                        get: { library.growerName },
                        set: { library.setGrowerName($0) }
                    ))
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .textContentType(.name)
                    .accessibilityLabel("Name")
                } header: {
                    Text("User Profile")
                } footer: {
                    Text("Appears in the Home greeting (for example “Good afternoon, Olaf”). Same field as Mac User Profile.")
                        .font(FaloTypography.caption)
                }

                Section("Preferences") {
                    NavigationLink("Regional Settings") {
                        MobileRegionalSettingsView()
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Regional Settings")
                }

                Section {
                    Toggle("Today Tasks at 07:00", isOn: $todayTasksEnabled)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Today Tasks at 07:00")
                        .onChange(of: todayTasksEnabled) { _, newValue in
                            MobileTodayTasksNotifier.isEnabled = newValue
                            library.refreshTodayTasksNotification()
                        }

                    Button("Open Notification Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            openURL(url)
                        }
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Open Notification Settings")
                    .accessibilityHint("Opens iOS Settings for Bonsai World")
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("When on, Bonsai World sends a local reminder at 07:00 if there are tasks due today.")
                        .font(FaloTypography.caption)
                }

                Section {
                    Text("Pins on Locations and Yamadori use your current location when you ask.")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                } header: {
                    Text("Location")
                }

                Section {
                    LabeledContent("Location") {
                        Text(libraryLocationCaption)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }

                    if let warning = library.foreignWriterWarningText {
                        Text(warning)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                    }

                    if MobileLibraryStore.locationPreference != .iCloud {
                        Button("Use iCloud with Mac") {
                            switchToICloud()
                        }
                        .font(FaloTypography.body)
                        .foregroundStyle(
                            iCloudAvailable
                                ? BonsaiWorldColors.accent
                                : BonsaiWorldColors.textTertiary
                        )
                        .disabled(!iCloudAvailable)
                        .accessibilityLabel("Use iCloud with Mac")
                    }

                    if MobileLibraryStore.locationPreference != .local {
                        Button("Keep library on this iPhone") {
                            switchToLocal()
                        }
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Keep library on this iPhone")
                    }

                    Button("Export Library") {
                        exportLibrary()
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Export Library")
                    .accessibilityHint("Share a ZIP copy of the local library package")

                    Button("Import Library") {
                        isImportPickerPresented = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .accessibilityLabel("Import Library")
                    .accessibilityHint("Replace this device’s library from a ZIP or folder")

                    Button("Clear Photos", role: .destructive) {
                        confirmClearPhotos = true
                    }
                    .font(FaloTypography.body)
                    .accessibilityLabel("Clear Photos")
                    .accessibilityHint("Removes all photos but keeps trees and other data")

                    Button("Reset Library", role: .destructive) {
                        confirmReset = true
                    }
                    .font(FaloTypography.body)
                    .accessibilityLabel("Reset Library")
                    .accessibilityHint("Deletes all local data and restores demo trees")
                } header: {
                    Text("Library Management")
                } footer: {
                    Text(libraryManagementFooter)
                        .font(FaloTypography.caption)
                }

                if let libraryLocationHint {
                    Section {
                        Text(libraryLocationHint)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                    }
                }

                Section {
                    NavigationLink("Getting Started") {
                        MobileGettingStartedView()
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Getting Started")
                } header: {
                    Text("Library")
                }

                Section("About") {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Bonsai World")
                            .font(FaloTypography.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                        Text(appVersionLine)
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                switch await BonsaiWorldICloudLibrary.resolveLibraryRootURL() {
                case .available: iCloudAvailable = true
                case .unavailable: iCloudAvailable = false
                case .timedOut: break
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(item: $exportShareItem) { item in
                MobileShareSheet(items: [item.url]) {
                    exportShareItem = nil
                }
            }
            .fileImporter(
                isPresented: $isImportPickerPresented,
                allowedContentTypes: [.zip, .folder],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    pendingImportURL = url
                    confirmImport = true
                case .failure(let error):
                    importErrorMessage = error.localizedDescription
                }
            }
            .alert("Export failed", isPresented: Binding(
                get: { exportErrorMessage != nil },
                set: { if !$0 { exportErrorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { exportErrorMessage = nil }
            } message: {
                Text(exportErrorMessage ?? "")
            }
            .alert("Import failed", isPresented: Binding(
                get: { importErrorMessage != nil },
                set: { if !$0 { importErrorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { importErrorMessage = nil }
            } message: {
                Text(importErrorMessage ?? "")
            }
            .confirmationDialog(
                "Replace the library?",
                isPresented: $confirmImport,
                titleVisibility: .visible
            ) {
                Button("Import and Replace", role: .destructive) {
                    performImport()
                }
                Button("Cancel", role: .cancel) {
                    pendingImportURL = nil
                }
            } message: {
                Text("This replaces all trees, work, photos, and inventory on this device with the selected ZIP or folder.")
            }
            .confirmationDialog(
                "Clear all photos?",
                isPresented: $confirmClearPhotos,
                titleVisibility: .visible
            ) {
                Button("Clear Photos", role: .destructive) {
                    library.clearAllPhotos()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Removes every photo from Trees, Seeds, and Yamadori Finds on this device. Other data stays.")
            }
            .confirmationDialog(
                "Reset the library?",
                isPresented: $confirmReset,
                titleVisibility: .visible
            ) {
                Button("Reset to Demo", role: .destructive) {
                    library.resetLibraryToDemo()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("All trees, work, photos, and inventory on this device will be deleted. Demo data is restored.")
            }
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }

    private var libraryLocationCaption: String {
        switch MobileLibraryStore.locationPreference {
        case .iCloud:
            return iCloudAvailable ? "iCloud Drive" : "iCloud (unavailable)"
        case .local:
            return "This iPhone"
        case .undecided:
            return "Not chosen"
        }
    }

    private var libraryManagementFooter: String {
        let locationLine: String
        if MobileLibraryStore.locationPreference == .iCloud {
            locationLine = "Shared with Mac via iCloud when both use the same Apple ID. Avoid editing on both at once. Quit and reopen after changing location."
        } else {
            locationLine = "Library stays on this iPhone until you choose iCloud. Quit and reopen after changing location."
        }
        return "\(locationLine) Export shares a ZIP of this device’s library. Import a ZIP or folder to replace everything here — export first if you want a backup. Clear Photos keeps trees, work, and inventory. Reset Library restores demo data."
    }

    private func switchToICloud() {
        guard iCloudAvailable else { return }
        MobileLibraryStore.locationPreference = .iCloud
        libraryLocationHint = "Quit and reopen Bonsai World to open the iCloud library."
    }

    private func switchToLocal() {
        MobileLibraryStore.locationPreference = .local
        libraryLocationHint = "Quit and reopen Bonsai World to use the library on this iPhone."
    }

    private func exportLibrary() {
        do {
            let url = try library.prepareLibraryExportPackage()
            exportShareItem = MobileExportShareItem(url: url)
        } catch {
            exportErrorMessage = error.localizedDescription
        }
    }

    private func performImport() {
        guard let url = pendingImportURL else { return }
        pendingImportURL = nil
        do {
            try library.importLibraryPackage(from: url)
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }
}

#Preview {
    MobileSettingsView()
        .environment(DemoLibrary.preview)
}
