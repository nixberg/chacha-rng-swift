// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ChaCha",
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
