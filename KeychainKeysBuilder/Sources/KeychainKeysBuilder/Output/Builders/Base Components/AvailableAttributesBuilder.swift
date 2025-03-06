//
//  AvailableAttributesBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct AvailableAttributesBuilder {
    let availability: [PlatformAvailability]
    let supportedPlatforms: [PlatformAvailability]
    
    func build() -> [AttributeSyntax] {
        var allAvailableAttributes: [AttributeSyntax] = []
        if let mergedPlatforms {
            allAvailableAttributes.append(contentsOf: mergedPlatforms)
        } else {
            allAvailableAttributes.append(contentsOf: allArgumentsList)
        }
        let allCoveredPlatforms = Set(availability.map(\.platform))
        let allSupportedPlatforms = Set(supportedPlatforms.map(\.platform))
        var unavailablePlatforms: [AttributeSyntax] = []
        for platform in allSupportedPlatforms.subtracting(allCoveredPlatforms) {
            let unavailableAttribute = unavailableAttribute(for: platform)
            unavailablePlatforms.append(unavailableAttribute)
        }
        allAvailableAttributes.append(contentsOf: unavailablePlatforms)
        return allAvailableAttributes
    }
    
    private var allArgumentsList: [AttributeSyntax] {
        availability
            .compactMap { availability -> [AvailabilityArgumentSyntax]? in
                guard let availabilityArguments = availability.availabilityArguments else { return nil }
                return availabilityArguments
                    .map { argument in
                        AvailabilityArgumentSyntax(argument: argument)
                    }.map { argument in
                        var argument = argument
                        argument.trailingComma = .commaToken()
                        argument.trailingTrivia = .spaces(1)
                        return argument
                    }.mapLast { argument in
                        var argument = argument
                        argument.trailingComma = nil
                        argument.trailingTrivia = .spaces(0)
                        return argument
                    }
            }.map { arguments in
                AttributeSyntax(
                    atSign: .atSignToken(),
                    attributeName: IdentifierTypeSyntax(name: .identifier("available")),
                    leftParen: .leftParenToken(),
                    arguments: .availability(AvailabilityArgumentListSyntax(arguments)),
                    rightParen: .rightParenToken(),
                    trailingTrivia: .newline
                )
            }
    }
    
    private var areAllSupportedPlatformsCovered: Bool {
        let allCoveredPlatforms = Set(availability.map(\.platform))
        let allSupportedPlatforms = Set(supportedPlatforms.map(\.platform))
        let areAllSupportedPlatformsCovered = allCoveredPlatforms == allSupportedPlatforms
        return areAllSupportedPlatformsCovered
    }
    
    private var arePlatformsAvailableAlwaysWithoutConstraints: Bool {
        availability.allSatisfy { availability in
            if case .always(let deprecated) = availability.availability {
                return deprecated == nil
            } else {
                return false
            }
        }
    }
    
    private var mergedPlatforms: [AttributeSyntax]? {
        guard arePlatformsAvailableAlwaysWithoutConstraints else { return nil }
        guard !availability.isEmpty, !areAllSupportedPlatformsCovered else {
            return []
        }
        let allDefinedPlatformsArguments = availability.map { attribute in
            AvailabilityArgumentSyntax(
                argument: .availabilityVersionRestriction(
                    PlatformVersionSyntax(
                        platform: .identifier(attribute.platform.rawValue, trailingTrivia: .spaces(1)),
                        version: attribute.availability.introduced?.versionTuple
                    )
                ),
                trailingComma: .commaToken(trailingTrivia: .spaces(1))
            )
        }.mapLast { attribute in
            var attribute = attribute
            if case .availabilityVersionRestriction(let platformSettings) = attribute.argument {
                attribute.argument = .availabilityVersionRestriction(
                    PlatformVersionSyntax(
                        platform: .identifier(platformSettings.platform.trimmedDescription),
                        version: platformSettings.version?.with(\.leadingTrivia, .space)
                    )
                )
            }
            return attribute
        }
        let allOtherPlatformsArgument = AvailabilityArgumentSyntax(
            argument: .availabilityVersionRestriction(
                PlatformVersionSyntax(platform: .identifier("*"))
            )
        )
        return [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: .identifier("available")),
                leftParen: .leftParenToken(),
                arguments: .availability(
                    AvailabilityArgumentListSyntax(
                        allDefinedPlatformsArguments + [allOtherPlatformsArgument]
                    )
                ),
                rightParen: .rightParenToken(),
                trailingTrivia: .newline
            )
        ]
    }
    
    private func unavailableAttribute(for platform: Platform) -> AttributeSyntax {
        AttributeSyntax(
            atSign: .atSignToken(),
            attributeName: IdentifierTypeSyntax(name: .identifier("available")),
            leftParen: .leftParenToken(),
            arguments: .availability([
                .init(
                    argument: .availabilityVersionRestriction(.init(platform: .identifier(platform.rawValue))),
                    trailingComma: .commaToken(),
                    trailingTrivia: .spaces(1)
                ),
                .init(
                    argument: .availabilityVersionRestriction(.init(platform: .identifier("unavailable"))),
                    trailingComma: nil,
                    trailingTrivia: .spaces(0)
                 )
            ]),
            rightParen: .rightParenToken(),
            trailingTrivia: .newline
        )
    }
}
