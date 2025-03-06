//
//  KeychainQueryBuildable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A protocol for building a keychain query dictionary
public protocol QueryBuildable: ~Copyable {
    typealias QueryType = [String: Any]
    typealias QueryDictionaryType = NSDictionary
    
    /// Constructs and returns a keychain query dictionary consuming the query content.
    ///
    /// - Returns: A `QueryDictionaryType` (`NSDictionary)`  representing the query parameters for keychain operations.
    ///
    consuming func buildQuery() -> QueryDictionaryType
}

/// An extension on the Swift dictionary type used for constructing keychain queries.
extension QueryBuildable.QueryType {
    
    /// Sets a keychain query parameter using a `KeychainQueryKey`.
    ///
    /// The method converts the given `KeychainQueryKey` to its corresponding string value using `keychainValue
    ///  representatio and delegates to the string-based setter.
    ///
    /// - Parameters:
    ///   - key: A `KeychainQueryKey` representing a specific query attribute.
    ///   - value: An optional value conforming to `KeychainQueryValueEncodable` that will be encoded.
    ///
    mutating func set(_ key: KeychainQueryKey, to value: KeychainQueryValueEncodable?) {
        set(key.keychainValue, to: value)
    }
    
    /// Sets a keychain query parameter using a string key.
    ///
    /// This method encodes the provided value using its `keychainEncodableValue` property. If either of the value
    /// or its `keychainEncodableValue` representation is `nil`, it does not get inserted into the dictionary.
    ///
    /// - Parameters:
    ///   - key: A `String` representing the key for the query parameter.
    ///   - value: An optional value conforming to `KeychainQueryValueEncodable` to be set.
    ///
    mutating func set(_ key: String, to value: KeychainQueryValueEncodable?) {
        guard let value, let encodedData = value.keychainEncodableValue else { return }
        self[key] = encodedData
    }
}
