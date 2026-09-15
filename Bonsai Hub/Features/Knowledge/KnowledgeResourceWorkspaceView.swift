//
//  KnowledgeResourceWorkspaceView.swift
//  Bonsai World
//
//  Knowledge → Quick Guides / FAQ / Courses / Video Tutorials / External Links (v1).
//

import AppKit
import SwiftUI

struct KnowledgeResourceWorkspaceView: View {
    let kind: KnowledgeResourceKind

    @Environment(AppState.self) private var appState
    @Environment(KnowledgeResourceService.self) private var service

    @State private var isCreatePresented = false

    private var selectedID: UUID? {
        appState.selectedKnowledgeResourceID(for: kind)
    }

    var body: some View {
        Group {
            if let selectedID, let resource = service.resource(id: selectedID), resource.kind == kind {
                KnowledgeResourceDetailView(kind: kind, resourceID: selectedID)
            } else {
                KnowledgeResourceListView(kind: kind, isCreatePresented: $isCreatePresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(kind.title)
        .sheet(isPresented: $isCreatePresented) {
            NewKnowledgeResourceView(kind: kind)
        }
        .onAppear { consumeWantsNewKnowledgeResource() }
        .onChange(of: appState.wantsNewKnowledgeResourceKind) { _, pending in
            guard pending == kind else { return }
            consumeWantsNewKnowledgeResource()
        }
    }

    private func consumeWantsNewKnowledgeResource() {
        guard appState.wantsNewKnowledgeResourceKind == kind else { return }
        isCreatePresented = true
        appState.wantsNewKnowledgeResourceKind = nil
    }
}

struct KnowledgeResourceListView: View {
    let kind: KnowledgeResourceKind
    @Binding var isCreatePresented: Bool

    @Environment(AppState.self) private var appState
    @Environment(KnowledgeResourceService.self) private var service

    private var resources: [KnowledgeResource] {
        service.resources(kind: kind)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(kind.title)
                        .font(FaloTypography.headline)
                    Text("\(resources.count) entries")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: kind.title) {
                    if resources.isEmpty {
                        Text("No \(kind.title.lowercased()) yet.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(resources) { resource in
                            Button {
                                appState.setSelectedKnowledgeResourceID(resource.id, for: kind)
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(resource.title)
                                        .font(FaloCardTypography.fieldValue)
                                        .foregroundStyle(.primary)
                                    if !resource.summary.isEmpty {
                                        Text(resource.summary)
                                            .font(FaloTypography.caption)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, FaloSpacing.xSmall)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }
}

struct KnowledgeResourceDetailView: View {
    let kind: KnowledgeResourceKind
    let resourceID: UUID

    @Environment(AppState.self) private var appState
    @Environment(KnowledgeResourceService.self) private var service

    private var resource: KnowledgeResource? { service.resource(id: resourceID) }

    var body: some View {
        Group {
            if let resource {
                ScrollView {
                    VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                        Button("All \(kind.title)") {
                            appState.setSelectedKnowledgeResourceID(nil, for: kind)
                        }
                        .buttonStyle(.borderless)
                        VStack(alignment: .leading, spacing: FaloSpacing.small) {
                            Text(resource.title)
                                .font(FaloTypography.pageTitle)
                            if !resource.summary.isEmpty {
                                Text(resource.summary)
                                    .font(FaloTypography.pageSubtitle)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        if !resource.body.isEmpty {
                            DetailCard(title: "Content") {
                                Text(resource.body)
                                    .font(FaloTypography.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        if !resource.urlString.isEmpty {
                            DetailCard(title: "Link") {
                                Button(resource.urlString) {
                                    if let url = URL(string: resource.urlString) {
                                        NSWorkspace.shared.open(url)
                                    }
                                }
                                .buttonStyle(.link)
                            }
                        }
                    }
                    .padding(FaloSpacing.xLarge)
                    .frame(maxWidth: 900, alignment: .leading)
                }
                .faloScrollSurface()
            } else {
                ContentUnavailableView("Not found", systemImage: kind.systemImage)
            }
        }
    }
}

struct NewKnowledgeResourceView: View {
    let kind: KnowledgeResourceKind

    @Environment(\.dismiss) private var dismiss
    @Environment(KnowledgeResourceService.self) private var service
    @Environment(AppState.self) private var appState

    @State private var title = ""
    @State private var summary = ""
    @State private var bodyText = ""
    @State private var urlString = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Summary", text: $summary)
                    TextField("Content", text: $bodyText, axis: .vertical)
                        .lineLimit(4...10)
                    if kind == .externalLink || kind == .videoTutorial {
                        TextField("URL", text: $urlString)
                    }
                }
                if let errorMessage {
                    Section { Text(errorMessage).foregroundStyle(.red) }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Add \(kind.singularTitle)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .frame(minWidth: 480, minHeight: 420)
    }

    private func create() {
        do {
            let resource = try service.create(
                KnowledgeResourceCreateDraft(
                    kind: kind,
                    title: title,
                    summary: summary,
                    body: bodyText,
                    urlString: urlString
                )
            )
            appState.setSelectedKnowledgeResourceID(resource.id, for: kind)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
