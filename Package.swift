// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InventoryKit",
    defaultLocalization: "en",
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
        .package(path: "../DesignAlgorithmsKit"),
    ],
    targets: [
        .target(
            name: "InventoryCore",
            dependencies: [
                .product(name: "DesignAlgorithmsKit", package: "DesignAlgorithmsKit"),
            ]
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
        .testTarget(
            name: "InventoryCoreTests",
            dependencies: ["InventoryCore"]
        ),
    ]
)
