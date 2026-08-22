//
//  ImageCaptureDateReader.swift
//  Bonsai World
//
//  Reads Capture Date from image EXIF / TIFF metadata via ImageIO.
//

import Foundation
import ImageIO

enum ImageCaptureDateReader {
    /// Prefer EXIF DateTimeOriginal, then TIFF DateTime. Returns nil when absent.
    static func captureDate(from data: Data) -> Date? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any]
        else {
            return nil
        }

        if let exif = properties[kCGImagePropertyExifDictionary] as? [CFString: Any] {
            if let raw = exif[kCGImagePropertyExifDateTimeOriginal] as? String,
               let date = parseEXIFDateString(raw) {
                return date
            }
            if let raw = exif[kCGImagePropertyExifDateTimeDigitized] as? String,
               let date = parseEXIFDateString(raw) {
                return date
            }
        }

        if let tiff = properties[kCGImagePropertyTIFFDictionary] as? [CFString: Any],
           let raw = tiff[kCGImagePropertyTIFFDateTime] as? String,
           let date = parseEXIFDateString(raw) {
            return date
        }

        return nil
    }

    /// EXIF / TIFF date strings are typically `yyyy:MM:dd HH:mm:ss`.
    private static func parseEXIFDateString(_ raw: String) -> Date? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != "0000:00:00 00:00:00" else { return nil }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        if let date = formatter.date(from: trimmed) {
            return date
        }

        formatter.dateFormat = "yyyy:MM:dd"
        return formatter.date(from: trimmed)
    }
}
