//
//  Version+VersionTuple.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SwiftSyntax

extension Version {
    init?(from versionTuple: VersionTupleSyntax) {
        guard let majorVersion = Int(versionTuple.major.trimmedDescription) else {
            return nil
        }
        let minorComponents = versionTuple.components.compactMap { item -> Int? in
            guard let component = Int(item.number.trimmedDescription) else { return nil }
            return component
        }
        components = [majorVersion] + minorComponents
    }
    
    var versionTuple: VersionTupleSyntax? {
        guard let majorElement = components.first else { return nil }
        let minorElements = components.dropFirst()
        let major = TokenSyntax.identifier(majorElement.description)
        let components = VersionComponentListSyntax(minorElements.map { element in
            VersionComponentSyntax(number: .identifier(element.description))
        })
        return VersionTupleSyntax(
            major: major,
            components: components
        )
    }
}
