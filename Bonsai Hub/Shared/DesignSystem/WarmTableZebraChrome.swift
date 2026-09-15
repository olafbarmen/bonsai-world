//
//  WarmTableZebraChrome.swift
//  Bonsai World
//
//  Full-row warm zebra for SwiftUI `Table` (backed by NSTableView).
//  Cell-level backgrounds leave white gutters between columns; row views do not.
//

import AppKit
import SwiftUI

extension View {
    /// Paints entire table rows canvas / surface — continuous across columns.
    func faloWarmTableZebraRows() -> some View {
        background(WarmTableZebraInstaller())
    }
}

private struct WarmTableZebraInstaller: NSViewRepresentable {
    func makeNSView(context: Context) -> WarmTableZebraAnchor {
        WarmTableZebraAnchor()
    }

    func updateNSView(_ nsView: WarmTableZebraAnchor, context: Context) {
        nsView.scheduleApply()
    }
}

final class WarmTableZebraAnchor: NSView {
    private var scrollObserver: NSObjectProtocol?
    private var frameObserver: NSObjectProtocol?
    private weak var trackedTable: NSTableView?

    private static let canvas = NSColor(srgbRed: 0xF7 / 255, green: 0xF4 / 255, blue: 0xEF / 255, alpha: 1)
    private static let surface = NSColor(srgbRed: 0xFB / 255, green: 0xFA / 255, blue: 0xF7 / 255, alpha: 1)

    override var isHidden: Bool {
        get { true }
        set {}
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        scheduleApply()
    }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        scheduleApply()
    }

    deinit {
        clearObservers()
    }

    func scheduleApply() {
        DispatchQueue.main.async { [weak self] in
            self?.apply()
        }
    }

    private func apply() {
        guard let table = findTableView() else { return }
        if trackedTable !== table {
            clearObservers()
            trackedTable = table
            attachObservers(to: table)
        }

        table.usesAlternatingRowBackgroundColors = false
        table.backgroundColor = Self.canvas
        if let scrollView = table.enclosingScrollView {
            scrollView.drawsBackground = true
            scrollView.backgroundColor = Self.canvas
        }

        for row in 0..<table.numberOfRows {
            guard let rowView = table.rowView(atRow: row, makeIfNecessary: false) else { continue }
            let fill = BonsaiWorldTableZebra.isAlternate(at: row) ? Self.surface : Self.canvas
            rowView.backgroundColor = fill
            rowView.wantsLayer = true
            rowView.layer?.backgroundColor = fill.cgColor
        }
    }

    private func attachObservers(to table: NSTableView) {
        let scrollView = table.enclosingScrollView
        if let clip = scrollView?.contentView {
            clip.postsBoundsChangedNotifications = true
            frameObserver = NotificationCenter.default.addObserver(
                forName: NSView.boundsDidChangeNotification,
                object: clip,
                queue: .main
            ) { [weak self] _ in
                self?.apply()
            }
        }
        if let scrollView {
            scrollObserver = NotificationCenter.default.addObserver(
                forName: NSScrollView.didLiveScrollNotification,
                object: scrollView,
                queue: .main
            ) { [weak self] _ in
                self?.apply()
            }
        }
    }

    private func clearObservers() {
        if let scrollObserver {
            NotificationCenter.default.removeObserver(scrollObserver)
            self.scrollObserver = nil
        }
        if let frameObserver {
            NotificationCenter.default.removeObserver(frameObserver)
            self.frameObserver = nil
        }
        trackedTable = nil
    }

    private func findTableView() -> NSTableView? {
        var origin: NSView? = self
        while let parent = origin?.superview {
            let tables = allTables(in: parent)
            if tables.count == 1 {
                return tables[0]
            }
            if tables.count > 1 {
                return nearestTable(in: tables)
            }
            origin = parent
        }
        return nil
    }

    private func allTables(in root: NSView) -> [NSTableView] {
        var result: [NSTableView] = []
        if let table = root as? NSTableView {
            result.append(table)
        }
        for child in root.subviews {
            result.append(contentsOf: allTables(in: child))
        }
        return result
    }

    private func nearestTable(in tables: [NSTableView]) -> NSTableView? {
        let anchorFrame = convert(bounds, to: nil)
        return tables.min { lhs, rhs in
            let left = lhs.convert(lhs.bounds, to: nil)
            let right = rhs.convert(rhs.bounds, to: nil)
            return hypot(left.midX - anchorFrame.midX, left.midY - anchorFrame.midY)
                < hypot(right.midX - anchorFrame.midX, right.midY - anchorFrame.midY)
        }
    }
}
