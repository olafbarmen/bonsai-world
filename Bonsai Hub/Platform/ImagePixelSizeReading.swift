//
//  ImagePixelSizeReading.swift
//  Bonsai World
//
//  Platform-independent contract for reading the pixel dimensions of encoded
//  image data. Services depend on this protocol only — never on a concrete
//  OS image decoder. macOS conformance: Platform/macOS/MacImagePicker.swift.
//

import Foundation

/// Decodes the pixel dimensions of image data using the platform's native decoder.
protocol ImagePixelSizeReading: Sendable {
    func pixelSize(of data: Data) -> (width: Int, height: Int)
}
