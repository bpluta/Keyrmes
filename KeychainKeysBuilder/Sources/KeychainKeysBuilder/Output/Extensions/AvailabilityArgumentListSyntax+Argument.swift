//
//  AvailabilityArgumentListSyntax+Argument.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

extension AvailabilityArgumentListSyntax {
    func argument(labeled matchingKeyword: Keyword) -> AvailabilityLabeledArgumentSyntax? {
        map(\.argument)
        .compactMap { argument in
            AvailabilityLabeledArgumentSyntax(argument)
        }.compactMap { argument -> AvailabilityLabeledArgumentSyntax? in
            guard case .keyword(let keyword) = argument.label.tokenKind else {
                return nil
            }
            guard keyword == matchingKeyword else {
                return nil
            }
            return argument
        }.first
    }
    
    var platformVersionArgument: PlatformVersionSyntax? {
        compactMap { argument in
            PlatformVersionSyntax(argument.argument)
        }.first
    }
    
    var platformName: Platform? {
        guard let platformIdentifier = platformVersionArgument?.platform.trimmedDescription ?? first?.argument.trimmedDescription else {
            return nil
        }
        return Platform(rawValue: platformIdentifier)
    }
    
    var introducedVersion: Version? {
        let versionTuple: VersionTupleSyntax
        if let platformArgument = platformVersionArgument,
           let platformVersion = platformArgument.version {
            versionTuple = platformVersion
        } else if let labeledArgument = argument(labeled: .introduced),
                  let labeledVersionTuple = VersionTupleSyntax(labeledArgument.value) {
            versionTuple = labeledVersionTuple
        } else {
            return nil
        }
        let version = Version(from: versionTuple)
        return version
    }
    
    var deprecatedVersion: Version? {
        guard let labeledArgument = argument(labeled: .deprecated),
              let labeledVersionTuple = VersionTupleSyntax(labeledArgument.value)
        else {
            return nil
        }
        let version = Version(from: labeledVersionTuple)
        return version
    }
    
    var message: String? {
        guard let labeledArgument = argument(labeled: .message) else { return nil }
        guard let stringExpression = SimpleStringLiteralExprSyntax(labeledArgument.value) else {
            return nil
        }
        return stringExpression.segments.map(\.trimmedDescription).joined(separator: "")
    }
}
