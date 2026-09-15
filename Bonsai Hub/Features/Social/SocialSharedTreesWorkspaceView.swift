//
//  SocialSharedTreesWorkspaceView.swift
//  Bonsai World
//
//  Social → Shared Trees — local preview of what this library marks for sharing.
//

import SwiftUI

struct SocialSharedTreesWorkspaceView: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var selectedTreeID: UUID?

    private var sharedTrees: [Tree] {
        guard appSettings.isSocialEnabled else { return [] }
        return treeService.treesInCare
            .filter(\.socialShareLevel.isShared)
            .sorted {
                TreePresentation.title(for: $0).localizedStandardCompare(TreePresentation.title(for: $1))
                    == .orderedAscending
            }
    }

    var body: some View {
        Group {
            if let selectedTreeID, let tree = treeService.getTree(id: selectedTreeID) {
                sharedDetail(tree)
            } else {
                sharedList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Shared Trees")
    }

    private var sharedList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Shared Trees")
                        .font(FaloTypography.headline)
                    Text(listSubtitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: "Marked for Social") {
                    if !appSettings.isSocialEnabled {
                        Text("Turn on Social in Settings to preview shared Trees.")
                            .foregroundStyle(.secondary)
                    } else if sharedTrees.isEmpty {
                        Text("No Trees are shared yet. Open a Tree and choose Main Photo, Basics, or Full Profile.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(sharedTrees) { tree in
                            Button {
                                selectedTreeID = tree.id
                            } label: {
                                HStack(spacing: FaloSpacing.medium) {
                                    sharedThumb(tree)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(listTitle(for: tree))
                                            .font(FaloCardTypography.fieldValue)
                                            .foregroundStyle(.primary)
                                        Text(tree.socialShareLevel.title)
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .faloScrollSurface()
    }

    private func sharedDetail(_ tree: Tree) -> some View {
        let level = tree.socialShareLevel
        return ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.large) {
                HStack {
                    Button("Shared Trees") { selectedTreeID = nil }
                        .buttonStyle(.borderless)
                    Spacer()
                    Button("Open Tree") {
                        appState.showTreeFromMap(treeID: tree.id)
                    }
                    .buttonStyle(.borderless)
                }
                if level == .mainPhoto {
                    sharedHero(tree)
                    Text("Main Photo only — no other fields are marked for Social.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                } else {
                    sharedHero(tree)
                    Text(listTitle(for: tree))
                        .font(FaloTypography.pageTitle)
                    Text(tree.socialShareLevel.title)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    if level == .basics || level == .fullProfile {
                        DetailCard(title: "Basics") {
                            labeled("Bonsai Name", tree.bonsaiName)
                            labeled("Species", tree.botanicalName)
                            labeled("Stage", stageTitle(for: tree))
                        }
                    }

                    if level == .fullProfile {
                        DetailCard(title: "Full Profile") {
                            labeled("Nickname", tree.nickname)
                            labeled("Health", tree.healthStatus.title)
                            labeled("Height", measurementLabel(tree.heightMillimetres))
                            labeled("Nebari", measurementLabel(tree.nebariWidthMillimetres))
                            labeled("Trunk", measurementLabel(tree.trunkDiameterMillimetres))
                            if !tree.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                labeled("Notes", tree.notes)
                            }
                            if !tree.knownHistory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                labeled("Known History", tree.knownHistory)
                            }
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
        }
        .faloScrollSurface()
    }

    private var listSubtitle: String {
        if !appSettings.isSocialEnabled {
            return "Social is off in Settings."
        }
        return "\(sharedTrees.count) tree(s) marked for Social in this library (local preview)."
    }

    private func listTitle(for tree: Tree) -> String {
        switch tree.socialShareLevel {
        case .mainPhoto:
            let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
            return name.isEmpty ? "Shared photo" : name
        case .off, .basics, .fullProfile:
            return TreePresentation.title(for: tree)
        }
    }

    private func stageTitle(for tree: Tree) -> String {
        guard let id = tree.treeStageID,
              let stage = referenceData.treeStages.first(where: { $0.id == id }) else {
            return FaloDisplayValue.empty
        }
        return stage.name
    }

    private func measurementLabel(_ mm: Int?) -> String {
        guard let mm else { return FaloDisplayValue.empty }
        return "\(mm) mm"
    }

    @ViewBuilder
    private func labeled(_ title: String, _ value: String) -> some View {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Text(trimmed.isEmpty ? FaloDisplayValue.empty : trimmed)
                .font(FaloCardTypography.fieldValue)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private func sharedThumb(_ tree: Tree) -> some View {
        Group {
            if let imageID = tree.listImageID {
                GalleryThumbnailImage(imageID: imageID)
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 56, height: 56)
        .background(BonsaiWorldColors.canvas)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    @ViewBuilder
    private func sharedHero(_ tree: Tree) -> some View {
        Group {
            if let imageID = tree.listImageID {
                GalleryThumbnailImage(imageID: imageID)
            } else {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .background(BonsaiWorldColors.canvas)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
