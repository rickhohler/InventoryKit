// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InventoryKit",
    products: [
        .library(
            name: "InventoryKit",
            targets: ["InventoryKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.2")
    ],
    targets: [
        .target(
            name: "InventoryKit",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ]
        ),
        .testTarget(
            name: "InventoryKitTests",
            dependencies: ["InventoryKit"]
        ),
    ]
)
