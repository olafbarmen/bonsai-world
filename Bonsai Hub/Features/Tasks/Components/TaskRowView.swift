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
    var onPostpone: (() -> Void)? = nil
    /// Instant-complete rows can join multi-select (BK1 / BL1).
    var isSelectable: Bool = false
    var isSelected: Bool = false
    var onToggleSelection: (() -> Void)? = nil

    @Environment(AppState.self) private var appState

    private var canPostpone: Bool {
        onPostpone != nil && (occurrence.treeID != nil || !occurrence.isRecurring)
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
            if isSelectable, let onToggleSelection {
                Button(action: onToggleSelection) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isSelected ? BonsaiWorldColors.sidebarAccent : .secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSelected ? "Deselect" : "Select")
            }

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
                        .lineLimit(1)
                }
                Text("\(workTypeName) · \(treeName)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .layoutPriority(0)
            .contentShape(Rectangle())
            .onTapGesture { onOpenDetail() }

            HStack(spacing: FaloSpacing.medium) {
                Text(occurrence.dueDate, style: .date)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Button(occurrence.isInstant ? "Complete" : "Complete…") {
                    onComplete()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .fixedSize(horizontal: true, vertical: false)
            .layoutPriority(1)
        }
        .padding(.vertical, FaloSpacing.small)
        .contentShape(Rectangle())
        .contextMenu {
            Button(occurrence.isInstant ? "Complete" : "Complete…") {
                onComplete()
            }
            if canPostpone, let onPostpone {
                Button("Postpone…") {
                    onPostpone()
                }
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
