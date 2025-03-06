//
//  VariableDeclSyntax+VariableName.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

extension VariableDeclSyntax {
    var variableName: String? {
        bindings.compactMap { binding -> String? in
            guard let patternBinding = PatternBindingSyntax(binding) else { return nil }
            guard let identifierPattern = IdentifierPatternSyntax(patternBinding.pattern) else { return nil }
            return identifierPattern.identifier.trimmedDescription
        }.first
    }
}
