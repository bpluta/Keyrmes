//
//  AllCasesLookUpDictonaryExpressionBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct AllCasesLookUpDictonaryExpressionBuilder {
    let leadingTrivia: Trivia
    let platformSettings: PlatformAvailability
    let cases: [CaseDeclaration]
    
    func build() -> DictionaryExprSyntax {
        let filteredDeclarations = cases.filter { declaration in
            declaration.isSupported(on: platformSettings)
        }
        let dictionaryElements = dictionaryElements(from: filteredDeclarations)
        let dictionaryExpression = DictionaryExprSyntax(
            leftSquare: .leftSquareToken(),
            content: dictionaryElements.isEmpty ? .colon(.colonToken()) : .elements(dictionaryElements),
            rightSquare: .rightSquareToken()
        )
        return dictionaryExpression
    }
    
    func dictionaryElements(from declarations: [CaseDeclaration]) -> DictionaryElementListSyntax {
        DictionaryElementListSyntax(
            declarations.map { declaration in
                DictionaryElementSyntax(
                    key: MemberAccessExprSyntax(
                        period: .periodToken(),
                        declName: DeclReferenceExprSyntax(
                            baseName: .identifier(declaration.caseIdentifier)
                        )
                    ),
                    colon: .colonToken(trailingTrivia: .space),
                    value: DeclReferenceExprSyntax(
                        baseName: .identifier(declaration.attributeReference)
                    ),
                    trailingComma: .commaToken(trailingTrivia: .space)
                )
            }.mapLast { declaration in
                var declaration = declaration
                declaration.trailingComma = nil
                return declaration
            }
        )
    }
}

fileprivate extension CaseDeclaration {
    func isSupported(on platformSettings: PlatformAvailability) -> Bool {
        let availabilityConstraints = availability
            .filter { declarationAvailability in
                declarationAvailability.platform == platformSettings.platform
            }
        guard !availabilityConstraints.isEmpty else { return false }
        return availabilityConstraints.contains(where: { declarationAvailability in
            switch (declarationAvailability.availability, platformSettings.availability) {
            case (.always, .always):
                return true
            case (.always, .since(version: _, deprecated: _)):
                return true
            case (.since(let itemAvailability, _), .since(let platformSettingsAvailability, _)):
                return platformSettingsAvailability.isHigherOrEqual(than: itemAvailability)
            default:
                return false
            }
        })
    }
}
