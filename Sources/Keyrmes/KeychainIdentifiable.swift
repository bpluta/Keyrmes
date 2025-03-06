//
//  KeychainIdentifiable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A protocol representing types that uniquely identify keychain items.
///
/// Conforming types provide a unique label to reference a specific keychain item during storage,
/// retrieval, and deletion operations.
///
public protocol KeychainIdentifiable: Sendable, KeychainQueryValueEncodable {
    
    /// A unique string label for the keychain item.
    ///
    /// This label serves as the primary identifier in keychain queries. It must be unique
    /// within the storage context and remain consistent across operations to reliably locate
    /// the associated keychain item.
    ///
    var keychainLabel: String { get }
}

extension KeychainIdentifiable {
    public var keychainEncodableValue: Any? { keychainLabel }
}
