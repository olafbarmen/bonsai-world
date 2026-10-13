//
//  MobileShareSheet.swift
//  Bonsai World
//
//  UIKit share sheet for exporting the local iOS library package folder.
//

import SwiftUI
import UIKit

struct MobileShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    var onComplete: (() -> Void)? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.completionWithItemsHandler = { _, _, _, _ in
            onComplete?()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
