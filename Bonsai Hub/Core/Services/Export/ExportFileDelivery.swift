//
//  ExportFileDelivery.swift
//  Bonsai World
//
//  Opens exported files outside the sandbox quarantine delay.
//

import Foundation

enum ExportFileDelivery {
    /// Sandboxed apps mark exported copies with quarantine; Excel can hang on that scan.
    static func stripQuarantine(from url: URL) {
        url.withUnsafeFileSystemRepresentation { path in
            guard let path else { return }
            removexattr(path, "com.apple.quarantine", 0)
        }
    }
}
