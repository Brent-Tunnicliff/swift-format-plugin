# swift-format-plugin

Xcode build plugin for the swift format tool.

Currently only supports linting via the `LintBuildPlugin` plugin.

This is the same as running the`swift format lint` command.

## How to use

Add the `LintBuildPlugin` plugin to the targets you want to apply lint to at build time.

```swift
let package = Package(
    // ...
    dependencies: [
        .package(url: "https://github.com/Brent-Tunnicliff/swift-format-plugin", .upToNextMajor(from: "2.0.0")) // <- Add dependency
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
