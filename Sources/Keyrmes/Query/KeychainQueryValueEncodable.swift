//
//  KeychainQueryValueEncodable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import LocalAuthentication

/// A protocol that defines a value which can be encoded into a format suitable for Keychain queries.
///
/// Conforming types must provide a computed property, `keychainEncodableValue`, that converts the value
/// into a representation acceptable by the Keychain API. This enables seamless integration of common
/// Swift types (like Data, Bool, and String) into keychain query dictionaries.
public protocol KeychainQueryValueEncodable {
    
    /// The encodable representation of the value for keychain queries.
    ///
    /// This property should return a value that can be directly used when constructing a keychain query.
    /// For instance, a String may return its UTF-8 encoded Data, and a Bool may return `CFBoolean`.
    ///
    var keychainEncodableValue: Any? { get }
}

extension Data: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        self
    }
}

extension Bool: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        self ? kCFBooleanTrue : kCFBooleanFalse
    }
}

extension String: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        data(using: .utf8)
    }
}

extension LAContext: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        self
    }
}

extension SecAccessControl: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        self
    }
}

extension KeychainQueryKey.ReferenceValue: KeychainQueryValueEncodable {
    public var keychainEncodableValue: Any? {
        switch self {
        case .key(let secureKey):
            secureKey
        case .certificate(let certificate):
            certificate
        case .identity(let identity):
            identity
        }
    }
}
