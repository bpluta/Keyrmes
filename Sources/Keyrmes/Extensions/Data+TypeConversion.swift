//
//  Data+TypeConversion.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension Data {
    init<T>(from value: T) {
        self = Swift.withUnsafeBytes(of: value) { rawBuffer in
            Data(rawBuffer)
        }
    }
    
    func load<T>(as type: T.Type) -> T? {
        withUnsafeBytes { rawBuffer in
            rawBuffer.load(as: type)
        }
    }
}
