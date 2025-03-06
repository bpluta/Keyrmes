//
//  SecItemHeaderRequest.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct SecItemHeaderRequest: SourceKitRequest {
    let context: ProcessContext
    let yamlTemplate: String
    let requestIdentifier: UUID
    
    init(context: ProcessContext) throws {
        logger.trace("Getting an YAML request template resource URL")
        guard let resourceRequestURL = Bundle.module.url(forResource: "SourceKitRequest", withExtension: "yml")  else {
            logger.error("YAML request template resource has not been found")
            throw RequestError.missingResource
        }
        guard let fileContent = try? Data(contentsOf: resourceRequestURL),
              let yamlContent = String(data: fileContent, encoding: .utf8)
        else {
            logger.error("Failed to read the YAML requet template file")
            throw RequestError.failedToReadFile
        }
        logger.trace("YAML request template content has been successfully loaded")
        
        self.context = context
        self.yamlTemplate = yamlContent
        self.requestIdentifier = UUID()
        
        logger.trace("Initialized base request successfully")
    }
    
    private var requestName: String {
        requestIdentifier.uuidString
    }
    
    private var llvmTargetTriple: String {
        get throws {
            try context.llvmTargetTriple
        }
    }
    
    private var sdkPath: String {
        get throws {
            guard let sdkPath = context.sdkDirectory else {
                throw RequestError.couldNotFindSdkDirectory
            }
            return sdkPath
        }
    }
    
    private var importSearchPath: String {
        get throws {
            try URL(fileURLWithPath: sdkPath)
                .appending(components: "usr/local/include")
                .path(percentEncoded: false)
        }
    }
    
    private var frameworkSearchPath: String {
        get throws {
            try URL(fileURLWithPath: sdkPath)
                .appending(components: "System/Library/PrivateFrameworks")
                .path(percentEncoded: false)
        }
    }
    
    func yamlString() throws -> String {
        logger.trace("Building YAML request from the template")
        let yamlString = try yamlTemplate
            .replacing(placeholder: .requestName, with: requestName)
            .replacing(placeholder: .llvmTargetTriple, with: llvmTargetTriple)
            .replacing(placeholder: .sdkPath, with: sdkPath)
            .replacing(placeholder: .importSearchPath, with: importSearchPath)
            .replacing(placeholder: .frameworkSearchPath, with: frameworkSearchPath)
        logger.trace("YAML request has been built successfully:\n\n\(yamlString, privacy: .public)")
        return yamlString
    }
}

fileprivate extension String {
    func replacing(placeholder: SecItemHeaderRequest.TemplatePlaceholderKey, with value: String) -> String {
        replacingOccurrences(of: "$\(placeholder.rawValue)", with: value)
    }
}

extension SecItemHeaderRequest {
    enum RequestError: Error {
        case missingResource
        case failedToReadFile
        case couldNotFindTargetArchitectureName
        case couldNotFindTargetVendorName
        case couldNotFindTargetOsVersion
        case couldNotFindSdkDirectory
    }
    
    enum TemplatePlaceholderKey: String {
        case requestName = "REQUEST_NAME"
        case llvmTargetTriple = "LLVM_TARGET_TRIPLE"
        case sdkPath = "SDK_PATH"
        case importSearchPath = "IMPORT_SEARCH_PATH"
        case frameworkSearchPath = "FRAMEWORK_SEARCH_PATH"
    }
}
