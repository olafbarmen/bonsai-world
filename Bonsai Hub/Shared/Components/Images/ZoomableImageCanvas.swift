//
//  ZoomableImageCanvas.swift
//  Bonsai World
//
//  Fit-to-window image with pinch / scroll zoom and pan when enlarged.
//

import AppKit
import SwiftUI

struct ZoomableImageCanvas: View {
    enum Style {
        case viewer
        case workspace
    }

    let displayImage: Image?
    var isLoading: Bool = false
    var loadFailed: Bool = false
    var style: Style = .viewer
    var contentPadding: CGFloat = FaloSpacing.large
    var resetTrigger: UUID = UUID()

    @Binding var zoomMultiplier: CGFloat
    @Binding var accumulatedZoom: CGFloat

    private var minZoom: CGFloat { style == .viewer ? 1.0 : 0.5 }
    private let maxZoom: CGFloat = 8.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                canvasBackground

                if let displayImage {
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        displayImage
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: fittedSize(in: geometry.size).width * zoomMultiplier,
                                height: fittedSize(in: geometry.size).height * zoomMultiplier
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(contentPadding)
                } else if isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(style == .viewer ? .white : .primary)
                } else if loadFailed {
                    ContentUnavailableView(
                        "Image Unavailable",
                        systemImage: "photo",
                        description: Text("The image could not be loaded.")
                    )
                    .foregroundStyle(style == .viewer ? .white : .primary)
                }
            }
        }
        .background {
            ScrollWheelZoomCapture { delta in
                applyScrollZoom(delta)
            }
        }
        .gesture(magnificationGesture)
        .onTapGesture(count: 2) {
            resetZoom()
        }
        .onChange(of: resetTrigger) { _, _ in
            resetZoom()
        }
        .help("Scroll or pinch to zoom. Double-click to reset.")
    }

    @ViewBuilder
    private var canvasBackground: some View {
        switch style {
        case .viewer:
            Color.clear
        case .workspace:
            Color(nsColor: .controlBackgroundColor)
                .overlay {
                    Color.primary.opacity(0.02)
                }
                .ignoresSafeArea()
        }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let proposed = accumulatedZoom * value
                zoomMultiplier = clamped(proposed)
            }
            .onEnded { value in
                accumulatedZoom = clamped(accumulatedZoom * value)
                zoomMultiplier = accumulatedZoom
            }
    }

    private func applyScrollZoom(_ deltaY: CGFloat) {
        let factor = pow(1.08, deltaY)
        accumulatedZoom = clamped(accumulatedZoom * factor)
        zoomMultiplier = accumulatedZoom
    }

    private func clamped(_ value: CGFloat) -> CGFloat {
        min(max(value, minZoom), maxZoom)
    }

    private func resetZoom() {
        zoomMultiplier = 1.0
        accumulatedZoom = 1.0
    }

    /// Size of the image when `zoomMultiplier` is 1 (fit within padded canvas).
    private func fittedSize(in canvasSize: CGSize) -> CGSize {
        let inset = contentPadding * 2
        let available = CGSize(
            width: max(canvasSize.width - inset, 1),
            height: max(canvasSize.height - inset, 1)
        )
        return available
    }
}

// MARK: - Scroll wheel zoom (macOS)

private struct ScrollWheelZoomCapture: NSViewRepresentable {
    var onScroll: (CGFloat) -> Void

    func makeNSView(context: Context) -> ScrollWheelZoomNSView {
        let view = ScrollWheelZoomNSView()
        view.onScroll = onScroll
        return view
    }

    func updateNSView(_ nsView: ScrollWheelZoomNSView, context: Context) {
        nsView.onScroll = onScroll
    }
}

private final class ScrollWheelZoomNSView: NSView {
    var onScroll: ((CGFloat) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func scrollWheel(with event: NSEvent) {
        onScroll?(event.deltaY)
    }
}

extension ZoomableImageCanvas {
    static func zoomIn(_ zoomMultiplier: inout CGFloat, _ accumulatedZoom: inout CGFloat, maxZoom: CGFloat = 8.0) {
        let next = min(accumulatedZoom * 1.25, maxZoom)
        accumulatedZoom = next
        zoomMultiplier = next
    }

    static func zoomOut(_ zoomMultiplier: inout CGFloat, _ accumulatedZoom: inout CGFloat, minZoom: CGFloat = 1.0) {
        let next = max(accumulatedZoom / 1.25, minZoom)
        accumulatedZoom = next
        zoomMultiplier = next
    }

    static func reset(_ zoomMultiplier: inout CGFloat, _ accumulatedZoom: inout CGFloat) {
        zoomMultiplier = 1.0
        accumulatedZoom = 1.0
    }
}
