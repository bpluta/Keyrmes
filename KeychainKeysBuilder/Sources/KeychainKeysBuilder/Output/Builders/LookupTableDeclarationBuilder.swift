//
//  LookupTableDeclarationBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct LookupTableDeclarationBuilder {
    let leadingTrivia: Trivia
    let cases: [CaseDeclaration]
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> VariableDeclSyntax {
        let accessorStatements = SystemVersionAvailabilityExpressionBuilder(
            leadingTrivia: .tabs(1).appending(leadingTrivia),
            cases: cases,
            supportedPlatforms: supportedPlatforms
        ) { platformSettings in
            let dictionaryExpression = AllCasesLookUpDictonaryExpressionBuilder(
                leadingTrivia: .tabs(2).appending(leadingTrivia),
                platformSettings: platformSettings,
                cases: cases
            ).build()
            let returnStatement = ReturnStmtSyntax(
                leadingTrivia: .tabs(3).appending(leadingTrivia),
                returnKeyword: .keyword(.return, trailingTrivia: .space),
                expression: dictionaryExpression
            )
            return [
                CodeBlockItemSyntax(
                    item: CodeBlockItemSyntax.Item(returnStatement)
                )
            ]
        }.build()
        return VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: DeclModifierListSyntax([
                DeclModifierSyntax(
                    name: .keyword(.nonisolated),
                    detail: DeclModifierDetailSyntax(
                        leftParen: .leftParenToken(),
                        detail: .keyword(.unsafe),
                        rightParen: .rightParenToken()
                    ),
                    trailingTrivia: .space
                ),
                DeclModifierSyntax(name: .keyword(.private), trailingTrivia: .space),
                DeclModifierSyntax(name: .keyword(.static), trailingTrivia: .space),
            ]),
            bindingSpecifier: .keyword(.let),
            bindings: [
                PatternBindingSyntax(
                    leadingTrivia: .space,
                    pattern: IdentifierPatternSyntax(identifier: .identifier("keychainConstantLookupTable")),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(),
                        type: DictionaryTypeSyntax(
                            leadingTrivia: .space,
                            leftSquare: .leftSquareToken(),
                            key: IdentifierTypeSyntax(name: .keyword(.Self)),
                            colon: .colonToken(trailingTrivia: .space),
                            value: IdentifierTypeSyntax(name: .identifier("CFString")),
                            rightSquare: .rightSquareToken(),
                            trailingTrivia: .space
                        )
                    ),
                    initializer: InitializerClauseSyntax(
                        equal: .equalToken(),
                        value: FunctionCallExprSyntax(
                            calledExpression: ClosureExprSyntax(
                                leadingTrivia: .space,
                                leftBrace: .leftBraceToken(trailingTrivia: .newline),
                                statements: [
                                    CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(accessorStatements)
                                   )
                                ],
                                rightBrace: .rightBraceToken(
                                    leadingTrivia: .newline.merging(leadingTrivia)
                                )
                            ),
                            leftParen: .leftParenToken(),
                            arguments: [],
                            rightParen: .rightParenToken(),
                            trailingTrivia: .newline
                        )
                    )
                )
            ],
            trailingTrivia: .newline
        )
    }
}
