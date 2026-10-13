// swift-tools-version: 5.9
// Canonical shared domain for Bonsai World (macOS + iOS). Not UI, storage, or sync.
import PackageDescription

let package = Package(
    name: "BonsaiCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "BonsaiCore", targets: ["BonsaiCore"])
    ],
    targets: [
        .target(name: "BonsaiCore")
    ]
)

