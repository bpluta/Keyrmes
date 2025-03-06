//
//  KeychainValueDeclarationBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct KeychainValueDeclarationBuilder {
    let leadingTrivia: Trivia
    let cases: [CaseDeclaration]
    
    func build() -> VariableDeclSyntax {
        VariableDeclSyntax(
            leadingTrivia: leadingTrivia,
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public, trailingTrivia: .space))
            ],
            bindingSpecifier: .keyword(.var, trailingTrivia: .space),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("keychainValue")),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(trailingTrivia: .space),
                        type: IdentifierTypeSyntax(name: .identifier("String"))
                    ),
                    accessorBlock: AccessorBlockSyntax(
                        leftBrace: .leftBraceToken(leadingTrivia: .space, trailingTrivia: .newline),
                        accessors: .getter(CodeBlockItemListSyntax(retrieveFromLookupTable())),
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
    
    private func retrieveFromLookupTable() -> [CodeBlockItemSyntax] {[
        CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(
            AsExprSyntax(
                expression: ForceUnwrapExprSyntax(
                    leadingTrivia: .tabs(1).appending(leadingTrivia),
                    expression: SubscriptCallExprSyntax(
                        calledExpression: MemberAccessExprSyntax(
                            base: DeclReferenceExprSyntax(baseName: .keyword(.Self)),
                            period: .periodToken(),
                            declName: DeclReferenceExprSyntax(baseName: .identifier("keychainConstantLookupTable"))
                        ),
                        leftSquare: .leftSquareToken(),
                        arguments: [
                            LabeledExprSyntax(expression: DeclReferenceExprSyntax(baseName: .keyword(.self)))
                        ],
                        rightSquare: .rightSquareToken()
                    ),
                    exclamationMark: .exclamationMarkToken()
                ),
                asKeyword: .keyword(.as, leadingTrivia: .space, trailingTrivia: .space),
                type: IdentifierTypeSyntax(name: .identifier("String"))
            )
        ))
    ]}
}
