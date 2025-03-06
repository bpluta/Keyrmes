//
//  KeychainStore.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

/// A protocol defining an actor-based secure storage interface for sensitive data.
public protocol SecureStorage: Actor {
    
    /// Reads an item from secure storage, returning it as `KeychainSerializable` if found.
    ///
    /// - Parameter identifier: A unique keychain identifier object.
    /// - Throws: Any error occurring during the read process.
    /// - Returns: The  specified`KeychainSerializable` implementing object  if available, otherwise `nil`.
    ///
    func read<ItemType: KeychainSerializable>(identifier: KeychainIdentifiable) throws -> ItemType?
    
    /// Stores or updates an item in secure storage with a given accessibility option.
    ///
    /// - Parameters:
    ///   - identifier: A unique keychain identifier object.
    ///   - value: The `KeychainSerializable` conforming object to be stored.
    ///   - accessibility: The desired keychain accessibility level.
    /// - Throws: Any error occurring during the write process.
    ///
    func set<ItemType: KeychainSerializable>(identifier: KeychainIdentifiable, to value: ItemType, accessibility: KeychainQueryKey.Accessibility) throws
    
    /// Deletes an item from secure storage, if it exists.
     
    /// - Parameter identifier: A unique keychain identifier object.
    /// - Throws: Any error occurring during the delete process.
    ///
    func delete(identifier: KeychainIdentifiable) async throws
    
    /// Wipes out all items from secure storage.
    ///
    /// - Throws: Any error occurring during the wipe process.
    ///
    func wipeOutStorage() throws
}


/// A storage solution providing convenience methods for Keychain CRUD operations.
public actor KeychainStore: SecureStorage {
    
    /// The Keychain access group.
    let accessGroup: String?
    
    /// The service attribute used to group keychain items.
    let attributeService: String?
    
    /// An object capable of encoding and decoding keychain-storable items.
    let serializer: KeychainSerializer
    
    /// Initializes a new `KeychainStore`.

    /// - Parameters:
    ///   - accessGroup: An optional access group for the keychain items.
    ///   - attributeService: The service attribute for the keychain items. Defaults to the app's bundle identifier.
    ///   - serializer: A serializer conforming to `KeychainSerializer`.
    ///
    public init(
        accessGroup: String? = nil,
        attributeService: String? = nil,
        serializer: KeychainSerializer = KeyrmesKeychainSerializer()
    ) {
        self.accessGroup = accessGroup
        self.serializer = serializer
        self.attributeService = attributeService
            ?? Bundle.main.bundleIdentifier
            ?? String(describing: type(of: self))
    }
    
    /// Attempts to read and decode a value from the keychain that was stored with the specified identifier.
    ///
    /// - Parameter identifier: An object providing a unique key for locating the stored item.
    /// - Throws: `KeychainStoreError` if decoding fails or any keychain issue arises during the read.
    /// - Returns: The decoded item of `ItemType`, or `nil` if has not been found
    ///
    public func read<ItemType: KeychainSerializable>(identifier: KeychainIdentifiable) throws(KeychainStoreError) -> ItemType? {
        let query = getReadQuery(identifier: identifier)
        guard let data = try readData(query: query) else { return nil }
        let value: ItemType = try decode(value: data)
        return value
    }
    
    /// Stores a value in the keychain for the provided identifier. If there already has been an entry at
    /// given identifier, this operation deletes it and overwrites it to the given value.
    ///
    /// - Parameters:
    ///   - identifier: A unique key used to identify the item in the keychain.
    ///   - value: The value to be stored, conforming to `KeychainSerializable` protocol.
    ///   - accessibility: A keychain accessibility setting, defining when the item can be accessed (e.g. after device unlock).
    /// - Throws: `KeychainStoreError` if serialization or any of performed keychain operation fails.
    ///
    public func set<ItemType: KeychainSerializable>(identifier: KeychainIdentifiable, to value: ItemType, accessibility: KeychainQueryKey.Accessibility) throws(KeychainStoreError) {
        let valueData = try encode(value: value)
        do {
            let query = getSetQuery(identifier: identifier, accessibility: accessibility, valueData: valueData)
            try set(query: query)
        } catch .storeOperationFailed(let status) where status == errSecDuplicateItem {
            try delete(identifier: identifier)
            let query = getSetQuery(identifier: identifier, accessibility: accessibility, valueData: valueData)
            try set(query: query)
        }
    }
    
    /// Removes an item from the keychain, if it exists, based on the provided identifier.
    ///
    /// - Parameter identifier: A unique key identifying the item to remove.
    /// - Throws: `KeychainStoreError` if the keychain deletion fails.
    ///
    public func delete(identifier: KeychainIdentifiable) throws(KeychainStoreError) {
        let query = getDeleteQuery(identifier: identifier)
        try delete(query: query)
    }
    
    /// Completely clears all stored items in this keychain storage by iterating through every supported item class
    /// and performing a delete operation on each of them.
    ///
    /// - Throws: `KeychainStoreError` if any of underlying delete operations fails
    ///
    public func wipeOutStorage() throws(KeychainStoreError) {
        for itemClass in KeychainQueryKey.ItemClass.allCases {
            let query = getWipeOutQuery(class: itemClass)
            try delete(query: query)
        }
    }
}

