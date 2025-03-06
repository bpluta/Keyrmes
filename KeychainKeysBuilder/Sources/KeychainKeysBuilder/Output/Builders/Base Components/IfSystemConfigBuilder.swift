//
//  IfSystemConfigBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct IfSystemConfigBuilder {
    let leadingTrivia: Trivia
    let uniquePlatforms: [Platform]
    let elementsProvider: (Platform) -> CodeBlockItemListSyntax
    
    init(leadingTrivia: Trivia, uniquePlatforms: [Platform], elementsProvider: @escaping (Platform) -> CodeBlockItemListSyntax) {
        self.leadingTrivia = leadingTrivia
        self.uniquePlatforms = uniquePlatforms
        self.elementsProvider = elementsProvider
    }
    
    func build() -> IfConfigDeclSyntax {
        IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax(ifConfigClauses),
            poundEndif: .poundEndifToken(
                leadingTrivia: .newline.appending(leadingTrivia)
            )
        )
    }
    
    private var ifConfigClauses: [IfConfigClauseSyntax] {
        uniquePlatforms
            .compactMap { platform in
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseifToken(leadingTrivia: .newline.appending(leadingTrivia)),
                    condition: FunctionCallExprSyntax(
                        leadingTrivia: .space,
                        calledExpression: DeclReferenceExprSyntax(
                            baseName: .identifier("os")
                        ),
                        leftParen: .leftParenToken(),
                        arguments: [
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(
                                baseName: .identifier(platform.rawValue))
                            )
                        ],
                        rightParen: .rightParenToken(),
                        trailingTrivia: .newline
                    ),
                    elements: .statements(elementsProvider(platform))
                )
            }.mapFirst { firstItem in
                var firstItem = firstItem
                firstItem.poundKeyword = .poundIfToken(leadingTrivia: leadingTrivia)
                return firstItem
            }
    }
}
