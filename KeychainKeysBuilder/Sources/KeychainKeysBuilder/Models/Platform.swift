//
//  Platform.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

enum Platform: String, CaseIterable {
    case iOS
    case macOS
    case watchOS
    case tvOS
    case visionOS
    
    var minimalSupportedVersion: Version {
        switch self {
        case .iOS:
            return Version(majorVersion: 16)
        case .macOS:
            return Version(majorVersion: 13)
        case .watchOS:
            return Version(majorVersion: 9)
        case .tvOS:
            return Version(majorVersion: 16)
        case .visionOS:
            return Version(majorVersion: 1)
        }
    }
}
