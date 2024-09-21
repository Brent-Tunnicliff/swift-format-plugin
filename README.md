# swift-format-plugin

Xcode build plugin for the swift-format package.

Currently only supports linting.

## How to use

Add the package via SRM, then add the `lint` plugin to the targets you want to apply lint to at build time.

```swift
let package = Package(
    name: "app",
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "2.0.0")) // <- Add dependency
    ],
    targets: [
        .target(
            name: "App",
            plugins: [
                .plugin(name: "LintBuildPlugin", package: "swift-format-plugin") // <- Add to target
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"],
            plugins: [
                .plugin(name: "LintBuildPlugin", package: "swift-format-plugin") // <- Add to test target
            ]
        ),
    ]
)
```
