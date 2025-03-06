//
//  PlatformAvailability+Arguments.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

extension PlatformAvailability {
    init?(from attribute: AttributeListSyntax.Element, nameProcessor: NameProcessable?) {
        guard let attribute = attribute.as(AttributeSyntax.self) else {
            return nil
        }
        let name = attribute.attributeName.trimmedDescription
        guard name == "available" else {
            return nil
        }
        let arguments = attribute.arguments?.as(AvailabilityArgumentListSyntax.self) ?? []
        guard let extractedPlatform = arguments.platformName else {
            return nil
        }
        platform = extractedPlatform
        if let introduced = arguments.introducedVersion {
            availability = .since(version: introduced, deprecated: arguments.deprecatedVersion)
        } else {
            availability = .always(deprecated: arguments.deprecatedVersion)
        }
        message = if let nameProcessor, let extractedMessage = arguments.message {
            extractedMessage
                .matches(of: /kSec\w+/)
                .reversed()
                .reduce(into: extractedMessage, { result, match in
                    var newNaming = String(extractedMessage[match.startIndex..<match.endIndex])
                    newNaming = nameProcessor.process(name: newNaming)
                    result.replaceSubrange(match.range, with: newNaming)
                })
        } else {
            arguments.message
        }
    }
    
    var availabilityArguments: [AvailabilityArgumentSyntax.Argument]? {
        switch availability {
        case .always(let deprecated):
            guard deprecated != nil else { return nil }
            return buildArgumentList(additionalArguments: [
                deprecatedArgument,
                messageArgument
            ])
        case .since(_, _):
            return buildArgumentList(additionalArguments: [
                introducedArgument,
                deprecatedArgument,
                messageArgument
            ])
        case .never:
            return buildArgumentList(additionalArguments: [
                unavailableArgument
            ])
        }
    }
    
    var platformArgument: AvailabilityArgumentSyntax.Argument? {
        .availabilityVersionRestriction(
            PlatformVersionSyntax(platform: .identifier(platform.rawValue))
        )
    }
    
    var introducedArgument: AvailabilityArgumentSyntax.Argument? {
        guard case .since(let introduced, _) = availability,
              let introducedVersion = introduced.versionTuple
        else { return nil }
        return .availabilityLabeledArgument(
            AvailabilityLabeledArgumentSyntax(
                label: .identifier("introduced"),
                colon: .colonToken(trailingTrivia: .spaces(1)),
                value: .version(introducedVersion)
            )
        )
    }
    
    var deprecatedArgument: AvailabilityArgumentSyntax.Argument? {
        let deprecatedVersion: VersionTupleSyntax?
        switch availability {
        case .always(let deprecated):
            deprecatedVersion = deprecated?.versionTuple
        case .since(_, let deprecated):
            deprecatedVersion = deprecated?.versionTuple
        default: return nil
        }
        guard let deprecatedVersion else { return nil }
        return .availabilityLabeledArgument(
            AvailabilityLabeledArgumentSyntax(
                label: .identifier("deprecated"),
                colon: .colonToken(trailingTrivia: .spaces(1)),
                value: .version(deprecatedVersion)
            )
        )
    }
    
    var messageArgument: AvailabilityArgumentSyntax.Argument? {
        guard let message else { return nil }
        return .availabilityLabeledArgument(
            AvailabilityLabeledArgumentSyntax(
                label: .identifier("message"),
                colon: .colonToken(trailingTrivia: .spaces(1)),
                value: .string(.init(
                    openingQuote: .stringQuoteToken(),
                    segments: [
                        .init(content: .identifier(message))
                    ],
                    closingQuote: .stringQuoteToken()
                ))
            )
        )
    }
    
    var unavailableArgument: AvailabilityArgumentSyntax.Argument? {
        .availabilityVersionRestriction(.init(platform: .identifier("unavailable")))
    }
}

extension PlatformAvailability {
    private func buildArgumentList(additionalArguments: [AvailabilityArgumentSyntax.Argument?]) -> [AvailabilityArgumentSyntax.Argument]? {
        let additionalArguments = additionalArguments.compactMap { $0 }
        guard let platformArgument else { return nil }
        return [platformArgument] + additionalArguments
    }
}
