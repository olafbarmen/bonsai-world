//
//  StockReportExport.swift
//  Bonsai World
//
//  Excel export for Inventory → Stock Report.
//

import Foundation
import UniformTypeIdentifiers

enum StockReportExport {
    private static func dayStamp(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func suggestedFileName(date: Date = .now) -> String {
        "Bonsai World Stock Report \(dayStamp(for: date)).xlsx"
    }

    static func write(
        report: StockReport,
        currency: AppCurrency,
        to destinationURL: URL
    ) throws {
        let summaryRows = summarySheet(report: report, currency: currency)
        let detailRows = detailSheet(report: report, currency: currency)
        try MinimalXLSXWriter.write(
            sheets: [
                MinimalXLSXWriter.Sheet(name: "Summary", rows: summaryRows),
                MinimalXLSXWriter.Sheet(name: "Stock", rows: detailRows),
            ],
            to: destinationURL
        )
        ExportFileDelivery.stripQuarantine(from: destinationURL)
    }

    private static func summarySheet(report: StockReport, currency: AppCurrency) -> [[String]] {
        var rows: [[String]] = [
            ["Area", "Lines", "Low stock", "Value (\(currency.code))"],
        ]
        for section in report.sections {
            rows.append([
                section.area.title,
                section.placeholderMessage != nil ? "—" : "\(section.lineCount)",
                section.placeholderMessage != nil ? "—" : "\(section.lowStockCount)",
                section.placeholderMessage ?? formatAmount(section.sectionValue, currency: currency),
            ])
        }
        rows.append([])
        rows.append([
            "Total",
            "\(report.totalLines)",
            "\(report.lowStockCount)",
            formatAmount(report.totalValue, currency: currency),
        ])
        return rows
    }

    private static func detailSheet(report: StockReport, currency: AppCurrency) -> [[String]] {
        var rows: [[String]] = [
            ["Area", "Name", "Quantity", "Unit price (\(currency.code))", "Line value (\(currency.code))", "Low stock"],
        ]
        for section in report.sections {
            if let message = section.placeholderMessage {
                rows.append([section.area.title, message, "", "", "", ""])
                continue
            }
            for line in section.lines {
                rows.append([
                    section.area.title,
                    line.name,
                    line.quantityLabel,
                    line.unitPrice.map { formatAmount($0, currency: currency) } ?? "",
                    line.lineValue.map { formatAmount($0, currency: currency) } ?? "",
                    line.isLowStock ? "Yes" : "",
                ])
            }
        }
        return rows
    }

    private static func formatAmount(_ amount: Double, currency: AppCurrency) -> String {
        CurrencyFormatting.string(Decimal(amount), currency: currency)
    }
}
