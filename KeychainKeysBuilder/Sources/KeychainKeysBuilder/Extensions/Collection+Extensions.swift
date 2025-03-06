//
//  Collection+Extensions.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension Collection {
    subscript(ifPresent index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
