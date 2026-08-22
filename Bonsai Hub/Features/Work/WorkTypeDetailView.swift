//
//  WorkTypeDetailView.swift
//  Bonsai World
//
//  Work module detail — read-only Work Type summary (foundation).
//  Performing work / templates / scheduling land in later workflows.
//

import SwiftUI

struct WorkTypeDetailView: View {
    @Environment(WorkService.self) private var workService
    @Environment(AppState.self) private var appState

    private var workType: WorkType? {
        guard let id = appState.selectedWorkTypeID else { return nil }
        return workService.workType(id: id)
    }

    var body: some View {
        Group {
            if let workType {
                ScrollView {
                    DetailContentColumn {
                        DetailSectionStack {
                            DetailCard(title: workType.name) {
                                DetailLabeledRow(label: "Category", value: workType.category.title)
                                DetailLabeledRow(
                                    label: "Description",
                                    value: workType.workDescription
                                )
                                DetailLabeledRow(
                                    label: "Notes",
                                    value: workType.notes
                                )
                            }

                            DetailCard(title: "Behaviour (prepared)") {
                                behaviourRow("Requires Soil Mix", workType.behaviour.requiresSoilMix)
                                behaviourRow("Requires Pot", workType.behaviour.requiresPot)
                                behaviourRow("Requires Fertilizer", workType.behaviour.requiresFertilizer)
                                behaviourRow("Requires Product", workType.behaviour.requiresProduct)
                                behaviourRow("Requires Wire", workType.behaviour.requiresWire)
                                behaviourRow("Requires Measurements", workType.behaviour.requiresMeasurements)
                                behaviourRow("Creates Tree History", workType.behaviour.createsTreeHistory)
                                behaviourRow("Affects Inventory", workType.behaviour.affectsInventory)
                                behaviourRow("Affects Economy", workType.behaviour.affectsEconomy)
                                behaviourRow("Multiple Trees", workType.behaviour.canApplyToMultipleTrees)
                                behaviourRow("Can be scheduled", workType.behaviour.canBeScheduled)
                                behaviourRow("Can use Templates", workType.behaviour.canUseTemplates)
                            }

                            DetailCard(title: "Register Work") {
                                Text("Logging, batch operations, templates, and scheduling will appear here. Work History will then show on each Tree.")
                                    .font(FaloTypography.body)
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, FaloSpacing.xSmall)
                            }
                        }
                    }
                }
                .faloScrollSurface()
                .navigationTitle(workType.name)
            } else {
                ContentUnavailableView(
                    "Select a Work Type",
                    systemImage: "wrench.and.screwdriver",
                    description: Text("Choose a Work Type to review it. Performing work comes next.")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }

    private func behaviourRow(_ label: String, _ value: Bool) -> some View {
        DetailLabeledRow(label: label, value: value ? "Yes" : "No")
    }
}
