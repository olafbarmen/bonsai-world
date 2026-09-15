//
//  TreeListView.swift
//  Bonsai World
//

import SwiftUI

struct TreeListView: View {
    @Environment(DemoLibrary.self) private var library

    var body: some View {
        List {
            Section {
                Text("Demo library — sample trees only. Not linked to Mac yet.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
            }

            Section("Trees") {
                ForEach(library.trees) { tree in
                    NavigationLink(value: tree.id) {
                        TreeRowView(tree: tree)
                    }
                }
            }
        }
        .navigationDestination(for: UUID.self) { treeID in
            if let tree = library.tree(id: treeID) {
                TreeProfileView(treeID: tree.id)
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
    }
}

private struct TreeRowView: View {
    let tree: Tree

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(tree.displayTitle)
                .font(.body.weight(.semibold))
            if !tree.displaySubtitle.isEmpty {
                Text(tree.displaySubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(tree.healthStatus.title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    NavigationStack {
        TreeListView()
    }
    .environment(DemoLibrary())
}
