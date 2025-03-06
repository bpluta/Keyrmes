//
//  KeyrmesKeychainSerializer.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A default implementation of `KeychainSerializer` that supports encoding and decoding of
/// commonly used types.
///
/// - Note: In this specific implementation,  numeric types are stored by copying their binary representation
/// directly to `Data`. Strings use UTF-8 encoding/decoding, `Codable` types use JSON encoding with sorted keys,
/// and NSCoding objects are archived/unarchived with `requiresSecureCoding` option.
public struct KeyrmesKeychainSerializer: Sendable, KeychainSerializer {
    
    public init() { }
    
    // MARK: - Int
    /// Encodes an `Int` by storing its raw binary representation in `Data`.
    public func encode(_ value: Int) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int` by restoring its raw binary data to the original type.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int {
        try load(rawData: data)
    }
    
    // MARK: - UInt
    /// Encodes a `UInt` by storing its raw binary representation in `Data`.
    public func encode(_ value: UInt) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt` by restoring its raw binary data to the original type.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt {
        try load(rawData: data)
    }
    
    // MARK: - Int8
    /// Encodes an `Int8` as raw bytes.
    public func encode(_ value: Int8) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int8` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int8 {
        try load(rawData: data)
    }
    
    // MARK: - UInt8
    /// Encodes a `UInt8` as raw bytes.
    public func encode(_ value: UInt8) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt8` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt8 {
        try load(rawData: data)
    }
    
    // MARK: - Int16
    /// Encodes an `Int16` as raw bytes.
    public func encode(_ value: Int16) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int16` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int16 {
        try load(rawData: data)
    }
    
    // MARK: - UInt16
    /// Encodes a `UInt16` as raw bytes.
    public func encode(_ value: UInt16) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt16` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt16 {
        try load(rawData: data)
    }
    
    // MARK: - Int32
    /// Encodes an `Int32` as raw bytes.
    public func encode(_ value: Int32) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int32` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int32 {
        try load(rawData: data)
    }
    
    // MARK: - UInt32
    /// Encodes a `UInt32` as raw bytes.
    public func encode(_ value: UInt32) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt32` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt32 {
        try load(rawData: data)
    }
    
    // MARK: - Int64
    /// Encodes an `Int64` as raw bytes.
    public func encode(_ value: Int64) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int64` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int64 {
        try load(rawData: data)
    }
    
    // MARK: - UInt64
    /// Encodes a `UInt64` as raw bytes.
    public func encode(_ value: UInt64) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt64` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt64 {
        try load(rawData: data)
    }
    
    // MARK: - Int128
    /// Encodes an `Int128` as raw bytes
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func encode(_ value: Int128) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes an `Int128` from its raw byte representation
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Int128 {
        try load(rawData: data)
    }
    
    // MARK: - UInt128
    /// Encodes a `UInt128` as raw bytes (available on supported OS versions).
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func encode(_ value: UInt128) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `UInt128` from its raw byte representation (available on supported OS versions).
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func decode(_ data: Data) throws(KeychainSerializerError) -> UInt128 {
        try load(rawData: data)
    }
    
    // MARK: - Float
    /// Encodes a `Float` as raw bytes.
    public func encode(_ value: Float) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `Float` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Float {
        try load(rawData: data)
    }
    
    // MARK: - Double
    /// Encodes a `Double` as raw bytes.
    public func encode(_ value: Double) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `Double` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Double {
        try load(rawData: data)
    }
    
    // MARK: - Bool
    /// Encodes a `Bool` as raw bytes.
    public func encode(_ value: Bool) throws(KeychainSerializerError) -> Data {
        rawData(of: value)
    }
    
