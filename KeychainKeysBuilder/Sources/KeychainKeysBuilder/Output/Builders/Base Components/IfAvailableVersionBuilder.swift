//
//  IfAvailableVersionBuilder.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct IfAvailableVersionBuilder {
    let leadingTrivia: Trivia
    let platform: Platform
    let uniquePlatformSettings: [PlatformAvailability]
    let supportedPlatforms: [PlatformAvailability]
    let content: (PlatformAvailability) -> CodeBlockItemListSyntax
    
    func build() -> CodeBlockItemListSyntax {
        var mainComponent: IfExprSyntax?
        for availability in groupAvailability(for: platform) {
            switch availability {
            case .ifExpr(let expression):
                if mainComponent == nil {
                    mainComponent = expression.with(\.leadingTrivia, leadingTrivia)
                } else {
                    mainComponent?.elseKeyword = .keyword(.else, leadingTrivia: .space, trailingTrivia: .space)
                    mainComponent?.elseBody = .ifExpr(expression)
                }
            case .codeBlock(let codeBlock):
                if mainComponent == nil {
                    return codeBlock.statements
                } else {
                    mainComponent?.elseKeyword = .keyword(.else, leadingTrivia: .space)
                    mainComponent?.elseBody = .codeBlock(codeBlock)
                    break
                }
            }
        }
        guard let mainComponent else { return [] }
        return [
            CodeBlockItemSyntax(item: CodeBlockItemSyntax.Item(mainComponent))
        ]
    }
    
    func groupAvailability(for platform: Platform) -> [IfExprSyntax.ElseBody] {
        var expressions: [IfExprSyntax.ElseBody] = []
        let uniquePlatformSettings = uniquePlatformSettings
            .reduce(into: [IfPlatformAvailability](), { result, currentItem in
                guard let currentPlatformSettings = IfPlatformAvailability(platformAvailability: currentItem),
                      !result.contains(where: { $0 == currentPlatformSettings })
                else { return }
                result.append(currentPlatformSettings)
            }).sorted(by: { itemA, itemB in
                switch (itemA.availability, itemB.availability) {
                case (.always, _):
                    return false
                case (_, .always):
                    return true
                case (.since(let versionA), .since(let versionB)):
                    return versionA.isHigher(than: versionB)
                }
            })
        for platformSettings in uniquePlatformSettings {
            let content = content(
                PlatformAvailability(
                    platform: platformSettings.platform,
                    availability: VersionAvailability(from: platformSettings.availability),
                    message: nil
                )
            )
            expressions.append(
                getVersionAvailability(
                    platform: platform,
                    version: platformSettings.availability,
                    content: content
                )
            )
        }
        return expressions
    }
    
    func getVersionAvailability(platform: Platform, version: IfAvailability, content: CodeBlockItemListSyntax) -> IfExprSyntax.ElseBody {
        switch version {
        case .since(let version):
            if let platformSettings = supportedPlatforms.first(where: \.platform, equalTo: platform),
               case .since(let constraintVersion, _) = platformSettings.availability,
               version.isLowerOrEqual(than: constraintVersion)
            { fallthrough }
            return .ifExpr(IfExprSyntax(
                ifKeyword: .keyword(.if),
                conditions: [
                    ConditionElementSyntax(
                        leadingTrivia: .space,
                        condition: .availability(
                            AvailabilityConditionSyntax(
                                availabilityKeyword: .poundAvailableToken(),
                                leftParen: .leftParenToken(),
                                availabilityArguments: [
                                    AvailabilityArgumentSyntax(
                                        argument: .availabilityVersionRestriction(
                                            PlatformVersionSyntax(
                                                platform: .identifier(platform.rawValue, trailingTrivia: .space),
                                                version: version.versionTuple
                                            )
                                        ),
                                        trailingComma: .commaToken(),
                                        trailingTrivia: .space
                                    ),
                                    AvailabilityArgumentSyntax(argument: .token(.binaryOperator("*")))
                                ],
                                rightParen: .rightParenToken()
                            )
                        )
                    )
                ],
                body: CodeBlockSyntax(
                    leadingTrivia: .space,
                    leftBrace: .leftBraceToken(trailingTrivia: .newline),
                    statements: content,
                    rightBrace: .rightBraceToken(leadingTrivia: .newline.appending(leadingTrivia))
                )
            ))
        case .always:
            return .codeBlock(CodeBlockSyntax(
                leadingTrivia: .space,
                leftBrace: .leftBraceToken(trailingTrivia: .newline),
                statements: content,
                rightBrace: .rightBraceToken(leadingTrivia: .newline.appending(leadingTrivia))
            ))
        }
    }
}

fileprivate extension VersionAvailability {
    init(from availability: IfAvailableVersionBuilder.IfAvailability) {
        switch availability {
        case .always:
            self = .always(deprecated: nil)
        case .since(let version):
            self = .since(version: version, deprecated: nil)
        }
    }
}

extension IfAvailableVersionBuilder {
    struct IfPlatformAvailability: Hashable {
        let platform: Platform
        let availability: IfAvailability
        
        init?(platformAvailability: PlatformAvailability) {
            self.platform = platformAvailability.platform
            switch platformAvailability.availability {
            case .always(deprecated: _):
                self.availability = .always
            case .since(version: let version, deprecated: _):
                self.availability = .since(version)
            default:
                return nil
            }
        }
    }
    
    enum IfAvailability: Hashable {
        case always
        case since(Version)
    }
}
