//
//  KnowledgeGuideMatrix.swift
//  Bonsai World
//
//  Quiet decision table for Knowledge reading pages.
//  Falo card typography and separators — not a data Table.
//

import SwiftUI

struct KnowledgeGuideMatrix: View {
    var leadingHeader: String
    var columnHeaders: [String]
    var rows: [KnowledgeGuideMatrixRow]
    var leadingColumnWidth: CGFloat = 168

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                headerCell(leadingHeader, alignment: .leading)
                    .frame(minWidth: leadingColumnWidth, alignment: .leading)
                ForEach(Array(columnHeaders.enumerated()), id: \.offset) { _, header in
                    headerCell(header, alignment: .leading)
                        .gridCellColumns(1)
                }
            }

            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                GridRow {
                    Text(row.leading)
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                        .frame(minWidth: leadingColumnWidth, maxWidth: leadingColumnWidth, alignment: .topLeading)
                        .padding(.vertical, FaloSpacing.small)
                        .padding(.horizontal, FaloSpacing.small)

                    ForEach(Array(row.cells.enumerated()), id: \.offset) { _, cell in
                        Text(cell)
                            .font(FaloCardTypography.fieldValue)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.vertical, FaloSpacing.small)
                            .padding(.horizontal, FaloSpacing.small)
                            .textSelection(.enabled)
                    }
                }
                .background {
                    Rectangle()
                        .fill(index.isMultiple(of: 2) ? Color.primary.opacity(0.02) : Color.clear)
                }
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .accessibilityElement(children: .contain)
    }

    private func headerCell(_ title: String, alignment: Alignment) -> some View {
        Text(title)
            .font(FaloCardTypography.sectionTitle)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(FaloCardTypography.sectionTitleTracking)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .frame(maxWidth: .infinity, minHeight: 28, alignment: alignment)
            .padding(.vertical, FaloSpacing.small)
            .padding(.horizontal, FaloSpacing.small)
            .background(Color.primary.opacity(0.04))
    }
}
