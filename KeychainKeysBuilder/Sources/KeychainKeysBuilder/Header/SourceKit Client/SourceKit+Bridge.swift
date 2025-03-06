//
//  SourceKit+Bridge.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import SourceKitTypes

nonisolated(unsafe) private let library = DynamicLibraryLoader(context: .shared)
    .load(path: "sourcekitdInProc.framework/Versions/A/sourcekitdInProc")

let sourcekitd_initialize: @convention(c) () -> () = library
    .load(symbol: "sourcekitd_initialize")

let sourcekitd_response_get_value: @convention(c) (sourcekitd_response_t) -> (sourcekitd_variant_t) = library
    .load(symbol: "sourcekitd_response_get_value")

let sourcekitd_shutdown: @convention(c) () -> () = library
    .load(symbol: "sourcekitd_shutdown")

let sourcekitd_response_dispose: @convention(c) (sourcekitd_response_t) -> () = library
    .load(symbol: "sourcekitd_response_dispose")

let sourcekitd_request_create_from_yaml: @convention(c) (UnsafePointer<CChar>, UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?) -> (sourcekitd_object_t?) = library
    .load(symbol: "sourcekitd_request_create_from_yaml")

let sourcekitd_send_request_sync: @convention(c) (sourcekitd_object_t) -> (sourcekitd_response_t?) = library
    .load(symbol: "sourcekitd_send_request_sync")

let sourcekitd_response_is_error: @convention(c) (sourcekitd_response_t) -> (Bool) = library
    .load(symbol: "sourcekitd_response_is_error")

let sourcekitd_variant_get_type: @convention(c) (sourcekitd_variant_t) -> (UInt8) = library
    .load(symbol: "sourcekitd_variant_get_type")

let sourcekitd_variant_array_apply_f: @convention(c) (sourcekitd_variant_t, sourcekitd_variant_array_applier_f_t, UnsafeMutableRawPointer?) -> (Bool) = library
    .load(symbol: "sourcekitd_variant_array_apply_f")

let sourcekitd_variant_dictionary_apply_f: @convention(c) (sourcekitd_variant_t, sourcekitd_variant_dictionary_applier_f_t, UnsafeMutableRawPointer?) -> (Bool) = library
    .load(symbol: "sourcekitd_variant_dictionary_apply_f")

let sourcekitd_variant_string_get_ptr: @convention(c) (sourcekitd_variant_t) -> (UnsafePointer<CChar>?) = library
    .load(symbol: "sourcekitd_variant_string_get_ptr")

let sourcekitd_variant_int64_get_value: @convention(c) (sourcekitd_variant_t) -> (Int64) = library
    .load(symbol: "sourcekitd_variant_int64_get_value")

let sourcekitd_variant_bool_get_value: @convention(c) (sourcekitd_variant_t) -> (Bool) = library
    .load(symbol: "sourcekitd_variant_bool_get_value")

let sourcekitd_variant_uid_get_value: @convention(c) (sourcekitd_variant_t) -> (sourcekitd_uid_t?) = library
    .load(symbol: "sourcekitd_variant_uid_get_value")

let sourcekitd_uid_get_string_ptr: @convention(c) (sourcekitd_uid_t) -> (UnsafePointer<CChar>?) = library
    .load(symbol: "sourcekitd_uid_get_string_ptr")

let sourcekitd_response_error_get_description: @convention(c) (sourcekitd_response_t) -> (UnsafePointer<CChar>?) = library.load(symbol: "sourcekitd_response_error_get_description")

let sourcekitd_response_error_get_kind: @convention(c) (sourcekitd_response_t) -> (UInt8) = library
    .load(symbol: "sourcekitd_response_error_get_kind")
