//
//  LibraryImportPreviewSheet.swift
//  Bonsai World
//
//  Confirms Excel or ZIP import before applying changes.
//

import SwiftUI

struct LibraryImportPreviewSheet: View {
    let title: String
    let summary: String
    let issues: [LibraryImportIssue]
    let canImport: Bool
    var confirmTitle: String = "Import"
    /// When set (ZIP restore), shows the open-library path the user is about to replace.
    var destinationPathDisplay: String? = nil
    let importAction: () async -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isImporting = false

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            Text(title)
                .font(FaloTypography.headline)

            Text(summary)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)

            if let destinationPathDisplay {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("This will replace everything in:")
                        .font(FaloTypography.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    Text(destinationPathDisplay)
                        .font(FaloTypography.body.weight(.medium))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(FaloSpacing.medium)
                        .background {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .fill(Color.primary.opacity(0.04))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                                .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        }
                }
            }

            if !issues.isEmpty {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Issues")
                        .font(FaloTypography.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    ScrollView {
                        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                            ForEach(issues.prefix(20)) { issue in
                                Text("\(issue.sheet) row \(issue.row): \(issue.message)")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            if issues.count > 20 {
                                Text("…and \(issues.count - 20) more.")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 180)
                }
            }

            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                    .disabled(isImporting)

                Spacer()

                if isImporting {
                    ProgressView()
                        .controlSize(.small)
                }

                Button(canImport ? confirmTitle : "Close") {
                    if canImport {
                        Task {
                            isImporting = true
                            await importAction()
                            isImporting = false
                            dismiss()
                        }
                    } else {
                        dismiss()
                    }
                }
                .keyboardShortcut(.defaultAction)
                .disabled(isImporting || (!canImport && issues.isEmpty))
            }
        }
        .padding(FaloSpacing.xLarge)
        .frame(width: 520)
    }
}
