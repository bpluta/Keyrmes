//
//  KeyrmesMacros.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

@attached(peer, names: arbitrary)
package macro QuerySettable(_ customKey: String = "") = #externalMacro(module: "Macros", type: "QuerySettable")

@attached(member, names: arbitrary)
package macro QueryBuilder() = #externalMacro(module: "Macros", type: "QueryBuilder")

@attached(member, names: arbitrary)
package macro DefaultKeychainSerializable() = #externalMacro(module: "Macros", type: "DefaultKeychainSerializable")
