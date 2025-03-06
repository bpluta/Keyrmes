//
//  DynamicLibraryLoader.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

struct DynamicLibraryLoader {
    let defaultSearchURLs: [URL]
    
    init(context: ProcessContext) {
        let baseDefaultSearchURLs = Self.getDefaultSearchURLs(in: context)
        logger.trace("Default dynamic library search paths:\n\n\(baseDefaultSearchURLs.logDescription, privacy: .public)")
        self.defaultSearchURLs = baseDefaultSearchURLs
            .map { url in
                url.appending(component: "usr/lib")
            }.filter { url in
                FileManager.default.fileExists(atPath: url.path(percentEncoded: false))
            }
    }
    
    func load(path: String) -> DynamicLibrary {
        let requestedURL = URL(fileURLWithPath: path)
        let searchURLs = (defaultSearchURLs + [requestedURL])
            .map { url in
                url.appending(component: path)
            }.filter(\.isFileURL)
        
        logger.trace("Searching for \(path, privacy: .public) dynamic library in:\n\n\(searchURLs.logDescription, privacy: .public)")
        
        for url in searchURLs {
            let path = url.path(percentEncoded: false)
            guard let handle = dlopen(path, RTLD_LAZY) else { continue }
            logger.trace("Dynamic library has been loaded successfully")
            return DynamicLibrary(handle: handle)
        }
        
        logger.error("Failed to load given dynamic library: \(path, privacy: .public)")
        fatalError("Unable to find resource: \(path)")
    }
}

extension DynamicLibraryLoader {
    static func getDefaultSearchURLs(in context: ProcessContext) -> [URL] {
        let buldEnvironment = BuildEnvironment(context: context)
        let availableSearchPaths = [
            buldEnvironment.xcodeDefaultToolachainOverrideDirectory,
            buldEnvironment.toolchainDirectory,
            buldEnvironment.xcrunToolchainDirectory,
            buldEnvironment.systemXcodeDeveloperToolchainDirectory,
            buldEnvironment.systemXcodeBetaDeveloperToolchainDirectory,
            buldEnvironment.userXcodeDeveloperToolchainDirectory,
            buldEnvironment.userXcodeBetaDeveloperToolchainDirectory
        ]
        return availableSearchPaths.compactMap { $0 }
    }
}

fileprivate extension Array where Element == URL {
    var logDescription: String {
        map(\.path).joined(separator: "\n")
    }
}
