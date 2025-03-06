//
//  KeyrmesKeychainSerializerTests.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Testing
import Foundation
@testable import Keyrmes

@Suite("KeyrmesKeychainSerializer")
struct KeyrmesKeychainSerializerTests {
    let serializer = KeyrmesKeychainSerializer()
    
    // MARK: - Int
    @Test func testIntBidirectionalSerialization() async throws {
        typealias TestedType = Int
        let value: TestedType = -123456
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testIntEncoding() async throws {
        typealias TestedType = Int
        let value: TestedType = -123456
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xC0, 0x1D, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        #expect(encodedData == expectedData)
    }
    
    @Test func testIntDecoding() async throws {
        typealias TestedType = Int
        let data = Data([0xC0, 0x1D, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -123456
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt
    @Test func testUIntBidirectionalSerialization() async throws {
        typealias TestedType = UInt
        let value: TestedType = 123456
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testUIntEncoding() async throws {
        typealias TestedType = UInt
        let value: TestedType = 123456
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x40, 0xE2, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00])
        #expect(encodedData == expectedData)
    }
    
    @Test func testUIntDecoding() async throws {
        typealias TestedType = UInt
        let data = Data([0x40, 0xE2, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 123456
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Int8
    @Test func testInt8BidirectionalSerialization() async throws {
        typealias TestedType = Int8
        let value: TestedType = -123
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testInt8Encoding() async throws {
        typealias TestedType = Int8
        let value: TestedType = -123
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x85])
        #expect(encodedData == expectedData)
    }
    
    @Test func testInt8Decoding() async throws {
        typealias TestedType = Int8
        let data = Data([0x85])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -123
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt8
    @Test func testUInt8BidirectionalSerialization() async throws {
        typealias TestedType = UInt8
        let value: TestedType = 123
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testUInt8Encoding() async throws {
        typealias TestedType = UInt8
        let value: TestedType = 123
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x7B])
        #expect(encodedData == expectedData)
    }
    
    @Test func testUInt8Decoding() async throws {
        typealias TestedType = UInt8
        let data = Data([0x7B])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 123
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Int16
    @Test func testInt16BidirectionalSerialization() async throws {
        typealias TestedType = Int16
        let value: TestedType = -12345
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testInt16Encoding() async throws {
        typealias TestedType = Int16
        let value: TestedType = -12345
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xC7, 0xCF])
        #expect(encodedData == expectedData)
    }
    
    @Test func testInt16Decoding() async throws {
        typealias TestedType = Int16
        let data = Data([0xC7, 0xCF])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -12345
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt16
    @Test func testUInt16BidirectionalSerialization() async throws {
        typealias TestedType = UInt16
        let value: TestedType = 12345
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testUInt16Encoding() async throws {
        typealias TestedType = UInt16
        let value: TestedType = 12345
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x39, 0x30])
        #expect(encodedData == expectedData)
    }
    
    @Test func testUInt16Decoding() async throws {
        typealias TestedType = UInt16
        let data = Data([0x39, 0x30])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 12345
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Int32
    @Test func testInt32BidirectionalSerialization() async throws {
        typealias TestedType = Int32
        let value: TestedType = -123456
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testInt32Encoding() async throws {
        typealias TestedType = Int32
        let value: TestedType = -123456
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xC0, 0x1D, 0xFE, 0xFF])
        #expect(encodedData == expectedData)
    }
    
    @Test func testInt32Decoding() async throws {
        typealias TestedType = Int32
        let data = Data([0xC0, 0x1D, 0xFE, 0xFF])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -123456
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt32
    @Test func testUInt32BidirectionalSerialization() async throws {
        typealias TestedType = UInt32
        let value: TestedType = 123456
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testUInt32Encoding() async throws {
        typealias TestedType = UInt32
        let value: TestedType = 123456
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x40, 0xE2, 0x01, 0x00])
        #expect(encodedData == expectedData)
    }
    
    @Test func testUInt32Decoding() async throws {
        typealias TestedType = UInt32
        let data = Data([0x40, 0xE2, 0x01, 0x00])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 123456
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Int64
    @Test func testInt64BidirectionalSerialization() async throws {
        typealias TestedType = Int64
        let value: TestedType = -1234567890123456789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testInt64Encoding() async throws {
        typealias TestedType = Int64
        let value: TestedType = -1234567890123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xEB, 0x7E, 0x16, 0x82, 0x0B, 0xEF, 0xDD, 0xEE])
        #expect(encodedData == expectedData)
    }
    
    @Test func testInt64Decoding() async throws {
        typealias TestedType = Int64
        let data = Data([0xEB, 0x7E, 0x16, 0x82, 0x0B, 0xEF, 0xDD, 0xEE])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -1234567890123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt64
    @Test func testUInt64BidirectionalSerialization() async throws {
        typealias TestedType = UInt64
        let value: TestedType = 1234567890123456789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testUInt64Encoding() async throws {
        typealias TestedType = UInt64
        let value: TestedType = 1234567890123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x15, 0x81, 0xE9, 0x7D, 0xF4, 0x10, 0x22, 0x11])
        #expect(encodedData == expectedData)
    }
    
    @Test func testUInt64Decoding() async throws {
        typealias TestedType = UInt64
        let data = Data([0x15, 0x81, 0xE9, 0x7D, 0xF4, 0x10, 0x22, 0x11])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 1234567890123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Int128
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testInt128BidirectionalSerialization() async throws {
        typealias TestedType = Int128
        let value: TestedType = -12345678901234567890123456789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testInt128Encoding() async throws {
        typealias TestedType = Int128
        let value: TestedType = -12345678901234567890123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xEB, 0x7E, 0xC6, 0x91, 0x4E, 0x36, 0x41, 0xB9, 0xCD, 0xE4, 0x1B, 0xD8, 0xFF, 0xFF, 0xFF, 0xFF])
        #expect(encodedData == expectedData)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testInt128Decoding() async throws {
        typealias TestedType = Int128
        let data = Data([0xEB, 0x7E, 0xC6, 0x91, 0x4E, 0x36, 0x41, 0xB9, 0xCD, 0xE4, 0x1B, 0xD8, 0xFF, 0xFF, 0xFF, 0xFF])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = -12345678901234567890123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - UInt128
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testUInt128BidirectionalSerialization() async throws {
        typealias TestedType = UInt128
        let value: TestedType = 12345678901234567890123456789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testUInt128Encoding() async throws {
        typealias TestedType = UInt128
        let value: TestedType = 12345678901234567890123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x15, 0x81, 0x39, 0x6E, 0xB1, 0xC9, 0xBE, 0x46, 0x32, 0x1B, 0xE4, 0x27, 0x00, 0x00, 0x00, 0x00])
        #expect(encodedData == expectedData)
    }
    
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @Test func testUInt128Decoding() async throws {
        typealias TestedType = UInt128
        let data = Data([0x15, 0x81, 0x39, 0x6E, 0xB1, 0xC9, 0xBE, 0x46, 0x32, 0x1B, 0xE4, 0x27, 0x00, 0x00, 0x00, 0x00])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 12345678901234567890123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Float
    @Test func testFloatBidirectionalSerialization() async throws {
        typealias TestedType = Float
        let value: TestedType = 0.123456789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testFloatEncoding() async throws {
        typealias TestedType = Float
        let value: TestedType = 0.123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0xEA, 0xD6, 0xFC, 0x3D])
        #expect(encodedData == expectedData)
    }
    
    @Test func testFloatDecoding() async throws {
        typealias TestedType = Float
        let data = Data([0xEA, 0xD6, 0xFC, 0x3D])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 0.123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Double
    @Test func testDoubleBidirectionalSerialization() async throws {
        typealias TestedType = Float
        let value: TestedType = 0.12345789
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testDoubleEncoding() async throws {
        typealias TestedType = Double
        let value: TestedType = 0.123456789
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x5F, 0x63, 0x39, 0x37, 0xDD, 0x9A, 0xBF, 0x3F])
        #expect(encodedData == expectedData)
    }
    
    @Test func testDoubleDecoding() async throws {
        typealias TestedType = Double
        let data = Data([0x5F, 0x63, 0x39, 0x37, 0xDD, 0x9A, 0xBF, 0x3F])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = 0.123456789
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Bool
    @Test func testBoolTrueBidirectionalSerialization() async throws {
        typealias TestedType = Bool
        let value: TestedType = true
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testBoolTrueEncoding() async throws {
        typealias TestedType = Bool
        let value: TestedType = true
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x1])
        #expect(encodedData == expectedData)
    }
    
    @Test func testBoolTrueDecoding() async throws {
        typealias TestedType = Bool
        let data = Data([0x1])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = true
        #expect(decodedValue == expectedValue)
    }
    
    @Test func testBoolFalseBidirectionalSerialization() async throws {
        typealias TestedType = Bool
        let value: TestedType = false
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testBoolFalseEncoding() async throws {
        typealias TestedType = Bool
        let value: TestedType = false
        let encodedData = try serializer.encode(value)
        let expectedData = Data([0x0])
        #expect(encodedData == expectedData)
    }
    
    @Test func testBoolFalseDecoding() async throws {
        typealias TestedType = Bool
        let data = Data([0x0])
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = false
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Data
    @Test func testDataBidirectionalSerialization() async throws {
        typealias TestedType = Data
        let value: TestedType = "Hello world".data(using: .utf8)!
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testDataEncoding() async throws {
        typealias TestedType = Data
        let value: TestedType = "Hello world".data(using: .utf8)!
        let encodedData = try serializer.encode(value)
        let expectedData = value
        #expect(encodedData == expectedData)
    }
    
    @Test func testDataDecoding() async throws {
        typealias TestedType = Data
        let data = "Hello world".data(using: .utf8)!
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = data
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - String
    @Test func testStringBidirectionalSerialization() async throws {
        typealias TestedType = String
        let value: TestedType = "Hello world"
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testStringEncoding() async throws {
        typealias TestedType = String
        let value: TestedType = "Hello world"
        let encodedData = try serializer.encode(value)
        let expectedData = value.data(using: .utf8)!
        #expect(encodedData == expectedData)
    }
    
    @Test func testStringDecoding() async throws {
        typealias TestedType = String
        let data = "Hello world".data(using: .utf8)!
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = "Hello world"
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - Codable
    @Test func testCodableBidirectionalSerialization() async throws {
        typealias TestedType = SomeCodable
        let value: TestedType = .init(first: 123456, second: "Hello world")
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
    
    @Test func testCodableEncoding() async throws {
        typealias TestedType = SomeCodable
        let value: TestedType = .init(first: 123456, second: "Hello world")
        let encodedData = try serializer.encode(value)
        let expectedData = "{\"first\":123456,\"second\":\"Hello world\"}".data(using: .utf8)!
        #expect(encodedData == expectedData)
    }
    
    @Test func testCodableDecoding() async throws {
        typealias TestedType = SomeCodable
        let data = "{\"first\":123456,\"second\":\"Hello world\"}".data(using: .utf8)!
        let decodedValue: TestedType = try serializer.decode(data)
        let expectedValue: TestedType = .init(first: 123456, second: "Hello world")
        #expect(decodedValue == expectedValue)
    }
    
    // MARK: - NSCoding
    @Test func testNSCodingBidirectionalSerialization() async throws {
        typealias TestedType = SomeNSCoding
        let value: TestedType = .init(first: 123456, second: "Hello world")
        let encodedData = try serializer.encode(value)
        let decodedValue: TestedType = try serializer.decode(encodedData)
        #expect(value == decodedValue)
    }
}

// MARK: - Helper types
extension KeyrmesKeychainSerializerTests {
    struct SomeCodable: Codable, Equatable, KeychainSerializable {
        let first: Int
        let second: String
    }
    
    @objc(SomeNSCoding)
    class SomeNSCoding: NSObject, NSSecureCoding, KeychainSerializable {
        let first: Int
        let second: String
        
        nonisolated(unsafe) static var supportsSecureCoding: Bool = true
        
        init(first: Int, second: String) {
            self.first = first
            self.second = second
        }
        
        required init?(coder: NSCoder) {
            let firstValue = coder.decodeInteger(forKey: "first")
            guard let secondValue = coder.decodeObject(of: NSString.self, forKey: "second") as? String else { return nil }
            first = firstValue
            second = secondValue
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(first, forKey: "first")
            coder.encode(second, forKey: "second")
        }
        
        static func ==(lhs: SomeNSCoding, rhs: SomeNSCoding) -> Bool {
            lhs.first == rhs.first && lhs.second == rhs.second
        }
    }
}
