//
//  ImportBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct ImportBuilder {
    let leadingTrivia: Trivia?
    let moduleName: String
    let trailingTrivia: Trivia?
    
    init(leadingTrivia: Trivia? = nil, moduleName: String, trailingTrivia: Trivia? = nil) {
        self.leadingTrivia = leadingTrivia
        self.moduleName = moduleName
        self.trailingTrivia = trailingTrivia
    }
    
    func build() -> ImportDeclSyntax {
        ImportDeclSyntax(
            leadingTrivia: leadingTrivia,
            importKeyword: .keyword(.import, trailingTrivia: .space),
            path: [
                ImportPathComponentSyntax(
                    name: .identifier(moduleName)
                )
            ],
            trailingTrivia: trailingTrivia
        )
    }
}