    /// Decodes a `Bool` from its raw byte representation.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Bool {
        try load(rawData: data)
    }
    
    // MARK: - String
    /// Encodes a `String` using UTF-8 data.
    public func encode(_ value: String) throws(KeychainSerializerError) -> Data {
        try encodeString(value)
    }
    
    /// Decodes a `String` assuming UTF-8-encoded data.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> String {
        try decodeString(data: data)
    }
    
    // MARK: - Data
    /// Returns the provided `Data` unmodified.
    public func encode(_ value: Data) throws(KeychainSerializerError) -> Data {
        value
    }
    
    /// Returns the provided `Data` unmodified.
    public func decode(_ data: Data) throws(KeychainSerializerError) -> Data {
        data
    }
    
    // MARK: - Codable
    /// Encodes any `Codable` type as JSON with sorted keys.
    public func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T: Codable {
        try encodeJSON(value: value)
    }
    
    /// Decodes any `Codable` type from JSON data.
    public func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T: Codable {
        try decodeJSON(data: data)
    }
    
    // MARK: - NSCoding
    /// Encodes an `NSCoding` object using `NSKeyedArchiver` with secure coding.
    public func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T: NSObject, T: NSCoding {
        try archive(value: value)
    }
    
    /// Decodes an `NSCoding` object using `NSKeyedUnarchiver` with secure coding.
    public func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T: NSObject, T: NSCoding {
        try unarchive(data: data)
    }
}


// MARK: - Helpers
extension KeyrmesKeychainSerializer {
    private func rawData<T>(of value: T) -> Data {
        Data(from: value)
    }
    
    private func load<T>(rawData: Data) throws(KeychainSerializerError) -> T {
        guard let loadedType: T = rawData.load(as: T.self) else {
            throw .decodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .rawDataConversionError
                )
            )
        }
        return loadedType
    }
    
    private func archive<T>(value: T) throws(KeychainSerializerError) -> Data where T: NSCoding, T: NSObject {
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
            return archivedData
        } catch {
            throw .encodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .archiverError(error: error)
                )
            )
        }
    }
    
    private func unarchive<T>(data: Data) throws(KeychainSerializerError) -> T where T: NSCoding, T: NSObject {
        let unarchivedObject: T?
        do {
            unarchivedObject = try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
        } catch {
            throw .decodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .unarchiverError(error: error)
                )
            )
        }
        guard let decodedValue = unarchivedObject else {
            throw .decodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .invalidUnarchiverData
                )
            )
        }
        return decodedValue
    }
    
    private func encodeJSON<T>(value: T) throws(KeychainSerializerError) -> Data where T: Encodable {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            return try encoder.encode(value)
        } catch {
            throw .encodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .jsonConversionError(error: error)
                )
            )
        }
    }
    
    private func decodeJSON<T>(data: Data) throws(KeychainSerializerError) -> T where T: Decodable {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw .decodingFailure(
                context: KeychainSerializerError.Context(
                    type: T.self,
                    underlyingError: .jsonConversionError(error: error)
                )
            )
        }
    }
    
    private func encodeString(_ string: String) throws(KeychainSerializerError) -> Data {
        guard let encodedValue = string.data(using: .utf8) else {
            throw .encodingFailure(
                context: KeychainSerializerError.Context(
                    type: String.self,
                    underlyingError: .stringConversionError
                )
            )
        }
        return encodedValue
    }
    
    private func decodeString(data: Data) throws(KeychainSerializerError) -> String {
        guard let decodedValue = String(data: data, encoding: .utf8) else {
            throw .decodingFailure(
                context: KeychainSerializerError.Context(
                    type: String.self,
                    underlyingError: .stringConversionError
                )
            )
        }
        return decodedValue
    }
}

extension KeyrmesKeychainSerializer {
    public enum SerializerError: Error, CustomDebugStringConvertible {
        case rawDataConversionError
        case stringConversionError
        case jsonConversionError(error: Error)
        case unarchiverError(error: Error)
        case archiverError(error: Error)
        case invalidUnarchiverData
        
        public var debugDescription: String {
            switch self {
            case .rawDataConversionError:
                "Raw data conversion error"
            case .stringConversionError:
                "String (UTF-8) conversion error"
            case .jsonConversionError(let error):
                "JSON conversion error: (\(error))"
            case .unarchiverError(let error):
                "Unarchiver error: (\(error))"
            case .archiverError(let error):
                "Archiver error: (\(error))"
            case .invalidUnarchiverData:
                "Invalid unarchiver data"
            }
        }
    }
}

fileprivate extension KeychainSerializerError.Context {
    init(type: Any.Type, underlyingError: KeyrmesKeychainSerializer.SerializerError) {
        self.type = type
        self.underlyingError = underlyingError
    }
}
