// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "PokeAPI",
            targets: ["PokeAPI"]
        ),
    ],
    targets: [
        .target(
            name: "PokeAPI"
        ),
        .testTarget(
            name: "PokeAPITests",
            dependencies: ["PokeAPI"]
        ),
    ]
)
