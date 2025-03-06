//
//  KeyrmesSerializationBridgeTests.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Testing
import Foundation
@testable import Keyrmes

@Suite("KeyrmesSerializationBridgeTests")
struct KeyrmesSerializationBridgeTests {
    let serializer = KeychainSerializerStub()
    
    @Test func encodeIntTypeBridge() throws {
        let bridge = Int.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeIntCalled)
    }
    @Test func decodeIntTypeBridge() throws {
        let bridge = Int.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeIntCalled)
    }
    @Test func encodeUIntTypeBridge() throws {
        let bridge = UInt.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUIntCalled)
    }
    @Test func decodeUIntTypeBridge() throws {
        let bridge = UInt.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUIntCalled)
    }
    @Test func encodeInt8TypeBridge() throws {
        let bridge = Int8.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeInt8Called)
    }
    @Test func decodeInt8TypeBridge() throws {
        let bridge = Int8.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeInt8Called)
    }
    @Test func encodeUInt8TypeBridge() throws {
        let bridge = UInt8.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUInt8Called)
    }
    @Test func decodeUInt8TypeBridge() throws {
        let bridge = UInt8.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUInt8Called)
    }
    @Test func encodeInt16TypeBridge() throws {
        let bridge = Int16.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeInt16Called)
    }
    @Test func decodeInt16TypeBridge() throws {
        let bridge = Int16.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeInt16Called)
    }
    @Test func encodeUInt16TypeBridge() throws {
        let bridge = UInt16.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUInt16Called)
    }
    @Test func decodeUInt16TypeBridge() throws {
        let bridge = UInt16.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUInt16Called)
    }
    @Test func encodeInt32TypeBridge() throws {
        let bridge = Int32.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeInt32Called)
    }
    @Test func decodeInt32TypeBridge() throws {
        let bridge = Int32.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeInt32Called)
    }
    @Test func encodeUInt32TypeBridge() throws {
        let bridge = UInt32.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUInt32Called)
    }
    @Test func decodeUInt32TypeBridge() throws {
        let bridge = UInt32.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUInt32Called)
    }
    @Test func encodeInt64TypeBridge() throws {
        let bridge = Int64.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeInt64Called)
    }
    @Test func decodeInt64TypeBridge() throws {
        let bridge = Int64.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeInt64Called)
    }
    @Test func encodeUInt64TypeBridge() throws {
        let bridge = UInt64.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUInt64Called)
    }
    @Test func decodeUInt64TypeBridge() throws {
        let bridge = UInt64.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUInt64Called)
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func encodeInt128TypeBridge() throws {
        let bridge = Int128.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeInt128Called)
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func decodeInt128TypeBridge() throws {
        let bridge = Int128.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeInt128Called)
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func encodeUInt128TypeBridge() throws {
        let bridge = UInt128.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeUInt128Called)
    }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func decodeUInt128TypeBridge() throws {
        let bridge = UInt128.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeUInt128Called)
    }
    @Test func encodeFloatTypeBridge() throws {
        let bridge = Float.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeFloatCalled)
    }
    @Test func decodeFloatTypeBridge() throws {
        let bridge = Float.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeFloatCalled)
    }
    @Test func encodeDoubleTypeBridge() throws {
        let bridge = Double.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeDoubleCalled)
    }
    @Test func decodeDoubleTypeBridge() throws {
        let bridge = Double.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeDoubleCalled)
    }
    @Test func encodeBoolTypeBridge() throws {
        let bridge = Bool.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeBoolCalled)
    }
    @Test func decodeBoolTypeBridge() throws {
        let bridge = Bool.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeBoolCalled)
    }
    @Test func encodeStringTypeBridge() throws {
        let bridge = String.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeStringCalled)
    }
    @Test func decodeStringTypeBridge() throws {
        let bridge = String.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeStringCalled)
    }
    @Test func encodeDataTypeBridge() throws {
        let bridge = Data.self
        let _ = try bridge.encode(value: .init(), using: serializer)
        #expect(serializer.encodeDataCalled)
    }
    @Test func decodeDataTypeBridge() throws {
        let bridge = Data.self
        let _ = try bridge.decode(value: .init(), using: serializer)
        #expect(serializer.decodeDataCalled)
    }
    @Test func encodeCodableTypeBridge() throws {
        let bridge = KeyrmesKeychainSerializerTests.SomeCodable.self
        let _ = try bridge.encode(value: .init(first: 1, second: ""), using: serializer)
        #expect(serializer.encodeCodableCalled)
    }
    @Test func decodeCodableTypeBridge() throws {
        let bridge = KeyrmesKeychainSerializerTests.SomeCodable.self
        let object = bridge.init(first: 1, second: "")
        let data = try JSONEncoder().encode(object)
        let _ = try bridge.decode(value: data, using: serializer)
        #expect(serializer.decodeCodableCalled)
    }
    @Test func encodeNSCodingTypeBridge() throws {
        let bridge = KeyrmesKeychainSerializerTests.SomeNSCoding.self
        let _ = try bridge.encode(value: .init(first: 1, second: ""), using: serializer)
        #expect(serializer.encodeNSCodingCalled)
    }
    @Test func decodeNSCodingTypeBridge() throws {
        let bridge = KeyrmesKeychainSerializerTests.SomeNSCoding.self
        let object = KeyrmesKeychainSerializerTests.SomeNSCoding.init(first: 1, second: "")
        let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
        let _ = try bridge.decode(value: data, using: serializer)
        #expect(serializer.decodeNSCodingCalled)
    }
}
