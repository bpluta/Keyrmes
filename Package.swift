// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport
import Foundation

let package = Package(
    name: "Keyrmes",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Keyrmes",
            targets: ["Keyrmes"]
        ),
        .plugin(name: "KeychainConstantsExtractor", targets: ["KeychainConstantsExtractor"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0"),
    ],
    targets: [
        .target(
            name: "Keyrmes",
            dependencies: ["KeyrmesMacros"],
            plugins: ["KeychainConstantsExtractor"]
        ),
        .testTarget(
            name: "KeyrmesTests",
            dependencies: ["Keyrmes"]
        ),
        .target(
            name: "KeyrmesMacros",
            dependencies: ["Macros"]
        ),
        .macro(
            name: "Macros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .plugin(
            name: "KeychainConstantsExtractor",
            capability: .buildTool(),
            dependencies: [
                .targetItem(name: "KeychainKeysBuilder", condition: .none)
            ]
        ),
        .binaryTarget(
            name: "KeychainKeysBuilder", path: "Binaries/KeychainKeysBuilder.artifactbundle"
        ),
    ]
)
