# swift-format-plugin

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBrent-Tunnicliff%2Fswift-format-plugin%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Brent-Tunnicliff/swift-format-plugin)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBrent-Tunnicliff%2Fswift-format-plugin%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Brent-Tunnicliff/swift-format-plugin)
[![Pipeline](https://github.com/Brent-Tunnicliff/swift-format-plugin/actions/workflows/pipeline.yml/badge.svg)](https://github.com/Brent-Tunnicliff/swift-format-plugin/actions/workflows/pipeline.yml)
[![](https://img.shields.io/github/license/Brent-Tunnicliff/swift-format-plugin)](https://github.com/Brent-Tunnicliff/swift-format-plugin/blob/main/LICENSE)

Swift build plugin for the [swift format](https://github.com/swiftlang/swift-format) tool which is bundled with Swift from 6.0 onwards.

Currently only supports linting during build via `LintBuildPlugin`.

This is the same as running the `swift format lint` command.

## How to use

Add the `LintBuildPlugin` plugin to the targets you want to apply lint to at build time.

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", from: "2.0.0") // <- Add dependency
    ],
    targets: [
        .target(
            name: "Example",
            plugins: [
                .plugin(name: "LintBuildPlugin", package: "swift-format-plugin") // <- Add to target
            ]
        ),
    ]
)
```

`LintBuildPlugin` attempts to use the target swift files as inputs and a empty stamp file as output in an attempt to only run if swift files have changed since last run.   

## Source Stability

The versioning of this package follows [Semantic Versioning](https://semver.org/). Source breaking changes to public API require a new major version.

We'd like this package to quickly embrace Swift language and toolchain improvements, and expect the latest Swift toolchains to be used (i.e. latest public Xcode version). So we will include updating the Swift version of the package as a new minor version bump.

## Disclaimer

I only ever pretend to know what I am doing. If you find something wrong please raise an issue to let me know.
