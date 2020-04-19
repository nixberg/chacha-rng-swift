// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "ChaChaRNG",
    products: [
        .library(
            name: "ChaChaRNG",
            targets: ["ChaChaRNG"]),
    ],
    targets: [
        .target(
            name: "ChaChaRNG"),
        .testTarget(
            name: "ChaChaRNGTests",
            dependencies: ["ChaChaRNG"]),
    ]
)
