//
//  CaseDeclaration+NameProcessable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

protocol NameProcessable {
    func process(name: String) -> String
}

extension CaseDeclaration {
    struct DeclarationNameProcessor: NameProcessable {
        func process(name: String) -> String {
            var name = name
            name.replace(/^kSec/, with: "")
            name.replace(/Attr(?!ibute)/, with: "Attribute")
            name.replace(/Ref(?!erence)/, with: "Reference")
            name = name.prefix(1).lowercased() + name.dropFirst()
            return name
        }
    }
}
