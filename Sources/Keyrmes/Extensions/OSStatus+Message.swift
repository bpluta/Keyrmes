//
//  OSStatus+Message.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

extension OSStatus {
    var message: String {
        SecCopyErrorMessageString(self, nil) as String? ?? "No message"
    }
}
