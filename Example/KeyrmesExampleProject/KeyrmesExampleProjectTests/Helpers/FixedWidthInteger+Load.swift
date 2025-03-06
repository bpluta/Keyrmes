//
//  FixedWidthInteger+Load.swift
//  KeyrmesExampleProject
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension FixedWidthInteger {
    static func load(data: Data) -> Self {
        data.withUnsafeBytes { rawBuffer in
            rawBuffer.load(as: Self.self)
        }
    }
}
