//
//  AvailableAttributeExtractor.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct AvailableAttributeExtractor {
    let platform: Platform
    let introduced: Version?
    let deprecated: Version?
    let message: String?
    
    init(platform: Platform, introduced: Version?, deprecated: Version?, message: String?) {
        self.platform = platform
        self.introduced = introduced
        self.deprecated = deprecated
        self.message = message
    }
    
    init?(attribute: AttributeListSyntax.Element) {
        guard let attribute = attribute.as(AttributeSyntax.self) else { return nil }
        
        let name = attribute.attributeName.trimmedDescription
        guard name == "available" else { return nil }
        
        let arguments = attribute.arguments?.as(AvailabilityArgumentListSyntax.self) ?? []
        guard let extractedPlatform = arguments.platformName else { return nil }
        
        platform = extractedPlatform
        introduced = arguments.introducedVersion
        deprecated = arguments.deprecatedVersion
        message = arguments.message
    }
    
    var isSimpleVersion: Bool {
        deprecated == nil && message == nil
    }
    
    var toAttribute: AttributeSyntax {
        var arguments = [AvailabilityArgumentSyntax]()
        arguments.append(.init(argument: .availabilityVersionRestriction(
            PlatformVersionSyntax(platform: .identifier(platform.rawValue))
        )))
        if let introduced = introduced?.versionTuple {
            arguments.append(.init(argument: .availabilityLabeledArgument(
                AvailabilityLabeledArgumentSyntax(
                    label: .identifier("introduced"),
                    colon: .colonToken(trailingTrivia: .spaces(1)),
                    value: .version(introduced)
                )
            )))
        }
        if let deprecated = deprecated?.versionTuple {
            arguments.append(.init(argument: .availabilityLabeledArgument(
                AvailabilityLabeledArgumentSyntax(
                    label: .identifier("deprecated"),
                    colon: .colonToken(trailingTrivia: .spaces(1)),
                    value: .version(deprecated)
                )
            )))
        }
        if let message {
            arguments.append(.init(argument: .availabilityLabeledArgument(
                AvailabilityLabeledArgumentSyntax(
                    label: .identifier("message"),
                    colon: .colonToken(trailingTrivia: .spaces(1)),
                    value: .string(.init(
                        openingQuote: .stringQuoteToken(),
                        segments: [
                            .init(content: .identifier(process(stringWithLegacyNaming: message)))
                        ],
                        closingQuote: .stringQuoteToken()
                    ))
                )
            )))
        }
        arguments = arguments
            .map { argument in
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
        return AttributeSyntax(
            atSign: .atSignToken(),
            attributeName: IdentifierTypeSyntax(name: .identifier("available")),
            leftParen: .leftParenToken(),
            arguments: .availability(AvailabilityArgumentListSyntax(arguments)),
            rightParen: .rightParenToken(),
            trailingTrivia: .newline
        )
    }
    
    private func process(stringWithLegacyNaming: String) -> String {
        var processedString = stringWithLegacyNaming
        for matches in stringWithLegacyNaming.matches(of: /kSec\w+/).reversed() {
            var newNaming = String(stringWithLegacyNaming[matches.startIndex..<matches.endIndex])
            newNaming = modernize(legacyName: newNaming)
            processedString.replaceSubrange(matches.range, with: newNaming)
        }
        return processedString
    }
    
    private func modernize(legacyName: String) -> String {
        var name = legacyName
        name.replace(/^kSec/, with: "")
        name.replace(/Attr(?!ibute)/, with: "Attribute")
        name.replace(/Ref(?!erence)/, with: "Reference")
        name = name.prefix(1).lowercased() + name.dropFirst()
        return name
    }
    
    var isSupportedByDefault: Bool {
        guard let introduced else { return true }
        let minimalSupportedVersion = platform.minimalSupportedVersion
        return minimalSupportedVersion.isHigherOrEqual(than: introduced)
    }
}
