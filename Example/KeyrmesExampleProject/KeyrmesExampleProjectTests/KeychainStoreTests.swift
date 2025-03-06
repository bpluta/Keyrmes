//
//  KeychainStoreTests.swift
//  KeyrmesExampleProject
//
//  Created by Bartłomiej Pluta
//

import Testing
import Foundation
@testable import Keyrmes

@Suite("KeychainStoreTests")
class KeychainStoreTests {
    let storage = KeychainStore()
    
    deinit {
        let allClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        allClasses.forEach { itemClass in
            SecItemDelete([kSecClass: itemClass] as NSDictionary)
        }
    }
    
    @Test("Default initializer sets correct attributes")
    func testDefaultInitailizer() async throws {
        let storage = KeychainStore()
        let bundleIdentifier = Bundle.main.bundleIdentifier
        try #require(bundleIdentifier != nil)
        await #expect(storage.accessGroup == nil)
        await #expect(storage.attributeService == bundleIdentifier)
        await #expect(type(of: storage.serializer) == KeyrmesKeychainSerializer.self)
    }
    
    @Test("Custom initializer sets correct attributes")
    func testCustomInitailizer() async {
        let customSerializer = KeychainSerializerStub()
        let storage = KeychainStore(accessGroup: "lorem", attributeService: "ipsum", serializer: customSerializer)
        await #expect(storage.accessGroup == "lorem")
        await #expect(storage.attributeService == "ipsum")
        await #expect(type(of: storage.serializer) == KeychainSerializerStub.self)
    }
    
