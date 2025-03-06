//
//  AllCasesDeclarationBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct AllCasesDeclarationBuilder {
    let leadingTrivia: Trivia
    let cases: [CaseDeclaration]
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> VariableDeclSyntax {
        let accessorStatements = SystemVersionAvailabilityExpressionBuilder(
            leadingTrivia: .tabs(1).appending(leadingTrivia),
            cases: cases,
            supportedPlatforms: supportedPlatforms
        ) { platformSettings in
            let arrayExpression = AllCasesArrayExpressionBuilder(
                platformSettings: platformSettings,
                cases: cases
            ).build()
            let returnStatement = ReturnStmtSyntax(
                leadingTrivia: .tabs(3).appending(leadingTrivia),
                returnKeyword: .keyword(.return, trailingTrivia: .space),
                expression: arrayExpression
            )
            return [
                CodeBlockItemSyntax(
                    item: CodeBlockItemSyntax.Item(returnStatement)
                )
            ]
        }.build()
        return VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public, trailingTrivia: .space)),
                DeclModifierSyntax(name: .keyword(.static, trailingTrivia: .space))
            ],
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    leadingTrivia: .space,
                    pattern: IdentifierPatternSyntax(identifier: .identifier("allCases")),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(trailingTrivia: .space),
                        type: ArrayTypeSyntax(
                            leftSquare: .leftSquareToken(),
                            element: IdentifierTypeSyntax(name: .keyword(.Self)),
                            rightSquare: .rightSquareToken()
                    )),
                    accessorBlock: AccessorBlockSyntax(
                        leftBrace: .leftBraceToken(
                            leadingTrivia: .space, trailingTrivia: .newline
                        ),
                        accessors: .getter([
                            CodeBlockItemListSyntax.Element(
                                item: .decl(DeclSyntax(accessorStatements))
                            )
                        ]),
                        rightBrace: .rightBraceToken(
                            leadingTrivia: .newline.appending(leadingTrivia),
                            trailingTrivia: .newline
                        )
                    )
                )
            ],
            trailingTrivia: .newline
        )
    }
}
