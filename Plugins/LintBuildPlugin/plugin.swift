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
                targetDirectory: target.targetDirectory,
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

extension LintBuildPlugin {
    enum RunError: Error {
        case unableToGetTargetDirectory(String)
    }
}

extension LintBuildPlugin.RunError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .unableToGetTargetDirectory(type):
            "Unable to get target directory for type \(type)"
        }
    }
}

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

private extension Target {
    // Swift 6.1 gives us a much nicer solution, so we will switch to that when we can.
    @available(_PackageDescription, deprecated: 6.1, renamed: "directoryURL")
    var targetDirectory: URL {
        get throws {
            guard let directoryURL = knownTargetDirectory else {
                throw LintBuildPlugin.RunError.unableToGetTargetDirectory("\(self.self)")
            }

            return directoryURL
        }
    }

    private var knownTargetDirectory: URL? {
        switch self {
        case let target as BinaryArtifactTarget: target.directoryURL
        case let target as SystemLibraryTarget: target.directoryURL
        case let target as SwiftSourceModuleTarget: target.directoryURL
        case let target as ClangSourceModuleTarget: target.directoryURL
        default: nil
        }
    }
}
