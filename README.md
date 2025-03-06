# Keyrmes

<p>
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-6.0-orange.svg?style=flat" alt="Swift 6.0">
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

Keyrmes is a Swift library that delivers a secure and intuitive interface for accessing keychain services on Apple platforms. By encapsulating the low-level Keychain Services API into a type-safe, Swift-centric layer, it makes storing and retrieving various data types effortless.

## Features
- **Easy-to-Use API:** Abstracts low-level keychain details so you don't need to dive into details of Apple's complex Keychain services
- **Type-Safe Serialization:** Automatically encodes and decodes a wide range of Swift types (primitives, Codable, NSCoding) out-of-the-box.
- **Customizable Keychain Queries:** Powerful query builder API lets you easily customize keychain queries in case you need more advanced options when querying Keychain
- **Customizable Type Serialization:** Allows you to implement custom serializers for specialized data handling, ideal for ensuring backwards compatibility.
- **Modern API Design:** Leverages the latest Swift paradigms and Swift 6 Concurrency for clear, concise, and maintainable code.
- **System Implementation Compatibility**: Uses a compiler build tool plugin to extract keychain constants from Apple’s `Security.framework`, ensuring up-to-date and platform-specific definitions
- **Robust Error Handling:** Comprehensive error reporting facilitates rapid debugging and enhances reliability.

## Compatibility

Keyrmes supports the following platforms and OS versions:
- **iOS**: 16.0 and later
- **macOS**: 13.0 and later
- **watchOS**: 9.0 and later
- **tvOS**: 16.0 and later
- **visionOS**: 1.0 and later

## Installation

### Adding Keyrmes as Swift Package Manager dependency

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/bpluta/Keyrmes.git", from: "1.0.0"),
```

Then include `Keyrmes` as a dependency for your target:
```swift
.target(name: "<YOUR_TARGET_NAME>", dependencies: [
    .product(name: "Keyrmes", package: "Keyrmes"),
]),
```

Finally, add `import Keyrmes` to your source code.

### Building and dependencies

The library's build process leverages custom Swift Macros to reduce boilerplate code, alongside a compiler build plugin that generates an enum of keychain query keys by parsing the `Security.framework` headers for the target platform. These processes highly rely on Apple's [`swift-syntax`](https://github.com/swiftlang/swift-syntax) package which is the only external dependency of this package.

Due to limitations in Swift compiler build plugins, compilation of the `KeychainQueryBuilder` tool is not integrated into the main build process; instead, it is embedded as a pre-built `arm64` binary within an artifact bundle provided in the repository. However if you prefer to build the tool yourself, you can do so by running the following command:

```
make keychain_keys_builder
```
This command compiles the `KeychainKeysBuilder` package into a binary and places it directly into the artifact bundle directory

## Usage

The simplest way to work with Keyrmes is by using the `KeychainStore` object, which offers methods such as `read(identifier:)`, `set(identifier:, to:, accessibility:)`, and `delete(identifier:)` for common keychain operations. These methods automatically take care of type serialization and the assembly of low-level queries, providing a clean and intuitive interface for secure keychain access.

```swift
import Keyrmes

// Defining enum with keychain entity identifiers
enum KeychainIdentifiers: String, KeychainIdentifiable {
    case someConfidentialValue

    var keychainLabel: String { rawValue }
}

// Creating a keychain storage object
let store = KeychainStore()

// Storing value in the keychain
let someValue = "Some string to be stored in the keychain"
try await store.set(identifier: KeychainIdentifiers.someConfidentialValue, to: someValue, accessibility: .whenUnlockedThisDeviceOnly)

// Retrieving value from keychain
let storedValue: String? = try await store.read(identifier: KeychainIdentifiers.someConfidentialValue)

```

### Custom keychain queries
The library also supports creating custom keychain queries to provide more versatile access to keychain using basic CRUD operations like `read(query:)`, `update(matching:to:)`, `set(query:)` or `delete(query:)`.

Example:
```swift
import Keyrmes

// Creating a keychain storage object
let store = KeychainStore()

// Building custom query
let query = KeychainQueryBuilder.emptyQuery()
    .set(class: .genericPassword)
    .set(attributeAccount: KeychainIdentifiers.someConfidentialValue)  
    .set(matchLimit: .one)
    .set(returnData: true)

// Querying the keychain and extracting an output from the response
let response = try await store.read(query: query)
let output: AnyObject? = response?.object
```

## Contributing
Contributions are very welcome 🙌

## License

The project is licensed under [Zero-Clause BSD](https://opensource.org/license/0bsd) license. See [LICENSE.txt](./LICENSE.txt) for more information.