//
//  SecItemHeaderExtractor.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct SecItemHeaderExtractor {
    let context: ProcessContext
    let sourceKitClient: SourceKitClient
    
    init(context: ProcessContext, client: SourceKitClient = SourceKitClient()) {
        self.context = context
        self.sourceKitClient = client
    }
    
    func extractHeaderCode() throws -> String {
        let request = try SecItemHeaderRequest(context: context)
        let yamlRequest = try request.yamlString()
        let response = try sourceKitClient.send(yaml: yamlRequest)
        let sourceCode = try extractSourceCode(from: response)
        return sourceCode
    }
    
    private func extractSourceCode(from response: SourceKitResponseValue) throws -> String {
        logger.trace("Handling parsed response as a dictionary")
        guard case .dictionary(let dictionary) = response else {
            logger.error("Response format is not a dictionary")
            throw SourceResponseError.wrongResponseFormat
        }
        logger.trace("Extracting source code from the response dictionary")
        guard case .string(let sourceCode) = dictionary["key.sourcetext"] else {
            logger.error("Missing source code in the response dictionary")
            throw SourceResponseError.missingSourceCode
        }
        logger.trace("Source code has been extracted successfully:\n\n\(sourceCode, privacy: .public)")
        return sourceCode
    }
}

extension SecItemHeaderExtractor {
    enum SourceResponseError: Error {
        case wrongResponseFormat
        case missingSourceCode
        case requestDump(String)
    }
}
