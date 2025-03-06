//
//  ProcessContext.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct ProcessContext {
    // Arguments
    let outputArgument: String?
    
    // Environment
    let xcodeDefaultToolchainOverride: String?
    let toolchainDirectory: String?
    let sdkDirectory: String?
    let nativeArch: String?
    let llvmTargetTripleVendor: String?
    let llvmTargetTripleOsVersion: String?
    let llvmTargetTripleSuffix: String?
    let platformFamilyName: String?
    
    nonisolated(unsafe) static var shared = {
        let processContext = Self(processInfo: ProcessInfo.processInfo)
        logger.trace("Process context:\n\n\(processContext.logDescription, privacy: .public)")
        return processContext
    }()
    
    private init(processInfo: ProcessInfo) {
        outputArgument = processInfo.arguments[ifPresent: 1]
        
        xcodeDefaultToolchainOverride = processInfo.environmentValue(for: .xcodeDefaultToolchainOverride)
        toolchainDirectory = processInfo.environmentValue(for: .toolchainDirectory)
        sdkDirectory = processInfo.environmentValue(for: .sdkDirectory)
        nativeArch = processInfo.environmentValue(for: .nativeArch)
        llvmTargetTripleVendor = processInfo.environmentValue(for: .llvmTargetTripleVendor)
        llvmTargetTripleOsVersion = processInfo.environmentValue(for: .llvmTargetTripleOsVersion)
        llvmTargetTripleSuffix = processInfo.environmentValue(for: .llvmTargetTripleSuffix)
        platformFamilyName = processInfo.environmentValue(for: .platformFamilyName)
    }
}

extension ProcessContext: Codable {
    public var logDescription: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let encodedObject = try? encoder.encode(self),
              let jsonString = String(data: encodedObject, encoding: .utf8)
        else {
            return "(Failed to create log description)"
        }
        return jsonString
    }
}

extension ProcessContext {
    var outputFileURL: URL {
        get throws {
            guard let outputArgument else {
                throw EnvironmentError.missingOutputFilePath
            }
            return URL(fileURLWithPath: outputArgument)
        }
    }
    
    var platform: Platform {
        get throws {
            guard let platformFamilyName else {
                throw EnvironmentError.missingPlatform
            }
            guard let platform = Platform(rawValue: platformFamilyName) else {
                throw EnvironmentError.unknownPlatform(platformFamilyName)
            }
            return platform
        }
    }
    
    var llvmTargetTriple: String {
        get throws {
            guard let arch = nativeArch else {
                throw EnvironmentError.missingTargetArchitectureName
            }
            guard let vendor = llvmTargetTripleVendor else {
                throw EnvironmentError.missingTargetVendorName
            }
            guard let osVersion = llvmTargetTripleOsVersion else {
                throw EnvironmentError.missingTargetOsVersion
            }
            let targetTriple = [arch, vendor, osVersion].joined(separator: "-")
            guard let suffix = llvmTargetTripleSuffix else {
                return targetTriple
            }
            return targetTriple.appending(suffix)
        }
    }
    
    var sdkName: String {
        get throws {
            guard let sdkDirectory else {
                throw EnvironmentError.missingSDK
            }
            let url = URL(fileURLWithPath: sdkDirectory)
            return url.lastPathComponent
        }
    }
}

extension ProcessContext {
    enum EnvironmentError: Error {
        case missingOutputFilePath
        case missingPlatform
        case missingSDK
        case missingTargetArchitectureName
        case missingTargetVendorName
        case missingTargetOsVersion
        case unknownPlatform(String)
    }
}