    @Test("Set operation stores properly given value in the keychain")
    func testSet() async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: storedValue, accessibility: .whenUnlocked)
        let response = try fetchFromKeychain(key: key.keychainLabel)
        
        let extractedData: Data = try response.get(key: kSecValueData)
        let extractedValue = Int.load(data: extractedData)
        #expect(extractedValue == storedValue)
    }
    
    @Test("Set & read operation sequence work properly one by one")
    func testSetAndRead() async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: storedValue, accessibility: .whenUnlocked)
        let retrievedValue: Int? = try await storage.read(identifier: key)
        
        #expect(retrievedValue == storedValue)
    }
    
    @Test("Checks if delete operation works properly when deleting value stored in keychain")
    func testSetAndDelete() async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: storedValue, accessibility: .whenUnlocked)
        
        let afterSetResponse = try fetchFromKeychain(key: key.keychainLabel)
        let _: Data = try afterSetResponse.get(key: kSecValueData)
        
        try await storage.delete(identifier: key)
        
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: key.keychainLabel)
        }
    }
    
    @Test("Read operation works properly when retreivng value stored in keychain")
    func testRead() async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        let serializedValue = try await storage.serializer.encode(storedValue)
        try writeToKeychain(key: key.keychainLabel, value: serializedValue, accessibility: kSecAttrAccessibleWhenUnlocked)
        let extractedValue: Int? = try await storage.read(identifier: key)
        
        #expect(extractedValue == storedValue)
    }
    
    @Test("Read operation returns nil when value is not present in keychain")
    func testReadNotPresent() async throws {
        let key = Key.someValue
        let retrievedValue: Int? = try await storage.read(identifier: key)
        #expect(retrievedValue == nil)
    }
    
    @Test("Reading fails when value is stored is not representable in a type that is being read")
    func testReadWrongType() async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        let serializedValue = try await storage.serializer.encode(storedValue)
        try writeToKeychain(key: key.keychainLabel, value: serializedValue, accessibility: kSecAttrAccessibleWhenUnlocked)
        
        try await #require(throws: KeychainStoreError.self) {
            let _: String? = try await storage.read(identifier: key)
        }
    }
    
    @Test("Previous value gets correctly overwritten when storing a new value with the same key")
    func testDoubleStore() async throws {
        let firstValue: Int = 123456
        let secondValue: Int = 654321
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: firstValue, accessibility: .whenUnlocked)
        try await storage.set(identifier: key, to: secondValue, accessibility: .whenUnlocked)
        
        let retrievedValue: Int? = try await storage.read(identifier: key)
        #expect(retrievedValue == secondValue)
    }
    
    @Test("Previous value gets correctly overwritten when storing a new value with the same key, even if accessibility differs")
    func testDoubleStoreWithDifferentAccessibility() async throws {
        let firstValue: Int = 123456
        let secondValue: Int = 654321
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: firstValue, accessibility: .whenUnlockedThisDeviceOnly)
        try await storage.set(identifier: key, to: secondValue, accessibility: .afterFirstUnlock)
        
        let retrievedValue: Int? = try await storage.read(identifier: key)
        #expect(retrievedValue == secondValue)
    }
    
    @Test("All stored values get removed with wipeOutStorage operation")
    func testWipeout() async throws {
        let firstValue: Int = 123456
        let secondValue: Int = 654321
        let thirdValue: String = "Hello World!"
        let fourthValue: Bool = true
        let fifthValue: Double = 0.12356789
        
        try await storage.set(identifier: Key.someValue, to: firstValue, accessibility: .whenUnlocked)
        try await storage.set(identifier: Key.secondaryValue, to: secondValue, accessibility: .whenUnlocked)
        try await storage.set(identifier: Key.tertiaryValue, to: thirdValue, accessibility: .whenUnlocked)
        try await storage.set(identifier: Key.quaternaryValue, to: fourthValue, accessibility: .whenUnlocked)
        try await storage.set(identifier: Key.quinaryValue, to: fifthValue, accessibility: .whenUnlocked)
        
        try await storage.wipeOutStorage()
        
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: Key.someValue.keychainLabel)
        }
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: Key.secondaryValue.keychainLabel)
        }
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: Key.tertiaryValue.keychainLabel)
        }
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: Key.quaternaryValue.keychainLabel)
        }
        try #require(throws: KeychainError.notFound) {
            try fetchFromKeychain(key: Key.quinaryValue.keychainLabel)
        }
    }
    
    @Test("Set operation uses correct accessibility constraints", arguments: [
        (.whenUnlocked, kSecAttrAccessibleWhenUnlocked),
        (.afterFirstUnlock, kSecAttrAccessibleAfterFirstUnlock),
        (.whenPasscodeSetThisDeviceOnly, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly),
        (.whenUnlockedThisDeviceOnly, kSecAttrAccessibleWhenUnlockedThisDeviceOnly),
        (.afterFirstUnlockThisDeviceOnly, kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
    ] as [(KeychainQueryKey.Accessibility, CFString)])
    func testSetWithAccessibility(
        _ writtenAccessiblity: KeychainQueryKey.Accessibility,
        _ readAccessibility: CFString
    ) async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        try await storage.set(identifier: key, to: storedValue, accessibility: writtenAccessiblity)
        let response = try fetchFromKeychain(key: key.keychainLabel)
        
        let responseAccessibility: CFString = try response.get(key: kSecAttrAccessible)
        #expect(responseAccessibility == readAccessibility)
    }
    
    @Test("Read operation uses correct accessibility constraints", arguments: [
        (kSecAttrAccessibleWhenUnlocked, .whenUnlocked),
        (kSecAttrAccessibleAfterFirstUnlock, .afterFirstUnlock),
        (kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .whenPasscodeSetThisDeviceOnly),
        (kSecAttrAccessibleWhenUnlockedThisDeviceOnly, .whenUnlockedThisDeviceOnly),
        (kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, .afterFirstUnlockThisDeviceOnly)
    ] as [(CFString, KeychainQueryKey.Accessibility)])
    func testReadWithAccesibility(
        _ writtenAccessiblity: CFString,
        _ readAccessibility: KeychainQueryKey.Accessibility
    ) async throws {
        let storedValue: Int = 123456
        let key = Key.someValue
        
        let serializedValue = try await storage.serializer.encode(storedValue)
        try writeToKeychain(key: key.keychainLabel, value: serializedValue, accessibility: writtenAccessiblity)
        
        let returnedValue: Int? = try await storage.read(identifier: key)
        #expect(returnedValue == storedValue)
    }
}
