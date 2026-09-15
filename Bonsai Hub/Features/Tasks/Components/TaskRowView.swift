//
//  TaskRowView.swift
//  Bonsai World
//
//  One due TaskOccurrence in the Tasks workspace — title, Work Type, tree,
//  due date, and a completion action. A repeat icon marks Schedule-driven
//  occurrences (always complete in one action — every detail was fixed when
//  the Schedule was created). One-off Tasks show "Complete…" when they still
//  need the full Add Work form. Tapping the row (outside the button) opens
//  the full detail sheet — instructions, target, and a shortcut to the Tree.
//

import SwiftUI

struct TaskRowView: View {
    let occurrence: TaskOccurrence
    let workTypeName: String
    let treeName: String
    let onComplete: () -> Void
    var onOpenDetail: () -> Void = {}

    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: FaloSpacing.xSmall) {
                    if occurrence.isRecurring {
                        Image(systemName: "repeat")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    Text(occurrence.title)
                        .font(FaloTypography.body)
                        .foregroundStyle(.primary)
                }
                Text("\(workTypeName) · \(treeName)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture { onOpenDetail() }

            Spacer(minLength: FaloSpacing.medium)

            Text(occurrence.dueDate, style: .date)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            Button(occurrence.isInstant ? "Complete" : "Complete…") {
                onComplete()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.vertical, FaloSpacing.small)
        .contentShape(Rectangle())
        .contextMenu {
            Button(occurrence.isInstant ? "Complete" : "Complete…") {
                onComplete()
            }
            if let treeID = occurrence.treeID {
                Button("Open Tree") {
                    appState.showTreeFromMap(treeID: treeID)
                }
            } else if let seedBatchID = occurrence.seedBatchID {
                Button("Open Seed Batch") {
                    appState.showSeedBatch(batchID: seedBatchID)
                }
            } else if let yamadoriID = occurrence.yamadoriID {
                Button("Open Yamadori") {
                    appState.showYamadoriTrip(tripID: yamadoriID)
                }
            } else if let projectID = occurrence.nurseryPropagationProjectID {
                Button("Open Field Tree") {
                    appState.showFieldTree(projectID: projectID)
                }
            } else if occurrence.libraryInventoryKind == .soilStocktake {
                Button("Open Soil Stocktake") {
                    appState.presentSoilStocktake()
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(occurrence.title)
    }
}
