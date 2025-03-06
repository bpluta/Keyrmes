//
//  SystemVersionAvailabilityExpressionBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct SystemVersionAvailabilityExpressionBuilder {
    let leadingTrivia: Trivia
    let cases: [CaseDeclaration]
    let supportedPlatforms: [PlatformAvailability]
    let content: (PlatformAvailability) -> CodeBlockItemListSyntax
    
    func build() -> IfConfigDeclSyntax {
        IfSystemConfigBuilder(
            leadingTrivia: leadingTrivia,
            uniquePlatforms: uniquePlatforms,
            elementsProvider: { platform in
                IfAvailableVersionBuilder(
                    leadingTrivia: .tabs(1).appending(leadingTrivia),
                    platform: platform,
                    uniquePlatformSettings: getUniquePlatformSettings(for: platform),
                    supportedPlatforms: supportedPlatforms,
                    content: content
                ).build()
            }
        ).build()
    }
    
    private var uniquePlatforms: [Platform] {
        cases
            .flatMap(\.availability)
            .filter { item in
                guard case .never = item.availability else { return true }
                return false
            }.map(\.platform)
            .unique()
    }
    
    private func getUniquePlatformSettings(for platform: Platform) -> [PlatformAvailability] {
        guard let supportedPlatformConstraints = supportedPlatforms.first(
            where: \.platform,
            equalTo: platform
        ) else { return [] }
        let uniquePlatformSettings = cases
            .flatMap { caseItem in
                caseItem.flattenAvailability(supportedPlatforms: supportedPlatforms)
            }.filter { item in
                item.platform == platform && item.availability != .never
            }.compactMap { item in
                guard case .always = item.availability else { return item }
                return PlatformAvailability(
                    platform: item.platform,
                    availability: supportedPlatformConstraints.availability,
                    message: item.message
                )
            }.unique()
        let sortedPlatformSettings = uniquePlatformSettings.sorted(by: { first, second in
            switch (first.availability, second.availability) {
            case (.always, _):
                return false
            case (_, .always):
                return true
            case (.since(let firstVersion, _), .since(let secondVersion, _)):
                return firstVersion.isHigher(than: secondVersion)
            default:
                return false
            }
        })
        return sortedPlatformSettings
    }
}
