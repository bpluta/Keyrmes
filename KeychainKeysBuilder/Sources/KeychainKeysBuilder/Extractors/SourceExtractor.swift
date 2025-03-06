//
//  SourceExtractor.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import SwiftSyntax
import SwiftParser

struct SourceExtractor {
    let sourceFile: SourceFileSyntax
    let platform: Platform
    
    init(sourceCode: String, platform: Platform) {
        self.platform = platform
        self.sourceFile = Parser.parse(source: sourceCode)
    }
    
    var variableDeclarations: [VariableDeclSyntax] {
        sourceFile.statements.compactMap { statement in
            statement.item.as(VariableDeclSyntax.self)
        }
    }
}
