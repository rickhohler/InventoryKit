// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InventoryKit",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "InventoryCore",
            targets: ["InventoryCore"]
        ),
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
            name: "InventoryCore",
            dependencies: []
        ),
        .target(
            name: "InventoryKit",
            dependencies: [
                "InventoryCore",
                .product(name: "Yams", package: "Yams"),
                .product(name: "DesignAlgorithmsKit", package: "DesignAlgorithmsKit"),
            ]
        ),
        .testTarget(
            name: "InventoryKitTests",
            dependencies: ["InventoryKit", "InventoryCore"]
        ),
    ]
)