extension KeychainStore {
    
    /// Encodes a value into a raw `Data` object using the assigned `serializer`.
    ///
    /// - Parameter value: The `ItemType` to be serialized.
    /// - Throws: `KeychainStoreError.typeConversionFailure` if serialization fails.
    /// - Returns: A`Data` representation of the encoded `ItemType`.
    ///
    func encode<ItemType: KeychainSerializable>(value: ItemType) throws(KeychainStoreError) -> Data {
        do {
            return try ItemType.encode(value: value, using: serializer)
        } catch { throw .typeConversionFailure(error) }
    }
    
    /// Decodes a raw `Data` object back into the specified `ItemType` using the assigned `serializer`.
    ///
    /// - Parameter value: The `Data` to decode.
    /// - Throws: `KeychainStoreError.typeConversionFailure` if the data cannot be decoded into `ItemType`.
    /// - Returns: The decoded `ItemType`.
    ///
    func decode<ItemType: KeychainSerializable>(value: Data) throws(KeychainStoreError) -> ItemType {
        do {
            return try ItemType.decode(value: value, using: serializer)
        } catch { throw .typeConversionFailure(error) }
    }
    
    /// Reads raw `Data` from the keychain based on the provided query.
    /// Returns `nil` if no matching item was found, and throws an error if the result is not `Data`.
    ///
    /// - Parameter query: A query builder describing the keychain item to retrieve.
    /// - Throws: `KeychainStoreError.cannotExtractData` if a matching item is found but isn't valid `Data`.
    /// - Returns: The keychain item as `Data` or `nil` if it has not been found.
    ///
    func readData<Query>(query: consuming Query) throws(KeychainStoreError) -> Data? where Query: QueryBuildable, Query: ~Copyable {
        guard let result = try read(query: query)?.object else {
            return nil
        }
        guard let data = result as? Data else {
            throw .cannotExtractData
        }
        return data
    }
    
    /// Performs read operation in keychain using the provided query.
    /// Internally it is a wrapper for`SecItemCopyMatching`.
    ///
    /// - Parameter query: A query builder specifying keychain search criteria.
    /// - Throws: `KeychainStoreError.readOperationFailed` if the read operation fails unless the item has not been found
    /// - Returns: A `RawKeychainOutput`object wrapping an AnyObject value returned by the keychain query  or `nil` if no items have been found.
    ///
    public func read<Query>(query: consuming Query) throws(KeychainStoreError) -> RawKeychainOutput? where Query: QueryBuildable, Query: ~Copyable {
        let query = query.buildQuery()
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        switch status {
        case errSecItemNotFound:
            return nil
        case errSecSuccess, noErr:
            return RawKeychainOutput(result)
        default:
            throw .readOperationFailed(status)
        }
    }
    
