// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "chacha-rng-swift",
    products: [
        .library(
            name: "ChaCha",
            targets: ["ChaCha"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
        .package(url: "https://github.com/nixberg/endianbytes-swift", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "ChaCha",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "EndianBytes", package: "endianbytes-swift"),
            ]),
        .testTarget(
            name: "ChaChaTests",
            dependencies: ["ChaCha"]),
    ]
)
