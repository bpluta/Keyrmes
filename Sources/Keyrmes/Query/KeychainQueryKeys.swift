//
//  KeychainQueryKeys.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension KeychainQueryKey {
    public enum MatchLimit: KeychainQueryKeyRepresentable, CaseIterable, Sendable {
        case one
        case all
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .one:
                .matchLimitOne
            case .all:
                .matchLimitAll
            }
        }
    }
    
    public enum ItemClass: KeychainQueryKeyRepresentable, CaseIterable, Sendable {
        case internetPassword
        case genericPassword
        case certificate
        case key
        case identity
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .internetPassword:
                .classInternetPassword
            case .genericPassword:
                .classGenericPassword
            case .certificate:
                .classCertificate
            case .key:
                .classKey
            case .identity:
                .classIdentity
            }
        }
    }
    
    public enum Accessibility: KeychainQueryKeyRepresentable, Sendable {
        case whenUnlocked
        case afterFirstUnlock
        case whenPasscodeSetThisDeviceOnly
        case whenUnlockedThisDeviceOnly
        case afterFirstUnlockThisDeviceOnly
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .whenUnlocked:
                .attributeAccessibleWhenUnlocked
            case .afterFirstUnlock:
                .attributeAccessibleAfterFirstUnlock
            case .whenPasscodeSetThisDeviceOnly:
                .attributeAccessibleWhenPasscodeSetThisDeviceOnly
            case .whenUnlockedThisDeviceOnly:
                .attributeAccessibleWhenUnlockedThisDeviceOnly
            case .afterFirstUnlockThisDeviceOnly:
                .attributeAccessibleAfterFirstUnlockThisDeviceOnly
            }
        }
    }
    
    public enum KeyType: KeychainQueryKeyRepresentable, Sendable {
        case RSA
        case EC
        case ECSECPrimeRandom
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .RSA:
                .attributeKeyTypeRSA
            case .EC:
                .attributeKeyTypeEC
            case .ECSECPrimeRandom:
                .attributeKeyTypeECSECPrimeRandom
            }
        }
    }
    
    public enum KeyClass: KeychainQueryKeyRepresentable, Sendable {
        case `public`
        case `private`
        case symmetric
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .public:
                .attributeKeyClassPublic
            case .private:
                .attributeKeyClassPrivate
            case .symmetric:
                .attributeKeyClassSymmetric
            }
        }
    }
    
    public enum AttibuteToken: KeychainQueryKeyRepresentable, Sendable {
        case secureEnclave
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .secureEnclave:
                .attributeTokenIDSecureEnclave
            }
        }
    }
    
    public enum AuthenticationUISettings: KeychainQueryKeyRepresentable, Sendable {
        case skip
        
        public var queryKey: KeychainQueryKey {
            switch self {
            case .skip:
                .useAuthenticationUISkip
            }
        }
    }
    
    public enum ReferenceValue: @unchecked Sendable {
        case key(SecKey)
        case certificate(SecCertificate)
        case identity(SecIdentity)
    }
}
