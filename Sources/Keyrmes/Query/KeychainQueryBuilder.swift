//
//  KeychainQueryBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import KeyrmesMacros
import LocalAuthentication

/// A flexible builder for constructing dictionary-based keychain queries.
/// Use this struct to configure various keychain query attributes and build the query
/// into a `NSDictionary` that can be directly used with keychain APIs from `Security.framework`.
///
/// Typically, you chain multiple `.set(propertyName: value)` calls to customize the query
/// before building it, allowing you to selectively add or override attributes for different operations.
///
/// - Note: Only the non-nil values end up in the output dictionary. `Nil` values are skipped.
///
/// - Note: This builder covers only a subset of avaiblable keychain query keys. If you need
/// to use a any other attribute which has not been covered by this implementation, you would
/// need to create your own custom builder that conforms to `QueryBuildable` protocol.
///
@QueryBuilder
public struct KeychainQueryBuilder: ~Copyable, @unchecked Sendable, QueryBuildable {
    
    @QuerySettable
    var matchLimit: KeychainQueryKey.MatchLimit?
    @QuerySettable
    var `class`: KeychainQueryKey.ItemClass?
    @QuerySettable
    var useDataProtectionKeychain: Bool?
    
    @QuerySettable
    var valueData: Data?
    @QuerySettable
    var valueReference: KeychainQueryKey.ReferenceValue?
    
    @QuerySettable
    var attributeAccessible: KeychainQueryKey.Accessibility?
    @QuerySettable
    var attributeService: String?
    @QuerySettable
    var attributeGeneric: KeychainIdentifiable?
    @QuerySettable
    var attributeAccount: KeychainIdentifiable?
    @QuerySettable
    var attributeAccessGroup: String?
    @QuerySettable
    var attributeApplicationLabel: String?
    @QuerySettable
    var attributeKeyType: KeychainQueryKey.KeyType?
    @QuerySettable
    var attributeKeyClass: KeychainQueryKey.KeyClass?
    
    @QuerySettable
    var returnAttributes: Bool?
    @QuerySettable
    var returnData: Bool?
    @QuerySettable
    var returnReference: Bool?
    @QuerySettable
    var returnPersistentReference: Bool?
    
    @QuerySettable
    var attributeAccessControl: SecAccessControl?
    @QuerySettable
    var useAuthenticationContext: LAContext?
    @QuerySettable
    var useAuthenticationUI: KeychainQueryKey.AuthenticationUISettings?
    @QuerySettable
    var attributeTokenID: KeychainQueryKey.AttibuteToken?
    @QuerySettable("toid")
    var tokenId: Data?
    
    static public func emptyQuery() -> Self { Self() }
    
    public init() { }
    
    public init(accessGroup: String?, attributeService: String?) {
        self.attributeAccessGroup = accessGroup
        self.attributeService = attributeService
    }
    
    @discardableResult
    consuming func setting(identifier: KeychainIdentifiable?) -> Self {
        self
            .set(attributeGeneric: identifier)
            .set(attributeAccount: identifier)
    }
}
