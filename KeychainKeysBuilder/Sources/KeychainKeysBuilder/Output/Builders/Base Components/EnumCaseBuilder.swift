//
//  EnumCaseBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct EnumCaseBuilder {
    let leadingTrivia: Trivia
    let caseDeclaration: CaseDeclaration
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> EnumCaseDeclSyntax {
        EnumCaseDeclSyntax(
            attributes: AttributeListSyntax(
                attributes.compactMap { attribute in
                    AttributeListSyntax.Element(attribute)
                        .with(\.leadingTrivia, leadingTrivia)
                }
            ),
            caseKeyword: .keyword(.case, leadingTrivia: leadingTrivia, trailingTrivia: .spaces(1)),
            elements: [
                EnumCaseElementSyntax(name: .identifier(enumCaseName))
            ],
            trailingTrivia: .newlines(2)
        )
    }
    
    var attributes: [AttributeSyntax] {
        let attributeBuilder = AvailableAttributesBuilder(
            availability: caseDeclaration.flattenAvailability(supportedPlatforms: supportedPlatforms),
            supportedPlatforms: supportedPlatforms
        )
        return attributeBuilder.build()
    }
    
    var enumCaseName: String {
        let identifierName = caseDeclaration.caseIdentifier
        guard ["class"].contains(identifierName) else {
            return identifierName
        }
        return "`\(identifierName)`"
    }
}
