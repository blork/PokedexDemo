// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]
        ),
    ],
    targets: [
        .target(
            name: "Feature"
        ),
        .testTarget(
            name: "FeatureTests",
            dependencies: ["Feature"]
        ),
    ]
)
