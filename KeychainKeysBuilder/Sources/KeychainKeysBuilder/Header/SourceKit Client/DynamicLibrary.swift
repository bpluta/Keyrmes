//
//  DynamicLibrary.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct DynamicLibrary {
    let handle: UnsafeMutableRawPointer

    func load<T>(symbol: String) -> T {
        guard let symbol = dlsym(handle, symbol) else {
            logger.error("Failed to load symbol: \(symbol, privacy: .public)")
            fatalError("Failed to load symbol: \(symbol)")
        }
        return unsafeBitCast(symbol, to: T.self)
    }
}
