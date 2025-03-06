//
//  KeychainKeysBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import os
import Foundation

let logger = Logger(subsystem: "com.Keyrmes.KeychainKeysBuilder", category: "general")

@main
struct KeychainKeysBuilder {
    static func main() throws {
        let context = ProcessContext.shared
        
        let platform = try context.platform
        let outputFile = try? context.outputFileURL
        
        let headerExtractor = SecItemHeaderExtractor(context: context)
        let headerSourceCode = try headerExtractor.extractHeaderCode()
        
        let extractor = SourceOutputGenerator(platform: platform, context: context)
        try extractor.run(sourceCode: headerSourceCode, outputFile: outputFile)
    }
}
