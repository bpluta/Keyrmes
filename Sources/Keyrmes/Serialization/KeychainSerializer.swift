//
//  KeychainSerializer.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A serializer protocol defining methods to encode and decode various types into/from `Data`.
/// Conforming types enable storage and retrieval of primitive numeric values, booleans, strings,
/// and more complex `Codable` or `NSCoding` objects from the keychain with full type safety.
public protocol KeychainSerializer: Sendable {
    
    /// Encodes an `Int` into `Data`.
    func encode(_ value: Int) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int
    
    /// Encodes a `UInt` into `Data`.
    func encode(_ value: UInt) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt
    
    /// Encodes an `Int8` into `Data`.
    func encode(_ value: Int8) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int8` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int8
    
    /// Encodes a `UInt8` into `Data`.
    func encode(_ value: UInt8) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt8` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt8
    
    /// Encodes an `Int16` into `Data`.
    func encode(_ value: Int16) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int16` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int16
    
    /// Encodes a `UInt16` into `Data`.
    func encode(_ value: UInt16) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt16` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt16
    
    /// Encodes an `Int32` into `Data`.
    func encode(_ value: Int32) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int32` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int32
    
    /// Encodes a `UInt32` into `Data`.
    func encode(_ value: UInt32) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt32` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt32
    
    /// Encodes an `Int64` into `Data`.
    func encode(_ value: Int64) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int64` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int64
    
    /// Encodes a `UInt64` into `Data`.
    func encode(_ value: UInt64) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt64` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt64
    
    /// Encodes an `Int128` into `Data`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func encode(_ value: Int128) throws(KeychainSerializerError) -> Data
    /// Decodes an `Int128` from `Data`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func decode(_ data: Data) throws(KeychainSerializerError) -> Int128
    
    /// Encodes a `UInt128` into `Data`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func encode(_ value: UInt128) throws(KeychainSerializerError) -> Data
    /// Decodes a `UInt128` from `Data`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func decode(_ data: Data) throws(KeychainSerializerError) -> UInt128
    
    /// Encodes a `Float` into `Data`.
    func encode(_ value: Float) throws(KeychainSerializerError) -> Data
    /// Decodes a `Float` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Float
    
    /// Encodes a `Double` into `Data`.
    func encode(_ value: Double) throws(KeychainSerializerError) -> Data
    /// Decodes a `Double` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Double
    
    /// Encodes a `Bool` into `Data`.
    func encode(_ value: Bool) throws(KeychainSerializerError) -> Data
    /// Decodes a `Bool` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Bool
    
    /// Encodes a `String` into `Data`.
    func encode(_ value: String) throws(KeychainSerializerError) -> Data
    /// Decodes a `String` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> String
    
    /// Encodes raw `Data`.
    func encode(_ value: Data) throws(KeychainSerializerError) -> Data
    /// Decodes raw `Data` from `Data`.
    func decode(_ data: Data) throws(KeychainSerializerError) -> Data
    
    /// Encodes any `Codable` type into `Data`.
    func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T: Codable
    /// Decodes any `Codable` type from `Data`.
    func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T: Codable
    
    /// Encodes any `NSCoding`-based object into `Data`.
    func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T: NSObject, T: NSCoding
    /// Decodes any `NSCoding`-based object from `Data`.
    func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T: NSObject, T: NSCoding
}

public enum KeychainSerializerError: Error, CustomDebugStringConvertible {
    case encodingFailure(context: Context)
    case decodingFailure(context: Context)
    
    public struct Context: Sendable {
        public typealias UnderlyingError = Error & CustomDebugStringConvertible
        
        public let type: Any.Type
        public let underlyingError: any UnderlyingError
   
        public init(type: Any.Type, underlyingError: any UnderlyingError) {
            self.type = type
            self.underlyingError = underlyingError
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .encodingFailure(let context):
            return "Encoding of type \"\(context.type)\" has failed: (\(context.underlyingError.debugDescription))"
        case .decodingFailure(let context):
            return "Decoding of type \"\(context.type)\" has failed: (\(context.underlyingError.debugDescription))"
        }
    }
}
