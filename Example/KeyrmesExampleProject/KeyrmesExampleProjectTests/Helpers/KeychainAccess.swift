//
//  KeychainAccess.swift
//  KeyrmesExampleProject
//
//  Created by Bartłomiej Pluta
//

import Foundation
import Keyrmes

func writeToKeychain(key: String, value: Any, accessibility: CFString) throws {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "com.bart.KeyrmesExampleProject",
        kSecAttrGeneric as String: key,
        kSecAttrAccount as String: key,
        kSecValueData as String: value,
        kSecAttrAccessible as String: accessibility
    ]
    let status = SecItemAdd(query as NSDictionary, nil)
    guard status == errSecSuccess else {
        throw KeychainError.unknownError(status)
    }
}

func fetchFromKeychain(key: String) throws -> [String: Any] {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: "com.bart.KeyrmesExampleProject",
        kSecAttrGeneric as String: key,
        kSecAttrAccount as String: key,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ]
    var item: AnyObject?
    let status = SecItemCopyMatching(query as NSDictionary, &item)
    guard status != errSecItemNotFound else {
        throw KeychainError.notFound
    }
    guard status == errSecSuccess else {
        throw KeychainError.unknownError(status)
    }
    guard let keychainResponseDictionary = item as? [String: Any] else {
        throw KeychainError.couldNotExtractResponse
    }
    return keychainResponseDictionary
}

enum KeychainError: Error, Equatable {
    case couldNotExtractResponse
    case notFound
    case unknownError(OSStatus)
}

enum Key: String, KeychainIdentifiable {
    case someValue
    case secondaryValue
    case tertiaryValue
    case quaternaryValue
    case quinaryValue
    
    var keychainLabel: String { rawValue }
}
