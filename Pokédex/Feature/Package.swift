// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "PokemonBrowser",
            targets: ["PokemonBrowser"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "PokemonBrowser",
            dependencies: [
                .product(name: "PokeAPI", package: "Core"),
                .product(name: "PokeDesign", package: "Core"),
            ]
        ),
        .testTarget(
            name: "PokemonBrowserTests",
            dependencies: [
                "PokemonBrowser",
            ]
        ),
    ]
)
