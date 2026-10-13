//
//  SoilMixPartsEditor.swift
//  Bonsai World
//
//  Field soil composition — 2–3 free-text name + % lines (A1).
//

import SwiftUI

struct SoilMixPartDraftLine: Identifiable, Hashable {
    var id: UUID
    var name: String
    var percentageText: String

    init(id: UUID = UUID(), name: String = "", percentageText: String = "") {
        self.id = id
        self.name = name
        self.percentageText = percentageText
    }

    static func emptyLines(count: Int = 3) -> [SoilMixPartDraftLine] {
        (0..<count).map { _ in SoilMixPartDraftLine() }
    }

    static func from(_ parts: [SoilMixPart], slotCount: Int = 3) -> [SoilMixPartDraftLine] {
        var lines = parts.prefix(slotCount).map {
            SoilMixPartDraftLine(
                id: $0.id,
                name: $0.componentName,
                percentageText: $0.percentage > 0 ? "\($0.percentage)" : ""
            )
        }
        while lines.count < slotCount {
            lines.append(SoilMixPartDraftLine())
        }
        return lines
    }

    static func toParts(_ lines: [SoilMixPartDraftLine]) -> [SoilMixPart] {
        lines.compactMap { line in
            let name = line.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { return nil }
            let pct = Int(line.percentageText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
            return SoilMixPart(
                id: line.id,
                componentID: line.id,
                componentName: name,
                percentage: max(0, min(100, pct))
            )
        }
    }

    static func totalPercentage(of lines: [SoilMixPartDraftLine]) -> Int {
        toParts(lines).reduce(0) { $0 + $1.percentage }
    }
}

struct SoilMixPartsEditor: View {
    @Binding var lines: [SoilMixPartDraftLine]

    private var total: Int { SoilMixPartDraftLine.totalPercentage(of: lines) }

    var body: some View {
        Section {
            ForEach($lines) { $line in
                HStack(spacing: FaloSpacing.medium) {
                    TextField("Component", text: $line.name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Component name")
                    TextField("%", text: $line.percentageText)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 52)
                        .accessibilityLabel("Percentage")
                }
            }
        } header: {
            Text("Composition")
        } footer: {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Button("50 / 25 / 25") {
                    applyFiftyTwentyFivePreset()
                }
                .font(FaloTypography.caption.weight(.semibold))
                .accessibilityLabel("Apply 50 25 25 percentage preset")

                Text(total == 100 ? "Total 100%." : "Total \(total)% — aim for 100%.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(total == 100 ? BonsaiWorldColors.textSecondary : BonsaiWorldColors.textTertiary)
            }
        }
    }

    private func applyFiftyTwentyFivePreset() {
        let percentages = ["50", "25", "25"]
        for index in lines.indices where index < percentages.count {
            lines[index].percentageText = percentages[index]
        }
    }
}
