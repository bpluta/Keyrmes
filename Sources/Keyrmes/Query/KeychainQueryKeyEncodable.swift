//
//  KeychainQueryKeyEncodable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A protocol for types that can be represented as a key in keychain query dictionaries.
public protocol KeychainQueryKeyEncodable {
    
    /// A string representation of the key used in keychain queries.
    ///
    /// This value is utilized to specify the attribute key when building a query for Keychain operations.
    /// It should uniquely identify a particular query parameter.
    ///
    var keychainValue: String { get }
}

/// A protocol encapsulating a`KeychainQueryKey`. By default exposing it as both `KeychainQueryKeyEncodable`
/// and `KeychainQueryValueEncodable`protocol implementations . Purpose of this protocol is to allow
/// creating grouping subsets of `KeychainQueryKey` enum cases.
public protocol KeychainQueryKeyRepresentable: KeychainQueryKeyEncodable, KeychainQueryValueEncodable {
    
    /// The underlying key used in keychain queries.
    ///
    /// This property encapsulates the attribute identifier which is then used to map values within a query dictionary.
    ///
    var queryKey: KeychainQueryKey { get }
}

extension KeychainQueryKeyRepresentable {
    public var keychainValue: String {
        queryKey.keychainValue
    }
    
    public var keychainEncodableValue: Any? {
        keychainValue
    }
}
