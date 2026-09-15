//
//  EmptyPersonalLibrarySheet.swift
//  Bonsai World
//
//  Settings → Library Management — confirm Empty Personal Library.
//

import SwiftUI

struct EmptyPersonalLibrarySheet: View {
    var onConfirm: () async -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var confirmationText = ""
    @State private var isRunning = false

    private var canConfirm: Bool {
        confirmationText.trimmingCharacters(in: .whitespacesAndNewlines)
            == LibraryEmptyPersonalService.confirmationPhrase
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("This removes your personal belongings from the open library: Trees, Pots, Collections, Yamadori, Seeds, Nursery projects, Work, Tasks, Journal, Inventory stock, Locations, Gardens, Media catalog, Social catalog entries, and all library images.")
                        .font(FaloTypography.body)
                    Text("Knowledge, Reference Data, and Pot Brands & Makers are kept. App settings (theme, Experience edition, Social toggle, regional) stay as they are.")
                        .font(FaloTypography.body)
                        .foregroundStyle(.secondary)
                    Text("Export a ZIP backup first if you may need this data again.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Empty Personal Library")
                }

                Section {
                    TextField("Type \(LibraryEmptyPersonalService.confirmationPhrase) to confirm", text: $confirmationText)
                        .textFieldStyle(.roundedBorder)
                } footer: {
                    Text("Type \(LibraryEmptyPersonalService.confirmationPhrase) exactly (capital letters).")
                        .foregroundStyle(.secondary)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Confirm Empty")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isRunning)
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button("Empty Library", role: .destructive) {
                        Task {
                            isRunning = true
                            defer { isRunning = false }
                            await onConfirm()
                            dismiss()
                        }
                    }
                    .disabled(!canConfirm || isRunning)
                }
            }
        }
        .frame(minWidth: 480, minHeight: 360)
    }
}
