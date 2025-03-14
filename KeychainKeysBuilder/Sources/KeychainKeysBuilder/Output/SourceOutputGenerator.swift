//
//  SourceOutputGenerator.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import SwiftSyntax

struct SourceOutputGenerator {
    let platform: Platform
    let context: ProcessContext
    
    func run(sourceCode: String, outputFile: URL?) throws {
        let caseDeclarations = getEnumCases(from: sourceCode)
        let processedSourceCode = buildProcessedSourceCode(from: caseDeclarations)
        try writeIfNeeded(source: processedSourceCode, to: outputFile)
    }
    
    private func getEnumCases(from sourceCode: String) -> [CaseDeclaration] {
        logger.trace("Extracting enum cases from the source code")
        let sourceExtractor = SourceExtractor(
            sourceCode: sourceCode,
            platform: platform
        )
        let extractors = sourceExtractor.variableDeclarations
            .reduce(into: [String: CaseDeclaration](), { result, declaration in
                guard let caseDeclaration = CaseDeclaration(from: declaration) else { return }
                if let currentValue = result[caseDeclaration.caseIdentifier] {
                    result[caseDeclaration.caseIdentifier] = currentValue.merging(with: caseDeclaration)
                } else {
                    result[caseDeclaration.caseIdentifier] = caseDeclaration
                }
            })
        let sortedKeys = Array(extractors.keys).sorted()
        let caseDeclarations = sortedKeys.compactMap { key in
            extractors[key]
        }
        logger.trace("Extracted \(caseDeclarations.count, privacy: .public) enum cases")
        return caseDeclarations
    }
    
    private func buildProcessedSourceCode(from caseDeclarations: [CaseDeclaration]) -> SourceFileSyntax {
        logger.trace("Generating output source code")
        let targetTriple = try? context.llvmTargetTriple
        let sdkName = try? context.sdkName
        let newSourceBuilder = SourceFileBuilder(
            preamble: [
                "",
                "The contents of this file are generated by KeychainKeysBuilder tool",
                "via build command plugin and are not intended to be modified directly.",
                "The source code is derived from processing SecItem.h header file",
                "from Security.framework of the target platform and SDK.",
                "",
                "Target triple:\t\(targetTriple ?? "Unknown")",
                "Source SDK:\t\t\(sdkName ?? "Unknown")",
                "Creation date:\t\(Date.now.formatted(date: .abbreviated, time: .shortened))",
                "",
            ],
            caseDeclarations: caseDeclarations,
            supportedPlatforms: [
                PlatformAvailability(platform: platform)
            ]
        )
        let newSource = newSourceBuilder.build()
        logger.trace("Source code has been generated successfully:\n\n\(newSource, privacy: .public)")
        return newSource
    }
    
    private func writeIfNeeded(source: SourceFileSyntax, to outputURL: URL?) throws {
        guard let outputURL else {
            logger.trace("No output URL provided. Skipping writing the generated source code into a file")
            return
        }
        guard let data = source.description.data(using: .utf8) else {
            logger.error("Failed to produce UTF-8 data from the source code. Skipping writing the generated source code into a file")
            return
        }
        logger.trace("Writing the generated source code into a file:\n\(outputURL, privacy: .public)")
        try data.write(to: outputURL, options: .atomic)
        logger.trace("Source code has been written into a file successfully.")
    }
}
