// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Copyright © 2023 Brent Tunnicliff <brent@tunnicliff.dev>

import PackageDescription

let package = Package(
    name: "swift-format-plugin",
    platforms: [.macOS(.v12),],
    products: [
        .plugin(
            name: "LintBuildPlugin",
            targets: ["LintBuildPlugin"]
        ),
    ],
    targets: [
        .plugin(
            name: "LintBuildPlugin",
            capability: .buildTool(),
            path: "Plugins/LintBuildPlugin"
        ),
    ]
)
