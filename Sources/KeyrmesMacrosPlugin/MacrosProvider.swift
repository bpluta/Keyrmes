//
//  MacrosProvider.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct MacrosProvider: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        QueryBuilder.self,
        QuerySettable.self,
        DefaultKeychainSerializable.self
    ]
}
