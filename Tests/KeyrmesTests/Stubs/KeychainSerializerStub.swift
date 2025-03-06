//
//  KeychainSerializerStub.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import Keyrmes

extension KeyrmesSerializationBridgeTests {
    class KeychainSerializerStub: @unchecked Sendable, KeychainSerializer {
        var encodeIntCalled: Bool = false
        var decodeIntCalled: Bool = false
        
        var encodeUIntCalled: Bool = false
        var decodeUIntCalled: Bool = false
        
        var encodeInt8Called: Bool = false
        var decodeInt8Called: Bool = false
        
        var encodeUInt8Called: Bool = false
        var decodeUInt8Called: Bool = false
        
        var encodeInt16Called: Bool = false
        var decodeInt16Called: Bool = false
        
        var encodeUInt16Called: Bool = false
        var decodeUInt16Called: Bool = false
        
        var encodeInt32Called: Bool = false
        var decodeInt32Called: Bool = false
        
        var encodeUInt32Called: Bool = false
        var decodeUInt32Called: Bool = false
        
        var encodeInt64Called: Bool = false
        var decodeInt64Called: Bool = false
        
        var encodeUInt64Called: Bool = false
        var decodeUInt64Called: Bool = false
        
        var encodeInt128Called: Bool = false
        var decodeInt128Called: Bool = false
        
        var encodeUInt128Called: Bool = false
        var decodeUInt128Called: Bool = false
        
        var encodeFloatCalled: Bool = false
        var decodeFloatCalled: Bool = false
        
        var encodeDoubleCalled: Bool = false
        var decodeDoubleCalled: Bool = false
        
        var encodeBoolCalled: Bool = false
        var decodeBoolCalled: Bool = false
        
        var encodeStringCalled: Bool = false
        var decodeStringCalled: Bool = false
        
        var encodeDataCalled: Bool = false
        var decodeDataCalled: Bool = false
        
        var encodeCodableCalled: Bool = false
        var decodeCodableCalled: Bool = false
        
        var encodeNSCodingCalled: Bool = false
        var decodeNSCodingCalled: Bool = false
        
        func encode(_ value: Int) throws(KeychainSerializerError) -> Data {
            encodeIntCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int {
            decodeIntCalled = true
            return .init()
        }
        
        func encode(_ value: UInt) throws(KeychainSerializerError) -> Data {
            encodeUIntCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt {
            decodeUIntCalled = true
            return .init()
        }
        
        func encode(_ value: Int8) throws(KeychainSerializerError) -> Data {
            encodeInt8Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int8 {
            decodeInt8Called = true
            return .init()
        }
        
        func encode(_ value: UInt8) throws(KeychainSerializerError) -> Data {
            encodeUInt8Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt8 {
            decodeUInt8Called = true
            return .init()
        }
        
        func encode(_ value: Int16) throws(KeychainSerializerError) -> Data {
            encodeInt16Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int16 {
            decodeInt16Called = true
            return .init()
        }
        
        func encode(_ value: UInt16) throws(KeychainSerializerError) -> Data {
            encodeUInt16Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt16 {
            decodeUInt16Called = true
            return .init()
        }
        
        func encode(_ value: Int32) throws(KeychainSerializerError) -> Data {
            encodeInt32Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int32 {
            decodeInt32Called = true
            return .init()
        }
        
        func encode(_ value: UInt32) throws(KeychainSerializerError) -> Data {
            encodeUInt32Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt32 {
            decodeUInt32Called = true
            return .init()
        }
        
        func encode(_ value: Int64) throws(KeychainSerializerError) -> Data {
            encodeInt64Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int64 {
            decodeInt64Called = true
            return .init()
        }
        
        func encode(_ value: UInt64) throws(KeychainSerializerError) -> Data {
            encodeUInt64Called = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt64 {
            decodeUInt64Called = true
            return .init()
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        func encode(_ value: Int128) throws(KeychainSerializerError) -> Data {
            encodeInt128Called = true
            return .init()
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        func decode(_ data: Data) throws(KeychainSerializerError) -> Int128 {
            decodeInt128Called = true
            return .init()
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        func encode(_ value: UInt128) throws(KeychainSerializerError) -> Data {
            encodeUInt128Called = true
            return .init()
        }
        
        @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
        func decode(_ data: Data) throws(KeychainSerializerError) -> UInt128 {
            decodeUInt128Called = true
            return .init()
        }
        
        func encode(_ value: Float) throws(KeychainSerializerError) -> Data {
            encodeFloatCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Float {
            decodeFloatCalled = true
            return .init()
        }
        
        func encode(_ value: Double) throws(KeychainSerializerError) -> Data {
            encodeDoubleCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Double {
            decodeDoubleCalled = true
            return .init()
        }
        
        func encode(_ value: Bool) throws(KeychainSerializerError) -> Data {
            encodeBoolCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Bool {
            decodeBoolCalled = true
            return .init()
        }
        
        func encode(_ value: String) throws(KeychainSerializerError) -> Data {
            encodeStringCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> String {
            decodeStringCalled = true
            return .init()
        }
        
        func encode(_ value: Data) throws(KeychainSerializerError) -> Data {
            encodeDataCalled = true
            return .init()
        }
        
        func decode(_ data: Data) throws(KeychainSerializerError) -> Data {
            decodeDataCalled = true
            return .init()
        }
        
        func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T : Decodable, T : Encodable {
            encodeCodableCalled = true
            return .init()
        }
        
        func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T : Decodable, T : Encodable {
            decodeCodableCalled = true
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw .decodingFailure(
                    context: .init(
                        type: T.self,
                        underlyingError: KeyrmesKeychainSerializer.SerializerError.jsonConversionError(error: error)
                    )
                )
            }
        }
        
        func encode<T>(_ value: T) throws(KeychainSerializerError) -> Data where T: NSCoding, T: NSObject {
            encodeNSCodingCalled = true
            return .init()
        }
        
        func decode<T>(_ data: Data) throws(KeychainSerializerError) -> T where T: NSCoding, T: NSObject {
            decodeNSCodingCalled = true
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)!
            } catch {
                throw .decodingFailure(
                    context: .init(
                        type: T.self,
                        underlyingError: KeyrmesKeychainSerializer.SerializerError.unarchiverError(error: error)
                    )
                )
            }
        }
    }
}
