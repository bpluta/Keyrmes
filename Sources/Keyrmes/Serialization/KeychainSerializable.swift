//
//  KeychainSerializable.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import KeyrmesMacros

/// A protocol describing types that can be transformed into and from `Data` for secure keychain storage.
public protocol KeychainSerializable {
    
    /// Encodes this type into raw `Data` using a given serializer.
    ///
    /// - Parameters:
    ///   - value: The value to be serialized.
    ///   - serializer: The `KeychainSerializer`object that is used for encoding.
    /// - Throws: A `KeychainSerializerError` error  thrown during the encoding operation.
    /// - Returns: A `Data` representation of the provided value.
    ///
    static func encode(value: Self, using serializer: KeychainSerializer) throws(KeychainSerializerError) -> Data
    
    /// Decodes raw `Data` into an instance of this type using a given serializer.
    ///
    /// - Parameters:
    ///   - value: The `Data` containing the serialized instance.
    ///   - serializer: The `KeychainSerializer` object that is used for decoding.
    /// - Throws: A `KeychainSerializerError` error  thrown during the decoding operation.
    /// - Returns: A new instance of this type decoded from the given data.
    ///
    static func decode(value: Data, using serializer: KeychainSerializer) throws(KeychainSerializerError) -> Self
}

@DefaultKeychainSerializable
extension Int: KeychainSerializable { }

@DefaultKeychainSerializable
extension UInt: KeychainSerializable { }

@DefaultKeychainSerializable
extension Int8: KeychainSerializable { }

@DefaultKeychainSerializable
extension UInt8: KeychainSerializable { }

@DefaultKeychainSerializable
extension Int16: KeychainSerializable { }

@DefaultKeychainSerializable
extension UInt16: KeychainSerializable { }

@DefaultKeychainSerializable
extension Int32: KeychainSerializable { }

@DefaultKeychainSerializable
extension UInt32: KeychainSerializable { }

@DefaultKeychainSerializable
extension Int64: KeychainSerializable { }

@DefaultKeychainSerializable
extension UInt64: KeychainSerializable { }

@DefaultKeychainSerializable
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Int128: KeychainSerializable { }

@DefaultKeychainSerializable
@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension UInt128: KeychainSerializable { }

@DefaultKeychainSerializable
extension Double: KeychainSerializable { }

@DefaultKeychainSerializable
extension Float: KeychainSerializable { }

@DefaultKeychainSerializable
extension Bool: KeychainSerializable { }

@DefaultKeychainSerializable
extension String: KeychainSerializable { }

@DefaultKeychainSerializable
extension Data: KeychainSerializable { }

@DefaultKeychainSerializable
extension KeychainSerializable where Self: Codable { }

@DefaultKeychainSerializable
extension KeychainSerializable where Self: NSObject, Self: NSCoding { }
