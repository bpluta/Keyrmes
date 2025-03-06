//
//  QueryBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

package enum QueryBuilder: MemberMacro {
    
    static package func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let queryAttributeNames = getQuerySettableNames(from: declaration)
        let queryDeclaration = CodeBlockItemSyntax.Item(getQueryDeclaration())
        let assignments = queryAttributeNames.map { item in
            CodeBlockItemSyntax.Item(getSettingQueryCall(item: item))
        }
        let returnStatement = CodeBlockItemSyntax.Item(getReturnStatement())
        let codeBlock = [queryDeclaration] + assignments + [returnStatement]
        return [
            DeclSyntax(FunctionDeclSyntax(
                modifiers: [
                    DeclModifierSyntax(name: .keyword(.consuming)),
                    DeclModifierSyntax(name: .keyword(.public))
                ],
                name: .identifier("buildQuery"),
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(
                        leftParen: .leftParenToken(),
                        parameters: [],
                        rightParen: .rightParenToken()
                    ),
                    returnClause: ReturnClauseSyntax(
                        arrow: .arrowToken(),
                        type: IdentifierTypeSyntax(name: .identifier("QueryDictionaryType"))
                    )
                ),
                body: CodeBlockSyntax(
                    leftBrace: .leftBraceToken(),
                    statements: CodeBlockItemListSyntax(codeBlock.map { item in
                        CodeBlockItemSyntax(item: item)
                    }),
                    rightBrace: .rightBraceToken()
                )
            ))
        ]
    }
    
    private static func getQuerySettableNames(from declaration: some DeclGroupSyntax) -> [SettableItem] {
        declaration.memberBlock.members
            .compactMap { member in
                VariableDeclSyntax(member.decl)
            }.filter { declaration in
                declaration.attributes
                    .compactMap { attribute in
                        attribute.as(AttributeSyntax.self)
                    }.contains { attribute in
                        guard let attributeName = attribute.attributeName.as(IdentifierTypeSyntax.self)?.name else { return false }
                        return attributeName.trimmedDescription == "QuerySettable"
                    }
            }.compactMap { declaration in
                guard let variableName = extractVariableIdentifier(from: declaration) else { return nil }
                let customQueryKey = extractCustomKeyIdentifier(from: declaration)
                let queryKey: QueryKey = switch customQueryKey {
                case .some(let stringLiteral):
                    .stringLiteral(stringLiteral)
                case .none:
                    .keyReference(variableName)
                }
                return SettableItem(queryKey: queryKey, variableName: variableName)
            }
    }
    
    private static func extractVariableIdentifier(from declaration: VariableDeclSyntax) -> TokenSyntax? {
        declaration.bindings
            .compactMap { binding in
                binding.pattern.as(IdentifierPatternSyntax.self)
            }.compactMap { pattern -> TokenSyntax? in
                guard case .identifier(_) = pattern.identifier.tokenKind else { return nil }
                return pattern.identifier
            }.first
    }
    
    private static func extractCustomKeyIdentifier(from declaration: VariableDeclSyntax) -> StringLiteralExprSyntax? {
        declaration.attributes
            .compactMap { attribute in
                attribute.as(AttributeSyntax.self)
            }.compactMap { attribute in
                attribute.arguments?.as(LabeledExprListSyntax.self)
            }.compactMap { arguments in
                arguments.compactMap { argument in
                    StringLiteralExprSyntax(argument.expression)
                }.first
            }.first
    }
    
    private static func getSettingQueryCall(item: SettableItem) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            calledExpression: MemberAccessExprSyntax(
                base: DeclReferenceExprSyntax(baseName: .identifier("query")),
                period: .periodToken(),
                declName: DeclReferenceExprSyntax(baseName: .identifier("set"))
            ),
            leftParen: .leftParenToken(),
            arguments: [
                item.querySetterKeyArgument,
                item.querySetterValueArgument
            ],
            rightParen: .rightParenToken()
        )
    }
    
    private static func getQueryDeclaration() -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingSpecifier: .keyword(.var),
            bindings: [
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("query")),
                    initializer: InitializerClauseSyntax(
                        equal: .equalToken(),
                        value: FunctionCallExprSyntax(
                            calledExpression: DeclReferenceExprSyntax(baseName: .identifier("QueryType")),
                            leftParen: .leftParenToken(),
                            arguments: [],
                            rightParen: .rightParenToken()
                        )
                    )
                )
            ]
        )
    }
    
    private static func getReturnStatement() -> ReturnStmtSyntax {
        ReturnStmtSyntax(
            returnKeyword: .keyword(.return),
            expression: SequenceExprSyntax(elements: [
                .init(DeclReferenceExprSyntax(baseName: .identifier("query"))),
                .init(UnresolvedAsExprSyntax(asKeyword: .keyword(.as))),
                .init(TypeExprSyntax(type: IdentifierTypeSyntax(name: .identifier("QueryDictionaryType"))))
            ])
        )
    }
}

extension QueryBuilder {
    struct SettableItem {
        let queryKey: QueryKey
        let variableName: TokenSyntax
        
        var querySetterKeyArgument: LabeledExprSyntax {
            switch queryKey {
            case .keyReference(let key):
                LabeledExprSyntax(
                    expression: MemberAccessExprSyntax(
                        period: .periodToken(),
                        name: key
                    ),
                    trailingComma: .commaToken()
                )
            case .stringLiteral(let stringLiteral):
                LabeledExprSyntax(
                    expression: stringLiteral,
                    trailingComma: .commaToken()
                )
            }
        }
        
        var querySetterValueArgument: LabeledExprSyntax {
            LabeledExprSyntax(
                label: .identifier("to"),
                colon: .colonToken(),
                expression: DeclReferenceExprSyntax(baseName: variableName)
            )
        }
    }
    
    enum QueryKey {
        case stringLiteral(StringLiteralExprSyntax)
        case keyReference(TokenSyntax)
    }
}
