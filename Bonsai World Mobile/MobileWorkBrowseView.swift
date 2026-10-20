//
//  MobileWorkBrowseView.swift
//  Bonsai World
//
//  Field → Work — recent WorkRecords across trees (Mac Workshop → Work title).
//

import SwiftUI

struct MobileWorkBrowseView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    private var records: [WorkRecord] {
        library.recentWork(limit: 200)
    }

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView(
                    "No Work",
                    systemImage: "wrench.and.screwdriver",
                    description: Text("Work you log on trees appears here.")
                )
                .listRowBackground(Color.clear)
            } else {
                Section {
                    Text("Perform care and styling from Work. Trees only show the resulting history.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
                }

                Section {
                    ForEach(records) { record in
                        workRow(record)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Work")
        .navigationBarTitleDisplayMode(.large)
    }

    private func workRow(_ record: WorkRecord) -> some View {
        let typeName = CanonicalWorkTypeID.name(for: record.workTypeID)
        let treeTitles = record.treeIDs.compactMap { id -> String? in
            guard let tree = library.tree(id: id) else { return nil }
            return MobileTreePresentation.title(for: tree)
        }
        let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let primaryTreeID = record.treeIDs.first

        return Button {
            if let primaryTreeID {
                openMobileTree(primaryTreeID)
            }
        } label: {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(typeName)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                Text(record.performedAt, style: .date)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                if !treeTitles.isEmpty {
                    Text(treeTitles.joined(separator: " · "))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(2)
                }
                if !notes.isEmpty {
                    Text(notes)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(3)
                }
            }
            .padding(.vertical, FaloSpacing.xSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(primaryTreeID == nil)
        .listRowBackground(BonsaiWorldColors.surface.opacity(0.55))
        .accessibilityLabel(workAccessibilityLabel(typeName: typeName, trees: treeTitles))
        .accessibilityHint(primaryTreeID == nil ? "" : "Opens tree profile")
    }

    private func workAccessibilityLabel(typeName: String, trees: [String]) -> String {
        if trees.isEmpty { return typeName }
        return "\(typeName), \(trees.joined(separator: ", "))"
    }
}

#Preview {
    NavigationStack {
        MobileWorkBrowseView()
    }
    .environment(DemoLibrary.preview)
}
