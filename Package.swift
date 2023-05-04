// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "chacha-rng-swift",
    products: [
        .library(
            name: "ChaChaRNG",
            targets: ["ChaChaRNG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/nixberg/chacha-swift", branch: "main"),
    ],
    targets: [
        .target(
            name: "ChaChaRNG",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ChaCha", package: "chacha-swift"),
            ]),
        .testTarget(
            name: "ChaChaRNGTests",
            dependencies: ["ChaChaRNG"]),
    ]
)
