// Copyright © 2023 Brent Tunnicliff <btunnicliff.dev@gmail.com>

import Foundation
import PackagePlugin

@main
struct lint: BuildToolPlugin {
    private let swiftFormat = "swift-format"

    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            try lint(
                targetDirectory: target.directory,
                tool: try context.tool(named: swiftFormat)
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension lint: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            try lint(
                targetDirectory: context.xcodeProject.directory,
                tool: try context.tool(named: swiftFormat)
            )
        ]
    }
}

#endif

private extension lint {
    func lint(targetDirectory: Path, tool: PluginContext.Tool) throws -> Command {
        let executable = tool.path
        let arguments = [
            "lint",
            targetDirectory.string,
            "--recursive",
            "--parallel"
        ]

        let displayName = "Linting the source code: \(executable) \(arguments.joined(separator: " "))"
        return .buildCommand(displayName: displayName, executable: executable, arguments: arguments)
    }
}
