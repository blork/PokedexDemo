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
        .library(
            name: "PokeDesign",
            targets: ["PokeDesign"]
        ),
    ],
    dependencies: [
        .package(path: "../Base"),
    ],
    targets: [
        .target(
            name: "PokeAPI",
            dependencies: [
                .product(name: "Base", package: "Base"),
            ]
        ),
        .testTarget(
            name: "PokeAPITests",
            dependencies: ["PokeAPI"]
        ),
        .target(
            name: "PokeDesign",
            dependencies: [
                .product(name: "Base", package: "Base"),
            ]
        ),
    ]
)
