//
//  InheritanceClauseBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct InheritanceClauseBuilder {
    let inheritedTypes: [String]
    
    func build() -> InheritanceClauseSyntax {
        InheritanceClauseSyntax(
            colon: .colonToken(trailingTrivia: .space),
            inheritedTypes: InheritedTypeListSyntax(
                inheritedTypes.map { type in
                    InheritedTypeSyntax(
                        type: IdentifierTypeSyntax(name: .identifier(type)),
                        trailingComma: .commaToken(trailingTrivia: .space)
                    )
                }.mapLast { item in
                    var item = item
                    item.trailingComma = nil
                    return item
                }
            ),
            trailingTrivia: .space
        )
    }
}
