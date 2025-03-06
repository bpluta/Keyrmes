//
//  ProcessExecutor.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct ProcessExecutor {
    static func execute(_ command: String, _ arguments: String...) throws -> String? {
        let process = Process()
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        
        if let errorOutput = FileHandle(forWritingAtPath: "/dev/null") {
            process.standardError = errorOutput
        }
        
        let currentDirectory = FileManager.default.currentDirectoryPath
        process.executableURL = URL(fileURLWithPath: command)
        process.currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
        try process.run()
        
        let file = pipe.fileHandleForReading
        let data = file.readDataToEndOfFile()
        process.waitUntilExit()
        
        guard let outputString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
              !outputString.isEmpty
        else { return nil }
        return outputString
    }
}
