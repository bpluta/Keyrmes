//
//  Dictionary+Get.swift
//  KeyrmesExampleProject
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    @discardableResult
    func get<T>(key: CFString) throws(DictionaryError) -> T {
        guard let someValue = self[key as String] else {
            throw .couldNotExtractValue
        }
        guard let value = someValue as? T else {
            throw .couldNotCastValueType
        }
        return value
    }
}

enum DictionaryError: Error {
    case couldNotExtractValue
    case couldNotCastValueType
}
