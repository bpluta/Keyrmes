//
//  SourceFileBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct SourceFileBuilder {
    let preamble: [String]
    let caseDeclarations: [CaseDeclaration]
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> SourceFileSyntax {
        SourceFileSyntax(
            statements: [
                CodeBlockItemSyntax(item: .decl(DeclSyntax(
                    ImportBuilder(
                        leadingTrivia: comment(preamble).merging(.newlines(2)),
                        moduleName: "Foundation",
                        trailingTrivia: .newlines(2)
                    ).build()
                ))),
                CodeBlockItemSyntax(item: .decl(DeclSyntax(
                    EnumBuilder(
                        name: "KeychainQueryKey",
                        inheritedTypes: [
                            "KeychainQueryKeyEncodable",
                            "Sendable"
                        ],
                        caseDeclarations: caseDeclarations,
                        supportedPlatforms: supportedPlatforms
                    ).build()
                ))),
            ]
        )
    }
    
    func comment(_ commentLines: [String]) -> Trivia {
        commentLines.map { line in
            Trivia.lineComment("// \(line)")
        }.reduce(into: Trivia.spaces(0), { result, item in
            result += item.merging(.newline)
        })
    }
}
