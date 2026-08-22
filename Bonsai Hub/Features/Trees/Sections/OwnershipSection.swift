//
//  OwnershipSection.swift
//  Bonsai World
//
//  Tree Detail — Ownership (Acquisition + Disposal) via ExpandableSection.
//  Disposal stays hidden until a method exists or the section is expanded for editing.
//

import SwiftUI

struct OwnershipSection: View {
    @Environment(AppSettings.self) private var appSettings

    @Binding var acquisitionDate: Date?
    @Binding var acquisitionMethodID: UUID?
    @Binding var acquisitionSourceName: String
    @Binding var purchasePrice: Decimal?
    @Binding var acquisitionNotes: String

    @Binding var disposalDate: Date?
    @Binding var disposalMethodID: UUID?
    @Binding var disposalPartyName: String
    @Binding var disposalPrice: Decimal?
    @Binding var disposalNotes: String

    let acquisitionMethods: [DetailPickerOption]
    let disposalMethods: [DetailPickerOption]
    var isEditing: Bool

    @State private var isExpanded = false

    private var acquisitionMethodName: String {
        DetailOptionPickerRow.displayName(for: acquisitionMethodID, in: acquisitionMethods)
    }

    private var disposalMethodName: String {
        DetailOptionPickerRow.displayName(for: disposalMethodID, in: disposalMethods)
    }

    private var hasDisposalMethod: Bool {
        disposalMethodID != nil
    }

    private var acquisitionSummary: String? {
        let source = acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !source.isEmpty { return source }
        if !acquisitionMethodName.isEmpty { return acquisitionMethodName }
        let date = ownershipDateLabel(acquisitionDate)
        if date != FaloDisplayValue.empty { return date }
        return nil
    }

    private var disposalSummary: String? {
        guard hasDisposalMethod else { return nil }
        if !disposalMethodName.isEmpty { return disposalMethodName }
        return nil
    }

    private var ownershipStatus: String {
        if hasDisposalMethod {
            return disposalMethodName.isEmpty ? "Disposed" : disposalMethodName
        }
        return "Active"
    }

    private var summaryRows: [ExpandableSectionSummaryRow] {
        var rows: [ExpandableSectionSummaryRow] = []
        if let acquisitionSummary {
            rows.append(ExpandableSectionSummaryRow(label: "Acquired", value: acquisitionSummary))
        }
        if let disposalSummary {
            rows.append(ExpandableSectionSummaryRow(label: "Disposed", value: disposalSummary))
        }
        rows.append(ExpandableSectionSummaryRow(label: "Status", value: ownershipStatus))
        return rows
    }

    /// Disposal editors / details when expanded: always in Edit; in View only if a method exists.
    private var showsDisposalSubsection: Bool {
        isEditing || hasDisposalMethod
    }

    private var acquisitionSourceFieldLabel: String {
        OwnershipFieldLabels.acquisitionSourceLabel(
            methodName: acquisitionMethodName.isEmpty ? nil : acquisitionMethodName
        )
    }

    private var disposalPartyFieldLabel: String {
        OwnershipFieldLabels.disposalPartyLabel(
            methodName: disposalMethodName.isEmpty ? nil : disposalMethodName
        )
    }

    var body: some View {
        ExpandableSection(
            title: "Ownership",
            status: ownershipStatus,
            summaryRows: summaryRows,
            isExpanded: $isExpanded
        ) {
            acquisitionBlock

            if showsDisposalSubsection {
                disposalBlock
            }
        }
        .onChange(of: isEditing) { _, editing in
            if editing {
                Task { @MainActor in
                    isExpanded = true
                }
            }
        }
        .onAppear {
            if isEditing {
                Task { @MainActor in
                    isExpanded = true
                }
            }
        }
    }

