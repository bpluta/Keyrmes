//
//  KeychainQueryBuilderTests.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Testing
@preconcurrency import Foundation
@preconcurrency import Security
@preconcurrency import LocalAuthentication
@testable import Keyrmes

@Suite("Test keychain query builder")
struct KeychainQueryBuilderTests {
    @Test("Match limit query", arguments: [
        (encodedValue: .one, expectedValue: kSecMatchLimitOne),
        (encodedValue: .all, expectedValue: kSecMatchLimitAll)
    ] as [(KeychainQueryKey.MatchLimit, CFString)])
    func testMatchLimitQuery(encodedValue: KeychainQueryKey.MatchLimit, expectedValue: CFString) async throws {
        let builder = KeychainQueryBuilder()
            .set(matchLimit: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecMatchLimit: expectedValue])
    }
    
    @Test("Class query", arguments: [
        (encodedValue: .genericPassword, expectedValue: kSecClassGenericPassword),
        (encodedValue: .internetPassword, expectedValue: kSecClassInternetPassword),
        (encodedValue: .certificate, expectedValue: kSecClassCertificate),
        (encodedValue: .key, expectedValue: kSecClassKey),
        (encodedValue: .identity, expectedValue: kSecClassIdentity),
    ] as [(KeychainQueryKey.ItemClass, CFString)])
    func testClassQuery(encodedValue: KeychainQueryKey.ItemClass, expectedValue: CFString) async throws {
        let builder = KeychainQueryBuilder()
            .set(class: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecClass: expectedValue])
    }
    
    @Test("Use data protection query", arguments: [
        (encodedValue: true, expectedValue: kCFBooleanTrue),
        (encodedValue: false, expectedValue: kCFBooleanFalse)
    ])
    func testUseDataProtectionKeychainQuery(encodedValue: Bool, expectedValue: CFBoolean) async throws {
        let builder = KeychainQueryBuilder()
            .set(useDataProtectionKeychain: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFBoolean]
        #expect(result == [kSecUseDataProtectionKeychain: expectedValue])
    }
    
    @Test("Value data query")
    func testValueDataQuery() async throws {
        let value = "Hello world".data(using: .utf8)!
        let builder = KeychainQueryBuilder()
            .set(valueData: value)
        let result = builder.buildQuery() as! [CFString: Data]
        #expect(result == [kSecValueData: value])
    }
    
    @Test("Attribute accessibility query", arguments: [
        (encodedValue: .whenPasscodeSetThisDeviceOnly, expectedValue: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly),
        (encodedValue: .whenUnlockedThisDeviceOnly, expectedValue: kSecAttrAccessibleWhenUnlockedThisDeviceOnly),
        (encodedValue: .whenUnlocked, expectedValue: kSecAttrAccessibleWhenUnlocked),
        (encodedValue: .afterFirstUnlockThisDeviceOnly, expectedValue: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly),
        (encodedValue: .afterFirstUnlock, expectedValue: kSecAttrAccessibleAfterFirstUnlock),
    ] as [(KeychainQueryKey.Accessibility, CFString)])
    func testAttributeAccessibleQuery(encodedValue: KeychainQueryKey.Accessibility, expectedValue: CFString) async throws {
        let builder = KeychainQueryBuilder()
            .set(attributeAccessible: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrAccessible: expectedValue])
    }
    
    @Test("Attribute service query")
    func testAttributeServiceQuery() async throws {
        let value = "Hello world"
        let expectedValue = value.data(using: .utf8)!
        let builder = KeychainQueryBuilder()
            .set(attributeService: value)
        let result = builder.buildQuery() as! [CFString: Data]
        #expect(result == [kSecAttrService: expectedValue])
    }
    
    @Test("Attribute generic query")
    func testAttributeGenericQuery() async throws {
        let value = MockKeychainIdentifier(keychainLabel: "Hello world")
        let expectedValue = value.keychainLabel as CFString
        let builder = KeychainQueryBuilder()
            .set(attributeGeneric: value)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrGeneric: expectedValue])
    }
    
    @Test("Attribute account query")
    func testAttributeAccountQuery() async throws {
        let value = MockKeychainIdentifier(keychainLabel: "Hello world")
        let expectedValue = value.keychainLabel as CFString
        let builder = KeychainQueryBuilder()
            .set(attributeAccount: value)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrAccount: expectedValue])
    }
    
    @Test("Attribute access group query")
    func testAttributeAccessGroupQuery() async throws {
        let value = "Hello world"
        let expectedValue = value.data(using: .utf8)!
        let builder = KeychainQueryBuilder()
            .set(attributeAccessGroup: value)
        let result = builder.buildQuery() as! [CFString: Data]
        #expect(result == [kSecAttrAccessGroup: expectedValue])
    }
    
    @Test("Attribute application label query")
    func testAttributeApplicationLabelQuery() async throws {
        let value = "Hello world"
        let expectedValue = value.data(using: .utf8)!
        let builder = KeychainQueryBuilder()
            .set(attributeApplicationLabel: value)
        let result = builder.buildQuery() as! [CFString: Data]
        #expect(result == [kSecAttrApplicationLabel: expectedValue])
    }
    
    @Test("Attribute token ID query")
    func testAttributeTokenIdQuery() async throws {
        let value = KeychainQueryKey.AttibuteToken.secureEnclave
        let builder = KeychainQueryBuilder()
            .set(attributeTokenID: value)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrTokenID: kSecAttrTokenIDSecureEnclave])
    }
    
    @Test("Token ID query")
    func testTokenIdQuery() async throws {
        let value = "Hello world".data(using: .utf8)!
        let builder = KeychainQueryBuilder()
            .set(tokenId: value)
        let result = builder.buildQuery() as! [CFString: Data]
        #expect(result == ["toid" as CFString: value])
    }
    
    @Test("Attribute key type query", arguments: [
        (encodedValue: .ECSECPrimeRandom, expectedValue: kSecAttrKeyTypeECSECPrimeRandom),
        (encodedValue: .EC, expectedValue: kSecAttrKeyTypeEC),
        (encodedValue: .RSA, expectedValue: kSecAttrKeyTypeRSA)
    ] as [(KeychainQueryKey.KeyType, CFString)])
    func testAttributeKeyTypeQuery(encodedValue: KeychainQueryKey.KeyType, expectedValue: CFString) async throws {
        let builder = KeychainQueryBuilder()
            .set(attributeKeyType: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrKeyType: expectedValue])
    }
    
    @Test("Attribute key class query", arguments: [
        (encodedValue: .public, expectedValue: kSecAttrKeyClassPublic),
        (encodedValue: .private, expectedValue: kSecAttrKeyClassPrivate),
        (encodedValue: .symmetric, expectedValue: kSecAttrKeyClassSymmetric),
    ] as [(KeychainQueryKey.KeyClass, CFString)])
    func testAttributeKeyClassQuery(encodedValue: KeychainQueryKey.KeyClass, expectedValue: CFString) async throws {
        let builder = KeychainQueryBuilder()
            .set(attributeKeyClass: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFString]
        #expect(result == [kSecAttrKeyClass: expectedValue])
    }
    
    @Test("Authentication context query")
    func testLocalAuthenticationContextQuery() async throws {
        let context = LAContext()
        let builder = KeychainQueryBuilder()
            .set(useAuthenticationContext: context)
        let result = builder.buildQuery() as! [CFString: LAContext]
        #expect(result == [kSecUseAuthenticationContext: context])
    }
    
    @Test("Return attributes query", arguments: [
        (encodedValue: true, expectedValue: kCFBooleanTrue),
        (encodedValue: false, expectedValue: kCFBooleanFalse)
    ])
    func testReturnAttributesQuery(encodedValue: Bool, expectedValue: CFBoolean) async throws {
        let builder = KeychainQueryBuilder()
            .set(returnAttributes: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFBoolean]
        #expect(result == [kSecReturnAttributes: expectedValue])
    }
    
    @Test("Return data query", arguments: [
        (encodedValue: true, expectedValue: kCFBooleanTrue),
        (encodedValue: false, expectedValue: kCFBooleanFalse)
    ])
    func testReturnData(encodedValue: Bool, expectedValue: CFBoolean) async throws {
        let builder = KeychainQueryBuilder()
            .set(returnData: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFBoolean]
        #expect(result == [kSecReturnData: expectedValue])
    }
    
    @Test("Return reference query", arguments: [
        (encodedValue: true, expectedValue: kCFBooleanTrue),
        (encodedValue: false, expectedValue: kCFBooleanFalse)
    ])
    func testReturnReference(encodedValue: Bool, expectedValue: CFBoolean) async throws {
        let builder = KeychainQueryBuilder()
            .set(returnReference: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFBoolean]
        #expect(result == [kSecReturnRef: expectedValue])
    }
    
    @Test("Return persistent reference query", arguments: [
        (encodedValue: true, expectedValue: kCFBooleanTrue),
        (encodedValue: false, expectedValue: kCFBooleanFalse)
    ])
    func testReturnPersistentReference(encodedValue: Bool, expectedValue: CFBoolean) async throws {
        let builder = KeychainQueryBuilder()
            .set(returnPersistentReference: encodedValue)
        let result = builder.buildQuery() as! [CFString: CFBoolean]
        #expect(result == [kSecReturnPersistentRef: expectedValue])
    }
}

extension KeychainQueryBuilderTests {
    struct MockKeychainIdentifier: KeychainIdentifiable {
        let keychainLabel: String
    }
}
