// Copyright © 2023 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import PackagePlugin

@main
struct LintBuildPlugin: BuildToolPlugin {
    private let swift = "swift"

    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let tool = try context.tool(named: swift)
        return [
            lint(url: target.directoryURL, tool: tool),
            lint(url: context.package.directoryURL.appending(path: "Package.swift"), tool: tool),
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LintBuildPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [try lint(url: context.xcodeProject.directoryURL, tool: context.tool(named: swift))]
    }
}

#endif

private extension LintBuildPlugin {
    func lint(url: URL, tool: PluginContext.Tool) -> Command {
        let executable = tool.url
        let arguments = [
            "format",
            "lint",
            url.relativePath,
            "--recursive",
            "--parallel"
        ]

        let displayName = "Linting the source code: \(executable.relativePath) \(arguments.joined(separator: " "))"
        return .buildCommand(displayName: displayName, executable: executable, arguments: arguments)
    }
}
