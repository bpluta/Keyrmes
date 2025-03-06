//
//  CaseDeclaration.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct CaseDeclaration {
    let caseIdentifier: String
    let attributeReference: String
    let availability: [PlatformAvailability]
    
    init(caseIdentifier: String, attributeReference: String, availability: [PlatformAvailability]) {
        self.caseIdentifier = caseIdentifier
        self.attributeReference = attributeReference
        self.availability = availability
    }
    
    func merging(with other: CaseDeclaration) -> CaseDeclaration? {
        guard caseIdentifier == other.caseIdentifier,
              attributeReference == other.attributeReference
        else { return nil }
        return CaseDeclaration(
            caseIdentifier: caseIdentifier,
            attributeReference: attributeReference,
            availability: availability + other.availability
        )
    }
    
    func flattenAvailability(supportedPlatforms: [PlatformAvailability]) -> [PlatformAvailability] {
        availability.compactMap { platformAvailability in
            flattenAvailability(of: platformAvailability, supportedPlatforms: supportedPlatforms)
        }
    }
    
    private func flattenAvailability(of platformAvailability: PlatformAvailability, supportedPlatforms: [PlatformAvailability]) -> PlatformAvailability? {
        guard isSupportedByDefault(platformAvailability, supportedPlatforms: supportedPlatforms) else {
            return platformAvailability
        }
        if case .always(let deprecated) = platformAvailability.availability, deprecated == nil {
            return nil
        } else {
            return PlatformAvailability(
                platform: platformAvailability.platform,
                availability: .always(deprecated: platformAvailability.availability.deprecated),
                message: platformAvailability.message
            )
        }
    }

    private func isSupportedByDefault(_ platformAvailability: PlatformAvailability, supportedPlatforms: [PlatformAvailability]) -> Bool {
        guard let supportedPlatform = supportedPlatforms.first(
            where: \.platform,
            equalTo: platformAvailability.platform
        ) else { return false }
        let minSupportedVersion: Version
        switch supportedPlatform.availability {
        case .always(deprecated: _):
            return true
        case .never:
            return false
        case .since(version: let introduced, deprecated: _):
            minSupportedVersion = introduced
        }
        switch platformAvailability.availability {
        case .always(deprecated: _):
            return true
        case .never:
            return false
        case .since(version: let introduced, deprecated: _):
            return minSupportedVersion.isHigherOrEqual(than: introduced)
        }
    }
}
