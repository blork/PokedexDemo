// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Base",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "Base",
            targets: ["Base"]
        ),
    ],
    targets: [
        .target(
            name: "Base"
        ),
        .testTarget(
            name: "BaseTests",
            dependencies: ["Base"]
        ),
    ]
)
