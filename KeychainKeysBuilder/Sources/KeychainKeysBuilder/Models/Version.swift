//
//  Version.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct Version {
    let components: [Int]
    
    init(majorVersion: Int) {
        components = [majorVersion]
    }
}

extension Version: Hashable, Equatable, Comparable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.isLower(than: rhs)
    }
    
    static func <=(lhs: Self, rhs: Self) -> Bool {
        lhs.isLowerOrEqual(than: rhs)
    }
    
    static func >(lhs: Self, rhs: Self) -> Bool {
        lhs.isHigher(than: rhs)
    }
    
    static func >=(lhs: Self, rhs: Self) -> Bool {
        lhs.isHigherOrEqual(than: rhs)
    }
    
    func isHigher(than otherVersion: Version) -> Bool {
        for (lhs, rhs) in zip(components, otherVersion.components) {
            guard lhs != rhs else { continue }
            return lhs > rhs
        }
        if components.count > otherVersion.components.count {
            let suffix = components.suffix(components.count - otherVersion.components.count)
             return (suffix.first(where: { $0 != 0 }) ?? 0) > 0
        } else if otherVersion.components.count > components.count {
            let suffix = otherVersion.components.suffix(otherVersion.components.count - components.count)
            return (suffix.first(where: { $0 != 0 }) ?? 0) < 0
        } else {
            return false
        }
    }
    
    
    func isLower(than otherVersion: Version) -> Bool {
        for (lhs, rhs) in zip(components, otherVersion.components) {
            guard lhs != rhs else { continue }
            return lhs < rhs
        }
        if components.count > otherVersion.components.count {
            let suffix = components.suffix(components.count - otherVersion.components.count)
             return (suffix.first(where: { $0 != 0 }) ?? 0) < 0
        } else if otherVersion.components.count > components.count {
            let suffix = otherVersion.components.suffix(otherVersion.components.count - components.count)
            return (suffix.first(where: { $0 != 0 }) ?? 0) > 0
        } else {
            return false
        }
    }

    func isHigherOrEqual(than otherVersion: Version) -> Bool {
        guard isEqual(to: otherVersion) else {
            return isHigher(than: otherVersion)
        }
        return true
    }
    
    func isLowerOrEqual(than otherVersion: Version) -> Bool {
        guard isEqual(to: otherVersion) else {
            return isLower(than: otherVersion)
        }
        return true
    }
    
    func isEqual(to otherVersion: Version) -> Bool {
        components == otherVersion.components
    }
}
