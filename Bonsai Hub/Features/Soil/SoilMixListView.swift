//
//  SoilMixListView.swift
//  Bonsai World
//
//  Soil → Mixes list column (Pots pattern / CG1).
//

import SwiftUI

struct SoilMixListView: View {
    @Environment(AppState.self) private var appState
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var manager

    @State private var search = ""
    @State private var contextFilter: SoilMixContextTag?
    @State private var editorDraft: SoilMixDraft?

    private var mixes: [SoilMix] {
        referenceData.soilMixes
            .filter(\.isActive)
            .filter { mix in
                if let contextFilter {
                    return mix.contextTags.contains(contextFilter)
                }
                return true
            }
            .filter { mix in
                let needle = search.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !needle.isEmpty else { return true }
                return mix.name.localizedCaseInsensitiveContains(needle)
                    || mix.intendedUse.localizedCaseInsensitiveContains(needle)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                TextField("Search mixes", text: $search)
                    .textFieldStyle(.roundedBorder)
                Picker("Context", selection: $contextFilter) {
                    Text("Any context").tag(Optional<SoilMixContextTag>.none)
                    ForEach(SoilMixContextTag.allCases) { tag in
                        Text(tag.title).tag(Optional(tag))
                    }
                }
                .labelsHidden()
            }
            .padding(FaloSpacing.medium)

            Divider()

            List(mixes, selection: $appState.selectedSoilMixID) { mix in
                VStack(alignment: .leading, spacing: 2) {
                    Text(mix.name)
                        .font(FaloCardTypography.fieldValue)
                    Text(mixSubtitle(mix))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .tag(mix.id)
            }
            .faloScrollSurface()
            .overlay {
                if referenceData.soilMixes.isEmpty {
                    ContentUnavailableView(
                        "You haven't created any soil mixes yet.",
                        systemImage: "list.bullet.rectangle",
                        description: Text("Create your own mix from the materials in your stock.")
                    )
                }
            }
        }
        .sheet(item: $editorDraft) { draft in
            SoilMixEditorSheet(draft: draft)
        }
        .onAppear { consumeWantsNewSoilMix() }
        .onChange(of: appState.wantsNewSoilMix) { _, wants in
            guard wants else { return }
            consumeWantsNewSoilMix()
        }
    }

    private func consumeWantsNewSoilMix() {
        guard appState.wantsNewSoilMix else { return }
        editorDraft = manager.blankSoilMixDraft()
        appState.wantsNewSoilMix = false
    }

    private func mixSubtitle(_ mix: SoilMix) -> String {
        var parts: [String] = []
        if !mix.contextTags.isEmpty {
            parts.append(mix.contextTags.map(\.title).joined(separator: ", "))
        }
        if !mix.intendedUse.isEmpty {
            parts.append(mix.intendedUse)
        }
        parts.append(mix.isPercentageValid ? "100%" : "\(mix.totalPercentage)%")
        return parts.joined(separator: " · ")
    }
}
