//
//  MacPrintTreeHistory.swift
//  Bonsai World
//
//  Print / Save as PDF for Tree History — text sections + Development photos.
//

import AppKit
import Foundation

enum MacPrintTreeHistory {
    @MainActor
    static func run(
        document: TreeHistoryDocument,
        imageService: ImageService
    ) async {
        let title = "Tree History — \(document.title)"
        let images = await loadDevelopmentImages(document.developmentPhotos, imageService: imageService)
        let attributed = attributedDocument(document, images: images)

        let printInfo = NSPrintInfo.shared
        printInfo.topMargin = 36
        printInfo.bottomMargin = 36
        printInfo.leftMargin = 36
        printInfo.rightMargin = 36

        let width = max(320, printInfo.paperSize.width - printInfo.leftMargin - printInfo.rightMargin)
        let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: width, height: 100))
        textView.isEditable = false
        textView.isRichText = true
        textView.textContainerInset = .zero
        textView.minSize = NSSize(width: width, height: 0)
        textView.maxSize = NSSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        textView.textStorage?.setAttributedString(attributed)
        textView.layoutManager?.ensureLayout(for: textView.textContainer!)
        let used = textView.layoutManager?.usedRect(for: textView.textContainer!) ?? .zero
        textView.frame.size.height = max(used.height + 8, 100)

        let operation = NSPrintOperation(view: textView, printInfo: printInfo)
        operation.jobTitle = title
        operation.showsPrintPanel = true
        operation.showsProgressPanel = true
        operation.run()
    }

    private static func loadDevelopmentImages(
        _ photos: [TreeHistoryPhoto],
        imageService: ImageService
    ) async -> [UUID: NSImage] {
        var result: [UUID: NSImage] = [:]
        for photo in photos {
            if let image = try? await imageService.loadDisplayNSImage(
                for: photo.id,
                context: .treeThumbnail,
                maxPixelSize: 480
            ) {
                result[photo.id] = image
            }
        }
        return result
    }

    private static func attributedDocument(
        _ document: TreeHistoryDocument,
        images: [UUID: NSImage]
    ) -> NSAttributedString {
        let output = NSMutableAttributedString()
        let titleFont = NSFont.boldSystemFont(ofSize: 16)
        let headingFont = NSFont.boldSystemFont(ofSize: 12)
        let bodyFont = NSFont.systemFont(ofSize: 11)
        let captionFont = NSFont.systemFont(ofSize: 9)

        func append(_ string: String, font: NSFont, color: NSColor = .labelColor) {
            output.append(
                NSAttributedString(
                    string: string,
                    attributes: [
                        .font: font,
                        .foregroundColor: color
                    ]
                )
            )
        }

        func appendSection(_ heading: String, body: String) {
            let trimmed = body.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            append("\(heading)\n", font: headingFont)
            append("\(trimmed)\n\n", font: bodyFont)
        }

        append("Tree History — \(document.title)\n\n", font: titleFont)

        var wroteBody = false
        func markSection(_ heading: String, body: String) {
            let before = output.length
            appendSection(heading, body: body)
            if output.length > before { wroteBody = true }
        }

        markSection("Identity", body: document.identityLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        markSection("Acquisition", body: document.acquisitionLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        markSection("Yamadori", body: document.yamadoriLines.filter { !$0.isEmpty }.joined(separator: "\n"))
        markSection("Known History", body: document.knownHistory)

        if !document.journalBefore.isEmpty {
            markSection(
                "Journal — Before Ownership",
                body: document.journalBefore.map(formatJournal).joined(separator: "\n\n")
            )
        }
        if !document.journalDuring.isEmpty {
            markSection(
                "Journal",
                body: document.journalDuring.map(formatJournal).joined(separator: "\n\n")
            )
        }

        markSection(
            "Watering",
            body: careBody(summary: document.wateringSummaryLine, lines: document.wateringLines)
        )
        markSection(
            "Fertilizing",
            body: careBody(summary: document.fertilizingSummaryLine, lines: document.fertilizingLines)
        )
        var repot: [String] = []
        if let pot = document.currentPotLine, !pot.isEmpty { repot.append(pot) }
        repot.append(contentsOf: document.repottingLines)
        markSection("Repotting", body: repot.joined(separator: "\n"))

        if !document.developmentPhotos.isEmpty {
            wroteBody = true
            append("Development\n", font: headingFont)
            append("Oldest → newest\n\n", font: captionFont, color: .secondaryLabelColor)

            for photo in document.developmentPhotos {
                if let image = images[photo.id] {
                    let attachment = NSTextAttachment()
                    attachment.image = scaledImage(image, maxWidth: 120, maxHeight: 160)
                    output.append(NSAttributedString(attachment: attachment))
                    append("\n", font: captionFont)
                }
                let date = photo.date.formatted(date: .abbreviated, time: .omitted)
                let name = photo.name.trimmingCharacters(in: .whitespacesAndNewlines)
                let caption = name.isEmpty ? date : "\(date) — \(name)"
                append("\(caption)\n\n", font: captionFont, color: .secondaryLabelColor)
            }
        }

        if !document.timelineEvents.isEmpty {
            markSection(
                "Timeline",
                body: document.timelineEvents.map(formatTimeline).joined(separator: "\n")
            )
        }

        markSection("Notes", body: document.notes)

        if !wroteBody {
            append("No history recorded yet.\n", font: bodyFont)
        }

        return output
    }

    private static func careBody(summary: String?, lines: [String]) -> String {
        var parts: [String] = []
        if let summary, !summary.isEmpty { parts.append(summary) }
        parts.append(contentsOf: lines)
        return parts.joined(separator: "\n")
    }

    private static func formatJournal(_ entry: JournalEntry) -> String {
        let date = entry.recordedAt.formatted(date: .abbreviated, time: .omitted)
        let flag = entry.isBeforeOwnership ? " (before ownership)" : ""
        return "\(date)\(flag)\n\(entry.text)"
    }

    private static func formatTimeline(_ event: TreeTimelineEvent) -> String {
        let date = event.date.formatted(date: .abbreviated, time: .omitted)
        if let detail = event.detail, !detail.isEmpty {
            return "\(date) — \(event.headline): \(detail)"
        }
        return "\(date) — \(event.headline)"
    }

    private static func scaledImage(_ image: NSImage, maxWidth: CGFloat, maxHeight: CGFloat) -> NSImage {
        let size = image.size
        guard size.width > 0, size.height > 0 else { return image }
        let scale = min(maxWidth / size.width, maxHeight / size.height, 1)
        let target = NSSize(width: size.width * scale, height: size.height * scale)
        let scaled = NSImage(size: target)
        scaled.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(
            in: NSRect(origin: .zero, size: target),
            from: NSRect(origin: .zero, size: size),
            operation: .copy,
            fraction: 1
        )
        scaled.unlockFocus()
        return scaled
    }
}
