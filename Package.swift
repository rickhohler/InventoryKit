// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InventoryKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "InventoryKit",
            targets: ["InventoryKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.2"),
        .package(url: "https://github.com/rickhohler/DesignAlgorithmsKit.git", from: "1.0.3"),
    ],
    targets: [
        .target(
            name: "InventoryKit",
            dependencies: [
                .product(name: "Yams", package: "Yams"),
                .product(name: "DesignAlgorithmsKit", package: "DesignAlgorithmsKit"),
            ]
        ),
        .testTarget(
            name: "InventoryKitTests",
            dependencies: ["InventoryKit"]
        ),
    ]
)
