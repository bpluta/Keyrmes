//
//  ConstantExtractor.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

struct ConstantExtractor {
    let variableName: String
    var attributes: [AvailableAttributeExtractor]
    
    let allPlatforms: Set<Platform>
    
    init?(from variableDecalaration: VariableDeclSyntax, basePlatfom: Platform, allPlatforms: Set<Platform>) {
        guard let variableName = variableDecalaration.variableName else { return nil }
        
        self.variableName = variableName
        let extractedAttributes = variableDecalaration.attributes.compactMap { attribute in
            AvailableAttributeExtractor(attribute: attribute)
        }
        self.allPlatforms = allPlatforms
        if extractedAttributes.isEmpty {
            self.attributes = [
                AvailableAttributeExtractor(
                    platform: basePlatfom,
                    introduced: nil,
                    deprecated: nil,
                    message: nil
                )
            ]
        } else {
            self.attributes = extractedAttributes
        }
    }
    
    mutating func merge(with newValue: Self) {
        assert(newValue.variableName == variableName)
        attributes.append(contentsOf: newValue.attributes)
    }
    
    var enumCaseStatement: EnumCaseDeclSyntax {
        EnumCaseDeclSyntax(
            attributes: AttributeListSyntax(
                availableAttributes.compactMap { attribute in
                    AttributeListSyntax.Element(attribute)
                }
            ),
            caseKeyword: .keyword(.case, trailingTrivia: .spaces(1)),
            elements: [
                EnumCaseElementSyntax(name: .identifier(exposedEnumCaseName))
            ],
            trailingTrivia: .newlines(2)
        )
    }
    
    private var availableAttributes: [AttributeSyntax] {
        var allAvailableAttributes: [AttributeSyntax] = []
        if let mergedAvailableAttribute {
            allAvailableAttributes.append(contentsOf: mergedAvailableAttribute)
        } else {
            allAvailableAttributes.append(contentsOf: filteredAttributes.map { attribute in
                attribute.toAttribute
            })
        }
        let allCoveredPlatforms = Set(attributes.compactMap(\.platform))
        var unavailablePlatforms: [AttributeSyntax] = []
        for platform in allPlatforms.subtracting(allCoveredPlatforms) {
            let unavailableAttribute = unavailableAttribute(platform: platform)
            unavailablePlatforms.append(unavailableAttribute)
        }
        allAvailableAttributes.append(contentsOf: unavailablePlatforms)
        return allAvailableAttributes
    }
    
    
    private var exposedEnumCaseName: String {
        var name = variableName
        name.replace(/^kSec/, with: "")
        name.replace(/Attr(?!ibute)/, with: "Attribute")
        name.replace(/Ref(?!erence)/, with: "Reference")
        name = name.prefix(1).lowercased() + name.dropFirst()
        
        if ["class"].contains(name) {
            return "`\(name)`"
        }
        return name
    }
    
    private var filteredAttributes: [AvailableAttributeExtractor] {
        attributes.compactMap { attribute in
            guard attribute.isSupportedByDefault else {
                return attribute
            }
            if attribute.isSimpleVersion {
                return nil
            } else {
                return AvailableAttributeExtractor(
                    platform: attribute.platform,
                    introduced: nil,
                    deprecated: attribute.deprecated,
                    message: attribute.message
                )
            }
        }
    }
    
    private var mergedAvailableAttribute: [AttributeSyntax]? {
        guard filteredAttributes.allSatisfy({ $0.isSimpleVersion }) else {
            return nil
        }
        guard !filteredAttributes.isEmpty else {
            return []
        }
        var allPlatforms = [AvailabilityArgumentSyntax]()
        allPlatforms = filteredAttributes.map { attribute in
            AvailabilityArgumentSyntax(
                argument: .availabilityVersionRestriction(
                    PlatformVersionSyntax(
                        platform: .identifier(attribute.platform.rawValue, trailingTrivia: .spaces(1)),
                        version: attribute.introduced?.versionTuple
                    )
                ),
                trailingComma: .commaToken(trailingTrivia: .spaces(1))
            )
        }
        allPlatforms.append(
            AvailabilityArgumentSyntax(
                argument: .availabilityVersionRestriction(
                    PlatformVersionSyntax(platform: .identifier("*"))
                )
            )
        )
        return [
            AttributeSyntax(
                atSign: .atSignToken(),
                attributeName: IdentifierTypeSyntax(name: .identifier("available")),
                leftParen: .leftParenToken(),
                arguments: .availability(
                    AvailabilityArgumentListSyntax(
                        allPlatforms
                    )
                ),
                rightParen: .rightParenToken(),
                trailingTrivia: .newline
            )
        ]
    }
    
    private func unavailableAttribute(platform: Platform) -> AttributeSyntax {
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