    @ViewBuilder
    private var acquisitionBlock: some View {
        Text("Acquisition")
            .font(FaloTypography.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.top, FaloSpacing.xSmall)

        if isEditing {
            ownershipOptionalDateRow(label: "Acquisition Date", date: $acquisitionDate)

            DetailOptionPickerRow(
                label: "Acquisition Method",
                selection: $acquisitionMethodID,
                placeholder: "Select Acquisition Method",
                options: acquisitionMethods
            )

            DetailEditableTextRow(
                label: acquisitionSourceFieldLabel,
                text: $acquisitionSourceName,
                help: "Free-text source for the selected acquisition method"
            )

            DetailEditableTextRow(
                label: "Purchase Price (\(appSettings.currency.code))",
                text: ownershipDecimalTextBinding($purchasePrice),
                help: "Numeric amount only. Display currency is set in Settings → Regional Settings."
            )

            DetailEditableTextRow(
                label: "Acquisition Notes",
                text: $acquisitionNotes
            )
        } else {
            ownershipNonEmptyRow(label: "Acquisition Date", value: ownershipDateLabel(acquisitionDate))
            ownershipNonEmptyRow(label: "Acquisition Method", value: acquisitionMethodName)
            ownershipNonEmptyRow(label: acquisitionSourceFieldLabel, value: acquisitionSourceName)
            ownershipNonEmptyRow(
                label: "Purchase Price",
                value: CurrencyFormatting.string(purchasePrice, currency: appSettings.currency)
            )
            ownershipNonEmptyRow(label: "Acquisition Notes", value: acquisitionNotes)
        }
    }

    @ViewBuilder
    private var disposalBlock: some View {
        Text("Disposal")
            .font(FaloTypography.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.top, FaloSpacing.medium)

        if isEditing {
            ownershipOptionalDateRow(label: "Disposal Date", date: $disposalDate)

            DetailOptionPickerRow(
                label: "Disposal Method",
                selection: $disposalMethodID,
                placeholder: "Select Disposal Method",
                options: disposalMethods
            )

            DetailEditableTextRow(
                label: disposalPartyFieldLabel,
                text: $disposalPartyName,
                help: "Free-text detail for the selected disposal method"
            )

            DetailEditableTextRow(
                label: "Disposal Price (\(appSettings.currency.code))",
                text: ownershipDecimalTextBinding($disposalPrice),
                help: "Numeric amount only. Display currency is set in Settings → Regional Settings."
            )

            DetailEditableTextRow(
                label: "Disposal Notes",
                text: $disposalNotes
            )
        } else {
            ownershipNonEmptyRow(label: "Disposal Date", value: ownershipDateLabel(disposalDate))
            ownershipNonEmptyRow(label: "Disposal Method", value: disposalMethodName)
            ownershipNonEmptyRow(label: disposalPartyFieldLabel, value: disposalPartyName)
            ownershipNonEmptyRow(
                label: "Disposal Price",
                value: CurrencyFormatting.string(disposalPrice, currency: appSettings.currency)
            )
            ownershipNonEmptyRow(label: "Disposal Notes", value: disposalNotes)
        }
    }

    @ViewBuilder
    private func ownershipNonEmptyRow(label: String, value: String) -> some View {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty, trimmed != FaloDisplayValue.empty {
            DetailLabeledRow(label: label, value: trimmed)
        }
    }
}

// MARK: - Field helpers

@ViewBuilder
private func ownershipOptionalDateRow(label: String, date: Binding<Date?>) -> some View {
    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
        Text(label)
            .font(FaloTypography.caption)
            .foregroundStyle(.secondary)

        DatePicker(
            label,
            selection: Binding(
                get: { date.wrappedValue ?? Date.now },
                set: { date.wrappedValue = $0 }
            ),
            displayedComponents: .date
        )
        .labelsHidden()
        .datePickerStyle(.compact)
    }
    .padding(.vertical, FaloSpacing.xSmall)
}

private func ownershipDateLabel(_ date: Date?) -> String {
    guard let date else { return FaloDisplayValue.empty }
    return date.formatted(.dateTime.month().day().year())
}

private func ownershipDecimalTextBinding(_ value: Binding<Decimal?>) -> Binding<String> {
    Binding(
        get: { CurrencyFormatting.editableNumericString(value.wrappedValue) },
        set: { value.wrappedValue = CurrencyFormatting.parseAmount($0) }
    )
}
