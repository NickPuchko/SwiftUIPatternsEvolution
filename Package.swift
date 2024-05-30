// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Store",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "Store",
            targets: ["Store"]
        ),
    ],
    targets: [
        .target(
            name: "Store"
        ),
        .testTarget(
            name: "StoreTests",
            dependencies: ["Store"]
        ),
    ]
)
