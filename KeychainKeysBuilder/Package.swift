// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeychainKeysBuilder",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "KeychainKeysBuilder",
            targets: ["KeychainKeysBuilder"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "KeychainKeysBuilder",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .targetItem(name: "SourceKitTypes", condition: .none)
            ],
            resources: [
                .process("SourceKitRequest.yml"),
            ]
        ),
        .target(
            name: "SourceKitTypes",
            publicHeadersPath: "include"
        ),
    ]
)
