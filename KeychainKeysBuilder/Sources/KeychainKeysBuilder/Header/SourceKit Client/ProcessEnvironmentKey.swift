//
//  ProcessEnvironmentKey.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

import Foundation

enum ProcessEnvironmentKey: String {
    case xcodeDefaultToolchainOverride = "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE"
    case toolchainDirectory = "TOOLCHAIN_DIR"
    case sdkDirectory = "SDK_DIR"
    case nativeArch = "NATIVE_ARCH"
    case llvmTargetTripleVendor = "LLVM_TARGET_TRIPLE_VENDOR"
    case llvmTargetTripleOsVersion = "LLVM_TARGET_TRIPLE_OS_VERSION"
    case llvmTargetTripleSuffix = "LLVM_TARGET_TRIPLE_SUFFIX"
    case platformFamilyName = "PLATFORM_FAMILY_NAME"
    
    func getValue(from procesInfo: ProcessInfo) -> String? {
        procesInfo.environment[rawValue]
    }
}

extension ProcessInfo {
    func environmentValue(for key: ProcessEnvironmentKey) -> String? {
        environment[key.rawValue]
    }
}
