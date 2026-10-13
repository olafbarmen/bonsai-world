//
//  LibraryManagementView.swift
//  Bonsai World
//
//  Settings → Library Management — one clear job at a time:
//  where data lives, backup ZIP, restore ZIP, switch library, then More…
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

struct LibraryManagementView: View {
    @Environment(LibraryService.self) private var libraryService
    @Environment(StorageService.self) private var storageService
    @Environment(TreeService.self) private var treeService
    @Environment(WorkService.self) private var workService
    @Environment(TreeMeasurementHistoryStore.self) private var measurementHistory
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(UserProfileStore.self) private var userProfile
    @Environment(AppState.self) private var appState

    @State private var statusMessage: String?
    @State private var statusIsError = false
    @State private var isBusy = false
    @State private var importConfirmation: ImportConfirmation?
    @State private var isEmptyPersonalLibraryPresented = false
    @State private var showsMore = false
    @State private var showsSwitchLibrary = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                whereDataLivesSection
                whatDoYouWantSection
                if showsMore {
                    moreSection
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 560, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Library Management")
        .sheet(item: $importConfirmation) { confirmation in
            switch confirmation {
            case .excel(let url, let preview):
                LibraryImportPreviewSheet(
                    title: "Import from Excel",
                    summary: preview.summary,
                    issues: preview.issues,
                    canImport: preview.canImport
                ) {
                    await applyExcelImport(from: url)
                }
            case .zip(let zipURL, let preview):
                LibraryImportPreviewSheet(
                    title: "Load backup (ZIP)",
                    summary: preview.summary,
                    issues: [],
                    canImport: true,
                    confirmTitle: "Replace library",
                    destinationPathDisplay: preview.destinationPathDisplay
                ) {
                    await applyZipImport(from: zipURL)
                }
            }
        }
        .sheet(isPresented: $isEmptyPersonalLibraryPresented) {
            EmptyPersonalLibrarySheet {
                await emptyPersonalLibrary()
            }
        }
    }

    // MARK: - Sections

    private var whereDataLivesSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Where your data lives now")
                .font(FaloTypography.headline)

            Text("Everything in Bonsai World uses this one library. You only change it when you switch library or load a backup.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                Text(storageService.libraryLocationConfiguration.kind.displayName)
                    .font(FaloTypography.body.weight(.medium))

                Text(storageService.libraryPackagePathDisplay)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)

