//
//  AllCasesArrayExpressionBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct AllCasesArrayExpressionBuilder {
    let platformSettings: PlatformAvailability
    let cases: [CaseDeclaration]
    
    func build() -> ArrayExprSyntax {
        let filteredDeclarations = cases.filter { declaration in
            declaration.isSupported(on: platformSettings)
        }
        let arrayExpression = ArrayExprSyntax(
            leftSquare: .leftSquareToken(),
            elements: ArrayElementListSyntax(
                filteredDeclarations.map { declaration in
                    ArrayElementSyntax(
                        expression: MemberAccessExprSyntax(
                            period: .periodToken(),
                            name: .identifier(declaration.caseIdentifier)
                        ),
                        trailingComma: .commaToken(trailingTrivia: .space)
                    )
                }.mapLast { item in
                    var item = item
                    item.trailingComma = nil
                    return item
                }
            ),
            rightSquare: .rightSquareToken()
        )
        return arrayExpression
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
