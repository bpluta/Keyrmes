//
//  Sequence+Extensions.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Sequence where Iterator.Element: Equatable {
    func first<T: Equatable>(where keyPath: KeyPath<Iterator.Element, T>, equalTo searchedValue: T) -> Iterator.Element? {
        first(where: { element in
            element[keyPath: keyPath] == searchedValue
        })
    }
}