                if let warning = storageService.foreignWriterWarning {
                    Text(warning)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.statusAttention)
                }

                Button("Show this folder in Finder") {
                    revealOpenLibraryInFinder()
                }
                .buttonStyle(.link)
                .disabled(storageService.libraryPackageRootURL == nil)

                if storageService.libraryLocationConfiguration.kind != .iCloudDrive {
                    Button("Use iCloud Drive with iPhone…") {
                        Task { await switchToICloudDrive() }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isBusy || !BonsaiWorldICloudLibrary.isAvailable)
                    .help(
                        BonsaiWorldICloudLibrary.isAvailable
                            ? "Open or create the shared library in iCloud for Mac and iPhone."
                            : "Sign in to iCloud on this Mac to enable."
                    )
                } else {
                    Button("Copy missing photos from Mac library…") {
                        Task { await repairICloudPhotosFromLocalLibrary() }
                    }
                    .buttonStyle(.bordered)
                    .disabled(isBusy)
                    .help("Copies Images and photo links from the Mac Application Support library into this iCloud package.")
                }

                Text("Avoid editing the same library on Mac and iPhone at the same time. ZIP backup remains the safety net.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(FaloSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(Color.primary.opacity(0.03))
            }
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }

            if let statusMessage {
                Text(statusMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(statusIsError ? BonsaiWorldColors.statusCritical : .secondary)
            }

            if isBusy {
                HStack(spacing: FaloSpacing.small) {
                    ProgressView()
                        .controlSize(.small)
                    Text(statusMessage ?? "Working…")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var whatDoYouWantSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("What do you want to do?")
                .font(FaloTypography.headline)

            Text("Pick one. You do not need the others today.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                actionButton(
                    title: "Save a backup (ZIP)…",
                    subtitle: "For a new Mac later, or a safety copy. Saves a file you can keep.",
                    systemImage: "doc.zipper"
                ) {
                    await exportZip()
                }

                actionButton(
                    title: "Load a backup (ZIP)…",
                    subtitle: "Replaces everything in the library above with the ZIP you choose.",
                    systemImage: "tray.and.arrow.down"
                ) {
                    await beginZipImport()
                }

                actionButton(
                    title: showsSwitchLibrary ? "Switch library" : "Switch library…",
                    subtitle: "Use another library — for example yours and your partner’s.",
                    systemImage: "arrow.left.arrow.right"
                ) {
                    showsSwitchLibrary.toggle()
                }

                if showsSwitchLibrary {
                    switchLibraryPanel
                }

                Button {
                    showsMore.toggle()
                } label: {
                    Text(showsMore ? "Hide more options" : "More options…")
                        .font(FaloTypography.body)
                }
                .buttonStyle(.link)
                .padding(.top, FaloSpacing.xSmall)
            }
        }
    }

    private var switchLibraryPanel: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Libraries you have used")
                .font(FaloTypography.caption.weight(.medium))
                .foregroundStyle(.secondary)

            let recents = storageService.recentLibrariesForSwitch
            if recents.isEmpty {
                Text("No other libraries yet. Use “Open another folder…” below.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            } else {
                ForEach(recents) { entry in
                    Button {
                        Task { await switchToRecent(entry) }
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.pathDisplay)
                                    .font(FaloTypography.body.weight(.medium))
                                    .foregroundStyle(.primary)
                                Text("Open this library")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(FaloSpacing.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .fill(Color.primary.opacity(0.03))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(isBusy)
                }
            }

            actionButton(
                title: "Open another folder…",
                subtitle: "Choose a Bonsai World Library folder on this Mac.",
                systemImage: "folder"
            ) {
                await openExistingLibrary()
            }
        }
        .padding(.leading, FaloSpacing.xSmall)
    }

    private var moreSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("More options")
                .font(FaloTypography.headline)

            Text("Only when you need them.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                actionButton(
                    title: "Export to Excel…",
                    subtitle: "Trees and Work history in a spreadsheet.",
                    systemImage: "tablecells"
                ) {
                    await exportExcel()
                }

                actionButton(
                    title: "Import from Excel…",
                    subtitle: "Update trees by Tree ID, or create new rows — into the library above.",
                    systemImage: "square.and.arrow.down.on.square"
                ) {
                    await beginExcelImport()
                }

                actionButton(
                    title: "Create a new empty library…",
                    subtitle: "Starts a blank library in a folder you choose, then switches to it.",
                    systemImage: "folder.badge.plus"
                ) {
                    await createNewLibrary()
                }

                actionButton(
                    title: "Empty personal library…",
                    subtitle: "Removes trees and personal data here. Keep a ZIP backup first.",
                    systemImage: "trash"
                ) {
                    isEmptyPersonalLibraryPresented = true
                }
            }
        }
    }

    // MARK: - Shared controls

    private func actionButton(
        title: String,
        subtitle: String,
        systemImage: String,
        action: @escaping () async -> Void
    ) -> some View {
        Button {
            Task { await action() }
        } label: {
            HStack(alignment: .top, spacing: FaloSpacing.medium) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FaloTypography.body.weight(.medium))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }
            .padding(FaloSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(Color.primary.opacity(0.03))
            }
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isBusy)
    }

    // MARK: - Actions

    @MainActor
    private func switchToRecent(_ entry: RecentLibraryEntry) async {
        isBusy = true
        clearStatus()
        defer { isBusy = false }

        do {
            let url = try storageService.resolveRecentLibraryURL(entry)
            _ = try libraryService.switchToLibrary(at: url)
            appState.selectSection(.dashboard)
            setStatus("Switched to \(storageService.libraryPackagePathDisplay).")
            showsSwitchLibrary = false
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func openExistingLibrary() async {
        isBusy = true
        clearStatus()
        defer { isBusy = false }

        do {
            _ = try await libraryService.openExistingLibraryUsingFolderPicker()
            libraryService.notifyLibraryContentsChanged()
            appState.selectSection(.dashboard)
            setStatus("Switched to \(storageService.libraryPackagePathDisplay).")
            showsSwitchLibrary = false
        } catch LibraryError.folderPickerCancelled {
            return
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func createNewLibrary() async {
        isBusy = true
        clearStatus()
        defer { isBusy = false }

        do {
            _ = try await libraryService.createNewLibraryUsingFolderPicker()
            libraryService.notifyLibraryContentsChanged()
            appState.selectSection(.dashboard)
            setStatus("Created and opened \(storageService.libraryPackagePathDisplay).")
        } catch LibraryError.folderPickerCancelled {
            return
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func exportExcel() async {
        guard let destination = await ExportSavePanel.chooseURL(
            suggestedName: LibraryExportService.suggestedExcelFileName(),
            contentType: UTType(filenameExtension: "xlsx") ?? .data
        ) else { return }

        isBusy = true
        setStatus("Preparing export…")
        defer { isBusy = false }

        let snapshot = LibraryExportService.makeExcelSnapshot(
            trees: treeService.trees,
            workRecords: workService.records,
            collections: treeService.collections,
            referenceData: referenceData
        )

        do {
            setStatus("Writing Excel file…")
            try await Task.detached(priority: .userInitiated) {
                try LibraryExportService.writeExcel(snapshot: snapshot, to: destination)
            }.value
            finishExportSuccess(at: destination)
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func exportZip() async {
        userProfile.flushProfileToOpenLibrary()

        guard let libraryRoot = storageService.libraryPackageRootURL else {
            setStatus(LibraryExportError.libraryUnavailable.errorDescription ?? "Library unavailable.", isError: true)
            return
        }

        guard let destination = await ExportSavePanel.chooseURL(
            suggestedName: LibraryExportService.suggestedZipFileName(),
            contentType: UTType(filenameExtension: "zip") ?? .archive
        ) else { return }

        isBusy = true
        setStatus("Saving backup…")
        defer { isBusy = false }

        do {
            try await Task.detached(priority: .userInitiated) {
                try LibraryExportService.exportLibraryZip(
                    libraryRootURL: libraryRoot,
                    destinationURL: destination
                )
            }.value
            finishExportSuccess(at: destination)
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func beginExcelImport() async {
        guard let source = await ImportFilePanel.chooseFile(
            contentTypes: [UTType(filenameExtension: "xlsx") ?? .spreadsheet],
            prompt: "Import"
        ) else { return }

        if source.pathExtension.lowercased() == "zip" {
            setStatus(
                LibraryImportError.invalidWorkbook.errorDescription ?? "Wrong file type.",
                isError: true
            )
            return
        }

        isBusy = true
        defer { isBusy = false }

        do {
            let preview = try LibraryImportService.previewExcelImport(
                from: source,
                trees: treeService.trees,
                collections: treeService.collections,
                referenceData: referenceData
            )
            clearStatus()
            importConfirmation = .excel(source, preview)
        } catch let error as LibraryImportError {
            setStatus(error.localizedDescription, isError: true)
        } catch {
            setStatus(
                LibraryImportError.invalidWorkbook.errorDescription ?? error.localizedDescription,
                isError: true
            )
        }
    }

    @MainActor
    private func applyExcelImport(from url: URL) async {
        isBusy = true
        defer { isBusy = false }

        do {
            let result = try LibraryImportService.applyExcelImport(
                from: url,
                treeService: treeService,
                workService: workService,
                referenceData: referenceData
            )
            treeService.reconcileMeasurementDimensions(using: measurementHistory)
            setStatus("Import finished: \(result.summary)")
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func beginZipImport() async {
        guard let currentRoot = storageService.libraryPackageRootURL,
              storageService.libraryPackageExists()
        else {
            setStatus(LibraryImportError.noOpenLibrary.errorDescription ?? "No open library.", isError: true)
            return
        }

        guard let zipURL = await ImportFilePanel.chooseFile(
            contentTypes: [UTType(filenameExtension: "zip") ?? .archive],
            prompt: "Choose ZIP"
        ) else { return }

        let extensionName = zipURL.pathExtension.lowercased()
        if extensionName == "xlsx" || extensionName == "xls" {
            setStatus(
                "Choose a .zip backup — not Excel. Use Import from Excel under More options.",
                isError: true
            )
            return
        }

        isBusy = true
        setStatus("Reading ZIP…")
        defer { isBusy = false }

        do {
            let preview = try await Task.detached(priority: .userInitiated) {
                try LibraryImportService.previewLibraryZip(
                    sourceURL: zipURL,
                    currentLibraryRoot: currentRoot
                )
            }.value
            clearStatus()
            importConfirmation = .zip(zipURL, preview)
        } catch let error as LibraryImportError {
            setStatus(error.localizedDescription, isError: true)
        } catch {
            setStatus(
                LibraryImportError.invalidLibraryPackage.errorDescription ?? error.localizedDescription,
                isError: true
            )
        }
    }

    @MainActor
    private func applyZipImport(from zipURL: URL) async {
        guard let currentRoot = storageService.libraryPackageRootURL else {
            setStatus(LibraryImportError.noOpenLibrary.errorDescription ?? "No open library.", isError: true)
            return
        }

        isBusy = true
        setStatus("Loading backup…")
        defer { isBusy = false }

        do {
            _ = try await Task.detached(priority: .userInitiated) {
                try LibraryImportService.replaceOpenLibrary(
                    fromZip: zipURL,
                    currentLibraryRoot: currentRoot
                )
            }.value
            libraryService.notifyLibraryContentsChanged()
            userProfile.reloadProfileAfterLibraryReplace(storageService)
            appState.selectSection(.dashboard)
            setStatus("Backup loaded at \(storageService.libraryPackagePathDisplay). Everything now lives there.")
        } catch let error as LibraryImportError {
            setStatus(error.localizedDescription, isError: true)
        } catch {
            setStatus(
                LibraryImportError.invalidLibraryPackage.errorDescription ?? error.localizedDescription,
                isError: true
            )
        }
    }

    @MainActor
    private func emptyPersonalLibrary() async {
        isBusy = true
        defer { isBusy = false }

        do {
            try LibraryEmptyPersonalService.emptyPersonalLibrary(
                storage: storageService,
                libraryService: libraryService,
                userProfile: userProfile
            )
            appState.selectSection(.dashboard)
            setStatus("Personal library emptied. Knowledge and reference data were kept.")
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func finishExportSuccess(at destination: URL) {
        ExportFileDelivery.stripQuarantine(from: destination)
        setStatus("Saved \(destination.lastPathComponent).")
        NSWorkspace.shared.open(destination)
    }

    private func revealOpenLibraryInFinder() {
        guard let root = storageService.libraryPackageRootURL else { return }
        NSWorkspace.shared.activateFileViewerSelecting([root])
    }

    @MainActor
    private func switchToICloudDrive() async {
        clearStatus()
        isBusy = true
        defer { isBusy = false }
        do {
            let previousRoot = storageService.libraryPackageRootURL
            _ = try libraryService.createOrOpenICloudLibrary(seedingFrom: previousRoot)
            libraryService.notifyLibraryContentsChanged()
            setStatus("Using iCloud Drive with your library photos. Open Bonsai World on iPhone with the same Apple ID.")
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    @MainActor
    private func repairICloudPhotosFromLocalLibrary() async {
        clearStatus()
        isBusy = true
        defer { isBusy = false }
        do {
            guard storageService.libraryLocationConfiguration.kind == .iCloudDrive,
                  let iCloudRoot = storageService.libraryPackageRootURL
            else {
                setStatus("Open the iCloud library first.", isError: true)
                return
            }
            let localRoot = LocalStorageProvider.makeDefault().packageRootURL
            let report = try LibraryICloudSeedService.seedIfNeeded(from: localRoot, to: iCloudRoot)
            libraryService.notifyLibraryContentsChanged()
            if report.copiedImageFiles == 0, report.mergedTreePhotoLinks == 0, !report.didFullPackageCopy {
                setStatus("No missing photos found to copy.")
            } else {
                setStatus(
                    "Copied \(report.copiedImageFiles) photo file(s); updated \(report.mergedTreePhotoLinks) tree(s). Quit and reopen on iPhone after iCloud finishes syncing."
                )
            }
        } catch {
            setStatus(error.localizedDescription, isError: true)
        }
    }

    private func clearStatus() {
        statusMessage = nil
        statusIsError = false
    }

    private func setStatus(_ message: String, isError: Bool = false) {
        statusMessage = message
        statusIsError = isError
    }
}

private enum ImportConfirmation: Identifiable {
    case excel(URL, LibraryExcelImportPreview)
    case zip(URL, LibraryZipImportPreview)

    var id: String {
        switch self {
        case .excel(let url, _):
            "excel-\(url.absoluteString)"
        case .zip(let zipURL, _):
            "zip-\(zipURL.absoluteString)"
        }
    }
}
