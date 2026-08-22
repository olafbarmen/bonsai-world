//
//  WorkBrowserView.swift
//  Bonsai World
//
//  Workshop domain (working name) — technical module: Work.
//  Browse Work Types from Reference Data. Logging / batch / templates later.
//  Trees display Work History; they never own registration.
//  Domain terminology: ``WorkingDomainID/workshop``.
//

import SwiftUI

struct WorkBrowserView: View {
    @Environment(AppState.self) private var appState
    @Environment(WorkService.self) private var workService

    var body: some View {
        @Bindable var appState = appState

        Group {
            if workService.workTypes.isEmpty {
                ContentUnavailableView(
                    "No Work Types",
                    systemImage: "wrench.and.screwdriver",
                    description: Text("Add Work Types in Settings → Reference Data → Work.")
                )
            } else {
                List(selection: $appState.selectedWorkTypeID) {
                    Section {
                        Text("Perform care and styling from Work. Trees only show the resulting history.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .listRowBackground(Color.clear)
                    }

                    ForEach(WorkTypeCategory.allCases) { category in
                        let types = workService.workTypes(in: category)
                        if !types.isEmpty {
                            Section(category.title) {
                                ForEach(types) { workType in
                                    WorkTypeBrowserRow(workType: workType)
                                        .tag(workType.id)
                                }
                            }
                        }
                    }
                }
                .listStyle(.sidebar)
                .faloScrollSurface()
            }
        }
        .background(.windowBackground)
        .navigationTitle("Work")
        .navigationSplitViewColumnWidth(min: 280, ideal: 360, max: 480)
    }
}

private struct WorkTypeBrowserRow: View {
    let workType: WorkType

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(workType.name)
                .font(FaloTypography.body)
            if !workType.workDescription.isEmpty {
                Text(workType.workDescription)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}
