//
//  MobilePhotoViewer.swift
//  Bonsai World
//
//  Full-screen tree photo. Pinch to zoom.
//

import SwiftUI
import UIKit

struct MobilePhotoPage: Identifiable, Hashable {
    let id: UUID
    let data: Data
}

struct MobilePhotoViewer: View {
    let pages: [MobilePhotoPage]
    let startIndex: Int
    @Environment(\.dismiss) private var dismiss
    @State private var index: Int

    init(pages: [MobilePhotoPage], startIndex: Int) {
        self.pages = pages
        let clamped = pages.indices.contains(startIndex) ? startIndex : 0
        self.startIndex = clamped
        _index = State(initialValue: clamped)
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $index) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { offset, page in
                    MobileZoomablePhoto(data: page.data)
                        .tag(offset)
                        .accessibilityLabel("Photo")
                        .accessibilityHint("Pinch to zoom")
                }
            }
            .tabViewStyle(.page(indexDisplayMode: pages.count > 1 ? .automatic : .never))
            .background(Color.black)
            .navigationTitle(pages.count > 1 ? "\(index + 1) of \(pages.count)" : "Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
}

private struct MobileZoomablePhoto: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> MobileZoomScrollView {
        MobileZoomScrollView(image: UIImage(data: data))
    }

    func updateUIView(_ view: MobileZoomScrollView, context: Context) {
        view.setImage(UIImage(data: data))
    }
}

private final class MobileZoomScrollView: UIScrollView, UIScrollViewDelegate {
    private let imageView = UIImageView()

    init(image: UIImage?) {
        super.init(frame: .zero)
        delegate = self
        minimumZoomScale = 1
        maximumZoomScale = 6
        bouncesZoom = true
        backgroundColor = .black
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        addSubview(imageView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(_ image: UIImage?) {
        guard imageView.image !== image else { return }
        imageView.image = image
        setZoomScale(1, animated: false)
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if zoomScale == 1 {
            imageView.frame = bounds
            contentSize = bounds.size
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
