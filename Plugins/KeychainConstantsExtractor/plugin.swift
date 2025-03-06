//
//  plugin.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import PackagePlugin
import Foundation

@main
struct KeychainConstantsExtractor: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: any PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        let outputFile = context.pluginWorkDirectoryURL.appending(path: "KeychainQueryKey.swift")
        let outputPath = outputFile.path(percentEncoded: false)
        return [
            .buildCommand(
                displayName: "Generating keychain key constants enum declaration",
                executable: try context.tool(named: "KeychainKeysBuilder").url,
                arguments: [outputPath],
                inputFiles: [],
                outputFiles: [outputFile]
            )
        ]
    }
}
