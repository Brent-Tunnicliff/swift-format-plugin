// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2023 Brent Tunnicliff <brent@tunnicliff.dev>

import PackageDescription

let package = Package(
    name: "swift-format-plugin",
    platforms: [.macOS(.v10_15),],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "lint",
            targets: ["lint"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", .upToNextMajor(from: "509.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "lint",
            capability: .buildTool(),
            dependencies: [
                .product(name: "swift-format", package: "swift-format")
            ]
        ),
    ]
)
