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
                tool: context.tool(named: swift),
                pluginWorkDirectory: context.pluginWorkDirectoryURL,
                files: (target.sourceModule?.sourceFiles.map(\.url) ?? [])
                    + [context.package.directoryURL.appending(path: "Package.swift")]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension LintBuildPlugin: XcodeBuildToolPlugin {
    /// Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            try lint(
                tool: context.tool(named: swift),
                pluginWorkDirectory: context.pluginWorkDirectoryURL,
                files: target.inputFiles.map(\.url)
            )
        ]
    }
}

#endif

private extension LintBuildPlugin {
    func lint(
        tool: PluginContext.Tool,
        pluginWorkDirectory: URL,
        files: [URL]
    ) throws -> Command {
        let executable = tool.url
        let swiftFiles = files.filter { $0.pathExtension == "swift" }

        let arguments = [
            "format",
            "lint",
            "--parallel"
        ] + swiftFiles.map { $0.path(percentEncoded: false) }

        let displayName = "Linting the source code: \(executable.relativePath) \(arguments.joined(separator: " "))"
        return .buildCommand(
            displayName: displayName,
            executable: executable,
            arguments: arguments,
            inputFiles: swiftFiles,
            outputFiles: [try recordStamp(pluginWorkDirectory: pluginWorkDirectory)]
        )
    }

    /// Create a stamp file for "outputFiles" as a hack so we only run when input files are edited.
    ///
    /// This is a hack because we need to declare both input and output files to only run when input files change.
    private func recordStamp(pluginWorkDirectory: URL) throws -> URL {
        let stamp = pluginWorkDirectory.appending(path: "lint.stamp")
        try Data().write(to: stamp)
        return stamp
    }
}
