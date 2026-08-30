//
//  TreeActivityHub.swift
//  Bonsai World
//
//  Tree Activity Hub — architecture placeholders.
//  No registration engine, models, or navigation yet.
//
//  Ownership rule (one action, one registration, many consumers):
//  • Tree — register activities on this bonsai
//  • Shaping — planning (consumes Tree registrations)
//  • Care — recommendations (consumes Tree registrations)
//  • Tasks — scheduling (consumes Tree registrations)
//  • Media — asset management (consumes photo/document registrations)
//  • Inventory — physical assets (consumes pot/tool assignments)
//  • Timeline — chronological history (read-only consumer; never registers)
//

import SwiftUI

/// Future activity kinds reachable from the Tree registration entry point.
enum TreeActivityKind: String, CaseIterable, Identifiable {
    case work
    case care
    case measurement
    case photo
    case journal
    case document

    var id: Self { self }

    var title: String {
        switch self {
        case .work: "Work"
        case .care: "Care"
        case .measurement: "Measurement"
        case .photo: "Photo"
        case .journal: "Journal"
        case .document: "Document"
        }
    }

    var systemImage: String {
        switch self {
        case .work: "wrench.and.screwdriver"
        case .care: "drop"
        case .measurement: "ruler"
        case .photo: "photo"
        case .journal: "book"
        case .document: "doc"
        }
    }
}

/// Tree header — identity line + registration action (not a content card).
struct TreeDetailActivityHeader: View {
    let tree: Tree
    /// Hidden for Former Trees — no new work on trees that have left care.
    var showsAddActivity: Bool = true
    /// Fires when the grower chooses Work from Add Activity. Other kinds stay
    /// placeholders until their registration flows land.
    var onSelectWork: () -> Void = {}

    private var displayName: String {
        let nickname = tree.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nickname.isEmpty { return nickname }
        return tree.botanicalName
    }

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(FaloTypography.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                if !tree.bonsaiName.isEmpty {
                    Text(tree.bonsaiName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }

            Spacer(minLength: FaloSpacing.medium)

            if showsAddActivity {
                TreeAddActivityToolbarAction(onSelectWork: onSelectWork)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .contain)
    }
}

/// Compact tree-specific registration action — header / toolbar placement only.
/// Work is live; the remaining kinds stay visual placeholders until their
/// registration flows land.
struct TreeAddActivityToolbarAction: View {
    var onSelectWork: () -> Void = {}

    var body: some View {
        Menu {
            Section("Register on this tree") {
                ForEach(TreeActivityKind.allCases) { kind in
                    Button {
                        if kind == .work { onSelectWork() }
                    } label: {
                        Label(kind.title, systemImage: kind.systemImage)
                    }
                    .disabled(kind != .work)
                }
            }
        } label: {
            Label("Add Activity", systemImage: "plus")
        }
        .buttonStyle(.bordered)
        .help("Register work, care, measurements, photos, journal entries, and documents on this tree.")
        .accessibilityLabel("Add Activity")
        .accessibilityHint("Register Work on this tree. Other activity kinds are not implemented yet.")
    }
}
