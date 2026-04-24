//
//  KeyrmesMacros.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

@attached(peer, names: arbitrary)
package macro QuerySettable(_ customKey: String = "") = #externalMacro(module: "KeyrmesMacrosPlugin", type: "QuerySettable")

@attached(member, names: arbitrary)
package macro QueryBuilder() = #externalMacro(module: "KeyrmesMacrosPlugin", type: "QueryBuilder")

@attached(member, names: arbitrary)
package macro DefaultKeychainSerializable() = #externalMacro(module: "KeyrmesMacrosPlugin", type: "DefaultKeychainSerializable")
