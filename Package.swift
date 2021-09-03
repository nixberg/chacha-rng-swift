// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "chacha-rng-swift",
    products: [
        .library(
            name: "ChaCha",
            targets: ["ChaCha"]),
    ],
    targets: [
        .target(
            name: "ChaCha"),
        .testTarget(
            name: "ChaChaTests",
            dependencies: ["ChaCha"]),
    ]
)
