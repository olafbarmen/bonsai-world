//
//  CollectionsList.swift
//  Bonsai World
//
//  Sectioned Collections master list — Smart Collections / My Collections.
//  Single list column; no type browser pane.
//

import SwiftUI

struct CollectionsList: View {
    let smartCollections: [Collection]
    let manualCollections: [Collection]
    @Binding var selection: UUID?
    var treeCount: (Collection) -> Int

    var body: some View {
        List(selection: $selection) {
            if !smartCollections.isEmpty {
                Section {
                    ForEach(smartCollections) { collection in
                        collectionRow(collection)
                    }
                } header: {
                    Text("Smart Collections")
                }
            }

            if !manualCollections.isEmpty {
                Section {
                    ForEach(manualCollections) { collection in
                        collectionRow(collection)
                    }
                } header: {
                    Text("My Collections")
                }
            }
        }
        .faloScrollSurface()
    }

    @ViewBuilder
    private func collectionRow(_ collection: Collection) -> some View {
        CollectionListRow(
            name: collection.name,
            description: collection.description,
            treeCount: treeCount(collection),
            systemImage: collection.icon ?? "square.stack.3d.up"
        )
        .tag(collection.id)
    }
}

struct CollectionListRow: View {
    let name: String
    let description: String
    let treeCount: Int
    var systemImage: String = "square.stack.3d.up"

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 22, height: 22, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(name)
                    .font(FaloTypography.body)
                    .foregroundStyle(.primary)

                if !description.isEmpty {
                    Text(description)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Text(treeCount == 1 ? "1 Tree" : "\(treeCount) Trees")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let previewData = PreviewData()
    let smart = previewData.collections.filter(\.isSmart)
    let manual = previewData.collections.filter(\.isManual)
    return CollectionsList(
        smartCollections: smart,
        manualCollections: manual,
        selection: .constant(smart.first?.id),
        treeCount: { previewData.trees(in: $0.id).count }
    )
    .frame(width: 280, height: 420)
}
