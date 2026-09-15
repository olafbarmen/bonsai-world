//
//  StockReportView.swift
//  Bonsai World
//
//  Inventory → Stock Report — on-screen valuation + Excel export.
//

import SwiftUI
import UniformTypeIdentifiers

struct StockReportView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(PotService.self) private var potService
    @Environment(SoilStockService.self) private var soilStock
    @Environment(InventoryStockService.self) private var inventoryStock
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var focusedArea: StockReportArea?
    @State private var exportError: String?

    private var report: StockReport {
        StockReportBuilder.build(
            pots: potService.pots,
            soilItems: soilStock.items,
            inventoryItems: inventoryStock.items,
            referenceData: referenceData
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: FaloSpacing.large) {
                    summaryHeader
                    ForEach(report.sections) { section in
                        sectionCard(section)
                            .id(section.area)
                    }
                }
                .padding(FaloSpacing.medium)
            }
            .faloScrollSurface()
            .onAppear {
                applyPendingFocus(proxy: proxy)
            }
            .onChange(of: appState.pendingStockReportArea) { _, _ in
                applyPendingFocus(proxy: proxy)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Stock Report")
        .onAppear { consumeWantsExport() }
        .onChange(of: appState.wantsExportStockReport) { _, wants in
            guard wants else { return }
            consumeWantsExport()
        }
        .alert("Could Not Export", isPresented: Binding(
            get: { exportError != nil },
            set: { if !$0 { exportError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(exportError ?? "")
        }
    }

    private func consumeWantsExport() {
        guard appState.wantsExportStockReport else { return }
        appState.wantsExportStockReport = false
        Task { await exportExcel() }
    }

    private var summaryHeader: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Inventory stock value")
                .font(FaloTypography.sectionHeading)
            Text(CurrencyFormatting.string(Decimal(report.totalValue), currency: appSettings.currency))
                .font(FaloTypography.primaryValue)
            Text("\(report.totalLines) lines · \(report.lowStockCount) low stock · \(appSettings.currency.code)")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func sectionCard(_ section: StockReportSection) -> some View {
        let isFocused = focusedArea == section.area
        DetailCard(title: section.area.title) {
            if let message = section.placeholderMessage {
                Text(message)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else if section.lines.isEmpty {
                Text("No stock lines yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(section.lines) { line in
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(line.name)
                                .font(FaloCardTypography.fieldValue)
                            Text(line.quantityLabel)
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(lineValueText(line))
                                .font(FaloCardTypography.fieldValue)
                            if line.isLowStock {
                                Text("Low")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
                Divider()
                HStack {
                    Text("Section total")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(CurrencyFormatting.string(Decimal(section.sectionValue), currency: appSettings.currency))
                        .font(FaloCardTypography.fieldValue)
                }
            }
        }
        .overlay {
            if isFocused {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.accentColor.opacity(0.45), lineWidth: 1.5)
            }
        }
    }

    private func lineValueText(_ line: StockReportLine) -> String {
        if let value = line.lineValue {
            return CurrencyFormatting.string(Decimal(value), currency: appSettings.currency)
        }
        return "—"
    }

    private func applyPendingFocus(proxy: ScrollViewProxy) {
        guard let area = appState.pendingStockReportArea else { return }
        focusedArea = area
        appState.pendingStockReportArea = nil
        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(area, anchor: .top)
            }
        }
    }

    @MainActor
    private func exportExcel() async {
        let snapshot = report
        let currency = appSettings.currency
        guard let url = await ExportSavePanel.chooseURL(
            suggestedName: StockReportExport.suggestedFileName(date: snapshot.generatedAt),
            contentType: UTType(filenameExtension: "xlsx") ?? .data
        ) else { return }

        do {
            try await Task.detached(priority: .userInitiated) {
                try StockReportExport.write(report: snapshot, currency: currency, to: url)
            }.value
        } catch {
            exportError = error.localizedDescription
        }
    }
}
