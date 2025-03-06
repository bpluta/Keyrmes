//
//  CaseDeclaration+Variable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

extension CaseDeclaration {
    init?(from variableDecalaration: VariableDeclSyntax) {
        guard let variableName = variableDecalaration.variableName else { return nil }
        let nameProcessor = DeclarationNameProcessor()
        attributeReference = variableName
        caseIdentifier = nameProcessor.process(name: variableName)
        availability = variableDecalaration.attributes
            .compactMap { attribute in
                PlatformAvailability(from: attribute, nameProcessor: nameProcessor)
            }
    }
}
