//
//  SourceKitRequest.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

protocol SourceKitRequest {
    func yamlString() throws -> String
}
