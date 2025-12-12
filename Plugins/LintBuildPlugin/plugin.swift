// Copyright © 2023 Brent Tunnicliff <brent@tunnicliff.dev>

import Foundation
import PackagePlugin

@main
struct LintBuildPlugin: BuildToolPlugin {
    private let swift = "swift"

    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            try lint(
                targetDirectory: target.directoryURL,
                tool: context.tool(named: swift)
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LintBuildPlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            try lint(
                targetDirectory: context.xcodeProject.directoryURL,
                tool: context.tool(named: swift)
            )
        ]
    }
}

#endif

private extension LintBuildPlugin {
    func lint(targetDirectory: URL, tool: PluginContext.Tool) -> Command {
        let executable = tool.url
        let arguments = [
            "format",
            "lint",
            targetDirectory.relativePath,
            "--recursive",
            "--parallel"
        ]

        let displayName = "Linting the source code: \(executable.relativePath) \(arguments.joined(separator: " "))"
        return .buildCommand(displayName: displayName, executable: executable, arguments: arguments)
    }
}
