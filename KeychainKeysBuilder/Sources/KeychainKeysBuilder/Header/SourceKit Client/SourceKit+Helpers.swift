//
//  SourceKit+Helpers.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SourceKitTypes

enum SourceKitResponseValue {
    indirect case array([SourceKitResponseValue])
    indirect case dictionary([String: SourceKitResponseValue])
    indirect case string(String)
    indirect case integer(Int64)
    indirect case boolean(Bool)
    indirect case uid(String)
    case null
}

enum SourceKitValueType: UInt8 {
    case null = 0
    case dictionary = 1
    case array = 2
    case integer = 3
    case string = 4
    case uid = 5
    case boolean = 6
    
    init?(from object: sourcekitd_variant_t) {
        let type = sourcekitd_variant_get_type(object)
        self.init(rawValue: type)
    }
}

enum SourceKitResponseErrorType: UInt8 {
    case connectionInterrupted = 1
    case invalidRequest = 2
    case requestFailed = 3
    case requestcancelled = 4
    
    init?(from response: sourcekitd_response_t) {
        let kind = sourcekitd_response_error_get_kind(response)
        self.init(rawValue: kind)
    }
}

struct SourceKitResponseError: Error {
    let type: SourceKitResponseErrorType?
    let errorDescription: String?
    
    init(response: sourcekitd_response_t) {
        let errorType = SourceKitResponseErrorType(from: response)
        if let rawErrorDescription = sourcekitd_response_error_get_description(response) {
            let errorDescription = String(validatingCString: rawErrorDescription)
            self.errorDescription = errorDescription
        } else {
            self.errorDescription = nil
        }
        self.type = errorType
    }
}

func getValueResponse(from sourcekitObject: sourcekitd_variant_t) -> SourceKitResponseValue? {
    guard let type = SourceKitValueType(from: sourcekitObject) else { return nil }
    switch type {
    case .array:
        let array = getArray(from: sourcekitObject)
        return .array(array)
    case .dictionary:
        let dictionary = getDictionaryValue(from: sourcekitObject)
        return .dictionary(dictionary)
    case .string:
        guard let stringValue = getStringValue(from: sourcekitObject) else { return nil }
        return .string(stringValue)
    case .integer:
        let integerValue = getIntegerValue(from: sourcekitObject)
        return .integer(integerValue)
    case .boolean:
        let booleanValue = getBooleanValue(from: sourcekitObject)
        return .boolean(booleanValue)
    case .uid:
        guard let stringValue = getUIDString(from: sourcekitObject) else { return nil }
        return .uid(stringValue)
    case .null:
        return .null
    }
}

private func getArray(from object: sourcekitd_variant_t) -> [SourceKitResponseValue] {
    var array = [SourceKitResponseValue]()
    _ = withUnsafeMutablePointer(to: &array) { arrayPointer in
        sourcekitd_variant_array_apply_f(object, { index, valueObject, context in
            guard let value = getValueResponse(from: valueObject),
                  let context = context
            else { return true }
            let localArray = context.assumingMemoryBound(to: [SourceKitResponseValue].self)
            localArray.pointee.insert(value, at: Int(index))
            return true
        }, arrayPointer)
    }
    return array
}

private func getDictionaryValue(from object: sourcekitd_variant_t) -> [String: SourceKitResponseValue] {
    var dictionary = [String: SourceKitResponseValue]()
    _ = withUnsafeMutablePointer(to: &dictionary) { dictionaryPointer in
        sourcekitd_variant_dictionary_apply_f(object, { keyObject, valueObject, context in
            guard let keyObject,
                  let key = getUIDString(from: keyObject),
                  let value = getValueResponse(from: valueObject),
                  let context
            else { return true }
            let localDictionary = context.assumingMemoryBound(to: [String: SourceKitResponseValue].self)
            localDictionary.pointee[key] = value
            return true
        }, dictionaryPointer)
    }
    return dictionary
}

private func getStringValue(from object: sourcekitd_variant_t) -> String? {
    guard let rawCStringValue = sourcekitd_variant_string_get_ptr(object) else { return nil }
    let stringValue = String(cString: rawCStringValue)
    return stringValue
}

private func getIntegerValue(from object: sourcekitd_variant_t) -> Int64 {
    let integerValue = sourcekitd_variant_int64_get_value(object)
    return integerValue
}

private func getBooleanValue(from object: sourcekitd_variant_t) -> Bool {
    let booleanValue = sourcekitd_variant_bool_get_value(object)
    return booleanValue
}

private func getUIDString(from object: sourcekitd_variant_t) -> String? {
    guard let uidValue = sourcekitd_variant_uid_get_value(object),
          let stringValue = getUIDString(from: uidValue)
    else { return nil }
    return stringValue
}

private func getUIDString(from uid: sourcekitd_uid_t) -> String? {
    guard let bytes = sourcekitd_uid_get_string_ptr(uid) else { return nil }
    return String(cString: bytes)
}
