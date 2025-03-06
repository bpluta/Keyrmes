//
//  SourceKitClient.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation
import SourceKitTypes

class SourceKitClient {
    
    init() { initialize() }
    
    deinit { shutdown() }
    
    func send(yaml: String) throws -> SourceKitResponseValue {
        guard let request = getRequest(yaml: yaml) else {
            logger.error("Could not initialize a SourceKit request from provided YAML")
            throw SourceKitError.failedToCreateYamlRequest
        }
        logger.trace("SourceKit request has been successfully initialized from provided YAML")
        
        guard let response = sendSync(request: request) else {
            logger.error("SourceKit response has not been received")
            throw SourceKitError.failedToReceiveResponse
        }
        logger.trace("SourceKit response has been received")
        defer { dispose(response: response) }
        
        if isError(response: response) {
            let error = SourceKitResponseError(response: response)
            logger.error("SourceKit response contains an error:\n\n\(error.description, privacy: .public)")
            throw SourceKitError.requestedOperationDidNotSucceed
        }
        logger.trace("SourceKit response is valid")
        
        let value = getValue(from: response)
        guard let responseValue = getValueResponse(from: value) else {
            logger.error("Failed to parse a SourceKit response payload to known response types")
            throw SourceKitError.unknownResponseValue
        }
        logger.trace("SourceKit response has been parsed successfully")
        
        return responseValue
    }
    
    private func initialize() {
        logger.trace("Initializing a SourceKit daemon")
        sourcekitd_initialize()
    }
    
    private func getValue(from response: sourcekitd_response_t) -> sourcekitd_variant_t {
        logger.trace("Extracting response payload from returned SourceKit response")
        return sourcekitd_response_get_value(response)
    }
    
    private func shutdown() {
        logger.trace("Shutting down a SourceKit daemon")
        sourcekitd_shutdown()
    }
    
    private func dispose(response: sourcekitd_response_t) {
        logger.trace("Disposing of returned SourceKit response")
        return sourcekitd_response_dispose(response)
    }
    
    private func getRequest(yaml: String) -> sourcekitd_object_t? {
        logger.trace("Initializing SourceKit request from provided YAML\n\n\(yaml, privacy: .public)")
        return sourcekitd_request_create_from_yaml(yaml, nil)
    }
    
    private func sendSync(request: sourcekitd_object_t) -> sourcekitd_response_t? {
        logger.trace("Sending a SourceKit request")
        return sourcekitd_send_request_sync(request)
    }
    
    private func isError(response: sourcekitd_response_t) -> Bool {
        logger.trace("Validating if the SourceKit response indicates an error")
        return sourcekitd_response_is_error(response)
    }
}

extension SourceKitClient {
    enum SourceKitError: Error {
        case failedToCreateYamlRequest
        case failedToReceiveResponse
        case requestedOperationDidNotSucceed
        case unknownResponseValue
    }
}

extension SourceKitResponseErrorType: CustomStringConvertible {
    var description: String {
        switch self {
        case .connectionInterrupted: "Connection interrupted"
        case .invalidRequest: "Invalid request"
        case .requestFailed: "Request failed"
        case .requestcancelled: "Request cancelled"
        }
    }
}

extension SourceKitResponseError: CustomStringConvertible {
    var description: String {
        "\(type?.description ?? "Unknown error type"): \(errorDescription ?? "(No error description)")"
    }
}
