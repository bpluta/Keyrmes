//
//  VersionAvailability.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

enum VersionAvailability: Hashable {
    case always(deprecated: Version?)
    case since(version: Version, deprecated: Version?)
    case never
    
    var introduced: Version? {
        guard case .since(let introduced, _) = self else { return nil }
        return introduced
    }
    
    var deprecated: Version? {
        switch self {
        case .always(let deprecated):
            return deprecated
        case .since(_, let deprecated):
            return deprecated
        case .never:
            return nil
        }
    }
}
