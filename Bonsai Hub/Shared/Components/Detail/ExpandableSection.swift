//
//  ExpandableSection.swift
//  Bonsai World
//
//  Falo Component Library — progressive disclosure for Detail sections.
//  States: Collapsed · Summary · Expanded. Reuse across Worlds/modules.
//

import SwiftUI

/// Visual mode of an ``ExpandableSection``.
enum ExpandableSectionMode: Equatable, Sendable {
    /// Title, optional status, and expand control only.
    case collapsed
    /// Collapsed chrome plus up to three summary rows.
    case summary
    /// Full section content.
    case expanded
}

/// One summary line shown while the section is not expanded.
struct ExpandableSectionSummaryRow: Identifiable, Hashable, Sendable {
    var id: String
    var label: String
    var value: String

    init(id: String = UUID().uuidString, label: String, value: String) {
        self.id = id
        self.label = label
        self.value = value
    }

    init(label: String, value: String) {
        self.init(id: label, label: label, value: value)
    }
}

/// Reusable expandable Detail section (Falo progressive disclosure).
///
/// Detail form chrome vs quieter Overview / Dashboard-aligned chrome.
enum ExpandableSectionChrome: Equatable, Sendable {
    case detail
    case overview
}

/// - Collapsed: title + optional status + expand (no empty fields).
/// - Summary: up to three important rows while collapsed.
/// - Expanded: full `content`.
struct ExpandableSection<Content: View>: View {
    static var maxSummaryRows: Int { 3 }

    let title: String
    var status: String?
    var summaryRows: [ExpandableSectionSummaryRow]
    var chrome: ExpandableSectionChrome = .detail
    /// When true, section fills sibling row height (Overview 4-column grid).
    var fillsRowHeight: Bool = false
    @Binding var isExpanded: Bool
    @ViewBuilder var content: () -> Content

    init(
        title: String,
        status: String? = nil,
        summaryRows: [ExpandableSectionSummaryRow] = [],
        chrome: ExpandableSectionChrome = .detail,
        fillsRowHeight: Bool = false,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.status = status
        self.summaryRows = Array(summaryRows.prefix(Self.maxSummaryRows))
        self.chrome = chrome
        self.fillsRowHeight = fillsRowHeight
        self._isExpanded = isExpanded
        self.content = content
    }

    var mode: ExpandableSectionMode {
        if isExpanded { return .expanded }
        return summaryRows.isEmpty ? .collapsed : .summary
    }

    var body: some View {
        VStack(alignment: .leading, spacing: titleSpacing) {
            header

            switch mode {
            case .collapsed:
                EmptyView()
            case .summary:
                summaryBlock
            case .expanded:
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    content()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if fillsRowHeight {
                Spacer(minLength: 0)
            }
        }
        .padding(edgePadding)
        .frame(
            maxWidth: .infinity,
            maxHeight: fillsRowHeight ? .infinity : nil,
            alignment: .topLeading
        )
        .modifier(ExpandableSectionChromeModifier(chrome: chrome))
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }

    private var titleSpacing: CGFloat {
        chrome == .overview ? TreeOverviewSpacing.titleToContent : FaloCardTypography.titleToContent
    }

    private var edgePadding: CGFloat {
        chrome == .overview ? TreeOverviewSpacing.cardPadding : FaloSpacing.medium
    }

    private var header: some View {
        HStack(alignment: .center, spacing: FaloSpacing.small) {
            Text(title)
                .font(chrome == .overview ? FaloTypography.sectionHeading : FaloCardTypography.sectionTitle)
                .foregroundStyle(chrome == .overview ? BonsaiWorldColors.textPrimary : .secondary)
                .textCase(chrome == .overview ? nil : .uppercase)
                .tracking(chrome == .overview ? 0 : FaloCardTypography.sectionTitleTracking)
                .accessibilityAddTraits(.isHeader)

            if let status, !status.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(status)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .accessibilityLabel("Status \(status)")
            }

            Spacer(minLength: FaloSpacing.small)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                if chrome == .overview {
                    // Explicit expand copy — avoids chevron.right reading as “navigate away”.
                    Text(isExpanded ? "Show less" : "Show more")
                        .font(FaloTypography.caption.weight(.medium))
                        .foregroundStyle(BonsaiWorldColors.accent)
                } else {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
            }
            .buttonStyle(.plain)
            .help(isExpanded ? "Collapse section" : "Expand section")
            .accessibilityLabel(isExpanded ? "Collapse \(title)" : "Expand \(title)")
        }
    }

    private var summaryBlock: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            ForEach(summaryRows) { row in
                if chrome == .overview {
                    DashboardMetricRow(title: row.label, value: row.value, compact: true)
                } else {
                    DetailLabeledRow(label: row.label, value: row.value)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var accessibilityLabel: String {
        var parts = [title]
        if let status, !status.isEmpty {
            parts.append(status)
        }
        return parts.joined(separator: ", ")
    }
}

private struct ExpandableSectionChromeModifier: ViewModifier {
    let chrome: ExpandableSectionChrome

    func body(content: Content) -> some View {
        switch chrome {
        case .detail:
            content.background {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(BonsaiWorldColors.surface)
            }
        case .overview:
            // Quieter than primary Overview modules: surface + hairline, no elevation shadow.
            content
                .background {
                    RoundedRectangle(cornerRadius: FaloSurface.cornerRadius, style: .continuous)
                        .fill(BonsaiWorldColors.surface)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: FaloSurface.cornerRadius, style: .continuous)
                        .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
                }
        }
    }
}

#Preview("Summary") {
    ExpandableSection(
        title: "Ownership",
        status: "Active",
        summaryRows: [
            ExpandableSectionSummaryRow(label: "Acquired", value: "Private Seller"),
            ExpandableSectionSummaryRow(label: "Status", value: "Active")
        ],
        isExpanded: .constant(false)
    ) {
        DetailLabeledRow(label: "Acquisition Method", value: "Private Seller")
    }
    .padding()
    .frame(width: 420)
}
