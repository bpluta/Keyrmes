//
//  PlatformAvailability.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct PlatformAvailability {
    let platform: Platform
    let availability: VersionAvailability
    let message: String?
    
    init(platform: Platform, availability: VersionAvailability, message: String?) {
        self.platform = platform
        self.availability = availability
        self.message = message
    }
    
    init(platform: Platform) {
        self.platform = platform
        self.availability = .since(
            version: platform.minimalSupportedVersion,
            deprecated: nil
        )
        self.message = nil
    }
    
    init(platform: Platform, minimalMajorVersion: Int) {
        self.platform = platform
        self.availability = .since(
            version: Version(majorVersion: minimalMajorVersion),
            deprecated: nil
        )
        self.message = nil
    }
    
    init(platform: Platform, minimalVersion: Version) {
        self.platform = platform
        self.availability = .since(
            version: minimalVersion,
            deprecated: nil
        )
        self.message = nil
    }
}

extension PlatformAvailability: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(platform)
        hasher.combine(availability)
        hasher.combine(message)
    }
    
    static func == (lhs: PlatformAvailability, rhs: PlatformAvailability) -> Bool {
        lhs.platform == rhs.platform && lhs.availability == rhs.availability && lhs.message == rhs.message
    }
}
