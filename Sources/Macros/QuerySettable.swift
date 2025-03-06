//
//  QuerySettable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

package enum QuerySettable: PeerMacro {
    enum MacroError: CustomStringConvertible, Error {
        case isNotVariableDeclaration
        case noExplicitTypeAnnotation
        
        var description: String {
            switch self {
                case .isNotVariableDeclaration: return "QuerySettable macro must be applied only to variable declaration"
                case .noExplicitTypeAnnotation: return "QuerySettable macro must be applied only to variable declaration with explicit type annotation"
            }
        }
    }
    
    static package func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let variableDeclaration = declaration.as(VariableDeclSyntax.self) else {
            throw MacroError.isNotVariableDeclaration
        }
        guard let typeAnnotation = variableDeclaration.bindings.filter({ item in
            guard let _ = item.typeAnnotation else { return false }
            return true
        }).first else {
            throw MacroError.noExplicitTypeAnnotation
        }
        let name = typeAnnotation.pattern.trimmedDescription
        guard let type = typeAnnotation.typeAnnotation?.type.trimmedDescription else {
            throw MacroError.noExplicitTypeAnnotation
        }
        return [
            DeclSyntax(FunctionDeclSyntax(
                attributes: [
                    .attribute(AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: IdentifierTypeSyntax(name: .identifier("discardableResult"))
                    ))
                ],
                modifiers: [
                    DeclModifierSyntax(name: .keyword(.consuming)),
                    DeclModifierSyntax(name: .keyword(.public))
                ],
                name: .identifier("set"),
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(
                        leftParen: .leftParenToken(),
                        parameters: [
                            FunctionParameterSyntax(
                                firstName: .identifier(name),
                                type: IdentifierTypeSyntax(name: .identifier(type))
                            )
                        ],
                        rightParen: .rightParenToken()
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
                            VariableDeclSyntax(
                                bindingSpecifier: .keyword(.var),
                                bindings: [
                                    PatternBindingSyntax(
                                        pattern: IdentifierPatternSyntax(identifier: .identifier("copy")),
                                        initializer: InitializerClauseSyntax(
                                            equal: .equalToken(),
                                            value: DeclReferenceExprSyntax(baseName: .keyword(.self))
                                        )
                                    )
                                ]
                            )
                        )),
                        CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(
                            SequenceExprSyntax(elements: [
                                ExprSyntax(MemberAccessExprSyntax(
                                    base: DeclReferenceExprSyntax(baseName: .identifier("copy")),
                                    period: .periodToken(),
                                    declName: DeclReferenceExprSyntax(baseName: .identifier(name))
                                )),
                                ExprSyntax(AssignmentExprSyntax(equal: .equalToken())),
                                ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier(name)))
                            ])
                        )),
                        CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(
                            ReturnStmtSyntax(
                                returnKeyword: .keyword(.return),
                                expression: DeclReferenceExprSyntax(baseName: .identifier("copy"))
                            )
                        ))
                    ],
                    rightBrace: .rightBraceToken()
                )
            ))
        ]
    }
}
