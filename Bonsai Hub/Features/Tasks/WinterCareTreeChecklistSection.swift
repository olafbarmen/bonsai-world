//
//  WinterCareTreeChecklistSection.swift
//  Bonsai World
//
//  Per-tree Winter Care step toggles for Task Details / Edit Task.
//  Progress lives on Tree.winterCareCompletedSteps — Location / Season unchanged.
//

import SwiftUI

struct WinterCareTreeChecklistSection: View {
    let treeID: UUID

    @Environment(WinterCareService.self) private var winterCare
    @Environment(TreeService.self) private var treeService
    @Environment(WeatherService.self) private var weatherService

    @State private var errorMessage: String?

    private var tree: Tree? {
        treeService.getTree(id: treeID)
    }

    private var completedSteps: Set<WinterCareStep> {
        Set(tree?.winterCareCompletedSteps ?? [])
    }

    private var allDone: Bool {
        guard let tree else { return false }
        return winterCare.hasCompletedAllSteps(tree)
    }

    var body: some View {
        Section("Checklist") {
            Text("Check off each step for this tree. Location and Season you update yourself.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            ForEach(WinterCareStep.allCases) { step in
                Toggle(isOn: binding(for: step)) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                        Text(step.help)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button("Mark all steps done") {
                markAllDone()
            }
            .disabled(allDone || tree == nil)

            if let errorMessage {
                Text(errorMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.statusCritical)
            }
        }
    }

    private func binding(for step: WinterCareStep) -> Binding<Bool> {
        Binding(
            get: { completedSteps.contains(step) },
            set: { isOn in
                do {
                    try winterCare.setStep(
                        step,
                        isComplete: isOn,
                        for: treeID,
                        snapshot: weatherService.snapshot
                    )
                    errorMessage = nil
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
        )
    }

    private func markAllDone() {
        do {
            try winterCare.markAllStepsDone(for: treeID, snapshot: weatherService.snapshot)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
