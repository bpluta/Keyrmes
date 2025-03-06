//
//  EnumBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct EnumBuilder {
    let name: String
    let inheritedTypes: [String]
    let caseDeclarations: [CaseDeclaration]
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> EnumDeclSyntax {
        EnumDeclSyntax(
            modifiers: [
                DeclModifierSyntax(name: .keyword(.public), trailingTrivia: .space)
            ],
            enumKeyword: .keyword(.enum, trailingTrivia: .space),
            name: .identifier(name),
            inheritanceClause: InheritanceClauseBuilder(
                inheritedTypes: inheritedTypes
            ).build(),
            memberBlock: MemberBlockSyntax(
                leftBrace: .leftBraceToken(trailingTrivia: .newline),
                members: MemberBlockItemListSyntax(
                    caseDeclarations.map { enumCase in
                        MemberBlockItemSyntax(decl: DeclSyntax(
                            EnumCaseBuilder(
                                leadingTrivia: .tab,
                                caseDeclaration: enumCase,
                                supportedPlatforms: supportedPlatforms
                            ).build()
                        ))
                    } + [
                        MemberBlockItemSyntax(decl: DeclSyntax(
                            LookupTableDeclarationBuilder(
                                leadingTrivia: .tab,
                                cases: caseDeclarations,
                                supportedPlatforms: supportedPlatforms
                            ).build()
                        )),
                        MemberBlockItemSyntax(decl: DeclSyntax(
                            KeychainValueDeclarationBuilder(
                                leadingTrivia: .tab,
                                cases: caseDeclarations
                            ).build()
                        )),
                        MemberBlockItemSyntax(decl: DeclSyntax(
                            AllCasesDeclarationBuilder(
                                leadingTrivia: .tab,
                                cases: caseDeclarations,
                                supportedPlatforms: supportedPlatforms
                            ).build()
                        ))
                    ]
                ),
                rightBrace: .rightBraceToken()
            )
        )
    }
}