    /// Performs update operation in  keychain, updating given attributes of matching items.
    /// Internally it is a wrapper for`SecItemUpdate`.
    ///
    /// - Parameters:
    ///   - matchQuery: A query builder specifying keychain search criteria.
    ///   - updateQuery: A query builder describing parameters to update
    /// - Throws: `KeychainStoreError.updateOperationFailed` if the update fails for any reason.
    ///
    public func update<MatchQuery, UpdateQuery>(matching matchQuery: consuming MatchQuery, to updateQuery: consuming UpdateQuery) throws(KeychainStoreError) where MatchQuery: QueryBuildable, MatchQuery: ~Copyable, UpdateQuery: QueryBuildable, UpdateQuery: ~Copyable {
        let matchQuery = matchQuery.buildQuery()
        let updateQuery = updateQuery.buildQuery()
        let status = SecItemUpdate(matchQuery, updateQuery)
        switch status {
        case errSecSuccess, noErr:
            return
        default:
            throw .updateOperationFailed(status)
        }
    }
    
    
    /// Executes delete operation in keychain using the provided query, removing matching items.
    /// Internally it is a wrapper for `SecItemDelete`.
    ///
    /// - Parameter query: A query builder describing which items to remove from the keychain.
    /// - Throws: `KeychainStoreError.deleteOperationFailed` if the delete operation fails unless the item has not been found
    ///
    public func delete<Query>(query: consuming Query) throws(KeychainStoreError) where Query: QueryBuildable, Query: ~Copyable {
        let query = query.buildQuery()
        let status = SecItemDelete(query)
        switch status {
        case errSecItemNotFound, errSecSuccess, noErr:
            return
        default:
            throw .deleteOperationFailed(status)
        }
    }
    
    /// Performs  add (store) operation in keychain with the given query..
    /// Internally it is a wrapper for `SecItemAdd`.
    ///
    /// - Parameter query: A query builder describing the keychain item to add.
    /// - Throws: `KeychainStoreError.storeOperationFailed` if the insertion fails for any reason.
    ///
    public func set<Query>(query: consuming Query) throws(KeychainStoreError) where Query: QueryBuildable, Query: ~Copyable {
        let query = query.buildQuery()
        let status = SecItemAdd(query, nil)
        switch status {
        case errSecSuccess, noErr:
            return
        default:
            throw .storeOperationFailed(status)
        }
    }
}

extension KeychainStore {
    private func baseQuery(for identifier: KeychainIdentifiable) -> KeychainQueryBuilder {
        KeychainQueryBuilder(accessGroup: accessGroup, attributeService: attributeService)
            .setting(identifier: identifier)
            .set(class: .genericPassword)
            .set(useDataProtectionKeychain: true)
    }
    
    private func getReadQuery(identifier: KeychainIdentifiable) -> KeychainQueryBuilder {
        baseQuery(for: identifier)
            .set(matchLimit: .one)
            .set(returnData: true)
    }
    
    private func getSetQuery(identifier: KeychainIdentifiable, accessibility: KeychainQueryKey.Accessibility, valueData: Data) -> KeychainQueryBuilder {
        baseQuery(for: identifier)
            .set(attributeAccessible: accessibility)
            .set(valueData: valueData)
    }
    
    private func getDeleteQuery(identifier: KeychainIdentifiable) -> KeychainQueryBuilder {
        baseQuery(for: identifier)
    }
    
    private func getWipeOutQuery(class keychainClass: KeychainQueryKey.ItemClass) -> KeychainQueryBuilder {
        KeychainQueryBuilder.emptyQuery()
            .set(useDataProtectionKeychain: true)
            .set(class: keychainClass)
    }
}

public struct RawKeychainOutput: @unchecked Sendable {
    public let object: AnyObject
    
    init?(_ object: AnyObject?) {
        guard let object else { return nil }
        self.object = object
    }
}

public enum KeychainStoreError: Error, CustomDebugStringConvertible {
    case typeConversionFailure(KeychainSerializerError)
    case cannotExtractData
    case storeOperationFailed(OSStatus)
    case updateOperationFailed(OSStatus)
    case readOperationFailed(OSStatus)
    case deleteOperationFailed(OSStatus)
    case wipeOutOperationFailed(OSStatus)
    
    public var debugDescription: String {
        switch self {
        case .typeConversionFailure(let error):
            return "Type conversion has failed: (\(error.debugDescription))"
        case .cannotExtractData:
            return "Failed to extract data from keychain query response"
        case .storeOperationFailed(let status):
            return "Store operation failed with error: (OSStatus \(status): \(status.message))"
        case .updateOperationFailed(let status):
            return "Update operation failed with error: (OSStatus \(status): \(status.message))"
        case .readOperationFailed(let status):
            return "Read operation failed with error: (OSStatus \(status): \(status.message))"
        case .deleteOperationFailed(let status):
            return "Delete operation failed with error: (OSStatus \(status): \(status.message))"
        case .wipeOutOperationFailed(let status):
            return "Wipe out operation failed with error: (OSStatus \(status): \(status.message))"
        }
    }
}
