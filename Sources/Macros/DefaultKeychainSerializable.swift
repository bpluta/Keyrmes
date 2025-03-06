//
//  DefaultKeychainSerializable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

package enum DefaultKeychainSerializable: MemberMacro {
    
    static package func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        return [
            DeclSyntax(encodeFunction),
            DeclSyntax(decodeFunction)
        ]
    }
    
    private static var encodeFunction: FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public)),
                DeclModifierSyntax(name: .keyword(.static))
            ],
            funcKeyword: .keyword(.func),
            name: .identifier("encode"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    parameters: [
                        FunctionParameterSyntax(
                            firstName: .identifier("value"),
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(name: .keyword(.Self)),
                            trailingComma: .commaToken()
                        ),
                        FunctionParameterSyntax(
                            firstName: .identifier("using"),
                            secondName: .identifier("serializer"),
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(name: .identifier("KeychainSerializer"))
                        )
                    ],
                    rightParen: .rightParenToken()
                ),
                effectSpecifiers: FunctionEffectSpecifiersSyntax(
                    throwsClause: ThrowsClauseSyntax(
                        throwsSpecifier: .keyword(.throws),
                        leftParen: .leftParenToken(),
                        type: IdentifierTypeSyntax(name: .identifier("KeychainSerializerError")),
                        rightParen: .rightParenToken()
                    )
                ),
                returnClause: ReturnClauseSyntax(
                    arrow: .arrowToken(),
                    type: IdentifierTypeSyntax(name: .identifier("Data"))
                )
            ),
            body: CodeBlockSyntax(
                leftBrace: .leftBraceToken(),
                statements: [
                    CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(
                        TryExprSyntax(
                            tryKeyword: .keyword(.try),
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(
                                        baseName: .identifier("serializer")
                                    ),
                                    period: .periodToken(),
                                    name: .identifier("encode")
                                ),
                                leftParen: .leftParenToken(),
                                arguments: [
                                    LabeledExprSyntax(
                                        expression: DeclReferenceExprSyntax(
                                            baseName: .identifier("value")
                                        )
                                    )
                                ],
                                rightParen: .rightParenToken()
                            )
                        )
                    ))
                ],
                rightBrace: .rightBraceToken()
            )
        )
    }
    
    private static var decodeFunction: FunctionDeclSyntax {
        FunctionDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public)),
                DeclModifierSyntax(name: .keyword(.static))
            ],
            funcKeyword: .keyword(.func),
            name: .identifier("decode"),
            signature: FunctionSignatureSyntax(
                parameterClause: FunctionParameterClauseSyntax(
                    leftParen: .leftParenToken(),
                    parameters: [
                        FunctionParameterSyntax(
                            firstName: .identifier("value"),
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(name: .identifier("Data")),
                            trailingComma: .commaToken()
                        ),
                        FunctionParameterSyntax(
                            firstName: .identifier("using"),
                            secondName: .identifier("serializer"),
                            colon: .colonToken(),
                            type: IdentifierTypeSyntax(name: .identifier("KeychainSerializer"))
                        )
                    ],
                    rightParen: .rightParenToken()
                ),
                effectSpecifiers: FunctionEffectSpecifiersSyntax(
                    throwsClause: ThrowsClauseSyntax(
                        throwsSpecifier: .keyword(.throws),
                        leftParen: .leftParenToken(),
                        type: IdentifierTypeSyntax(name: .identifier("KeychainSerializerError")),
                        rightParen: .rightParenToken()
                    )
                ),
                returnClause: ReturnClauseSyntax(
                    arrow: .arrowToken(),
                    type: IdentifierTypeSyntax(name: .keyword(.Self))
                )
            ),
            body: CodeBlockSyntax(
                leftBrace: .leftBraceToken(),
                statements: [
                    CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(
                        TryExprSyntax(
                            tryKeyword: .keyword(.try),
                            expression: FunctionCallExprSyntax(
                                calledExpression: MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(
                                        baseName: .identifier("serializer")
                                    ),
                                    period: .periodToken(),
                                    name: .identifier("decode")
                                ),
                                leftParen: .leftParenToken(),
                                arguments: [
                                    LabeledExprSyntax(
                                        expression: DeclReferenceExprSyntax(
                                            baseName: .identifier("value")
                                        )
                                    )
                                ],
                                rightParen: .rightParenToken()
                            )
                        )
                    ))
                ],
                rightBrace: .rightBraceToken()
            )
        )
    }
}
