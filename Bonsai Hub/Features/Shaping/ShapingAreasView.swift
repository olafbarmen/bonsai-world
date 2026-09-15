//
//  ShapingAreasView.swift
//  Bonsai World
//
//  Grouped practical Shaping areas below Vision.
//

import SwiftUI

struct ShapingAreasView: View {
    let treeID: UUID
    @Binding var shaping: TreeShaping
    var onReload: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: ShapingLayout.chapterGap) {
            ForEach(ShapingAreaGroup.allCases) { group in
                shapingGroup(group)
            }
        }
    }

    @ViewBuilder
    private func shapingGroup(_ group: ShapingAreaGroup) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text(group.title)
                .font(FaloTypography.headline)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
                ForEach(group.areas) { area in
                    ShapingAreaCard(
                        treeID: treeID,
                        area: area,
                        record: binding(for: area),
                        onReload: onReload
                    )
                }
            }
        }
    }

    private func binding(for area: ShapingAreaID) -> Binding<ShapingAreaRecord> {
        Binding(
            get: { shaping.record(for: area) },
            set: { newValue in
                shaping.setRecord(newValue, for: area)
            }
        )
    }
}
