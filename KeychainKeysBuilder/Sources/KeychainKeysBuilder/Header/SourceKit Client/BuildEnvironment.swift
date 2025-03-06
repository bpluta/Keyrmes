//
//  BuildEnvironment.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct BuildEnvironment {
    let context: ProcessContext
    
    var sdkDirectory: URL? {
        url(filePath: context.sdkDirectory)
    }
    
    var xcodeDefaultToolachainOverrideDirectory: URL? {
        url(filePath: context.xcodeDefaultToolchainOverride)
    }
    
    var toolchainDirectory: URL? {
        url(filePath: context.toolchainDirectory)
    }
    
    var systemXcodeDeveloperDirectory: URL? {
        applicationDirectory(with: .systemDomainMask)?
            .appending(component: "Xcode.app/Contents/Developer")
    }
    
    var systemXcodeBetaDeveloperDirectory: URL? {
        applicationDirectory(with: .systemDomainMask)?
            .appending(component: "Xcode.app/Contents/Developer")
    }
    
    var userXcodeDeveloperDirectory: URL? {
        applicationDirectory(with: .userDomainMask)?
            .appending(component: "Xcode-beta.app/Contents/Developer")
    }
    
    var userXcodeBetaDeveloperDirectory: URL? {
        applicationDirectory(with: .userDomainMask)?
            .appending(component: "Xcode-beta.app/Contents/Developer")
    }
    
    var systemXcodeDeveloperToolchainDirectory: URL? {
        systemXcodeDeveloperDirectory?
            .appending(component: "Toolchains/XcodeDefault.xctoolchain")
    }
    
    var systemXcodeBetaDeveloperToolchainDirectory: URL? {
        systemXcodeBetaDeveloperDirectory?
            .appending(component: "Toolchains/XcodeDefault.xctoolchain")
    }
    
    var userXcodeDeveloperToolchainDirectory: URL? {
        userXcodeDeveloperDirectory?
            .appending(component: "Toolchains/XcodeDefault.xctoolchain")
    }
    
    var userXcodeBetaDeveloperToolchainDirectory: URL? {
        userXcodeBetaDeveloperDirectory?
            .appending(component: "Toolchains/XcodeDefault.xctoolchain")
    }
    
    var xcrunToolchainDirectory: URL? {
        let pathOfXcrun = "/usr/bin/xcrun"
        guard FileManager.default.isExecutableFile(atPath: pathOfXcrun),
              let output = try? ProcessExecutor.execute(pathOfXcrun, "-find", "swift")
        else { return nil }
        
        var toolchainURL = URL(fileURLWithPath: output)
        let expectedSwiftToolchainSuffix = ["usr", "bin", "swift"]
        let toolchainSuffixComponents = Array(toolchainURL.pathComponents.suffix(expectedSwiftToolchainSuffix.count))
        
        guard toolchainSuffixComponents == expectedSwiftToolchainSuffix else {
            return nil
        }
        for _ in expectedSwiftToolchainSuffix {
            toolchainURL.deleteLastPathComponent()
        }
        let commandLineToolsComponents = ["Library", "Developer", "CommandLineTools"]
        guard toolchainURL.pathComponents != commandLineToolsComponents else {
            return nil
        }
        return toolchainURL
    }
}

extension BuildEnvironment {
    private func url(filePath: String?) -> URL? {
        guard let filePath else { return nil }
        return URL(filePath: filePath)
    }
    
    private func applicationDirectory(with mask: FileManager.SearchPathDomainMask) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.applicationDirectory, mask, true).first else { return nil }
        return URL(filePath: path)
    }
}
