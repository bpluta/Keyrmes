keychain_keys_builder:
	(cd KeychainKeysBuilder; swift build -c release --arch arm64)
	rm -rf Binaries/KeychainKeysBuilder.artifactbundle/KeychainKeysBuilder-1.0.0-macos/bin/*
	cp KeychainKeysBuilder/.build/release/KeychainKeysBuilder Binaries/KeychainKeysBuilder.artifactbundle/KeychainKeysBuilder-1.0.0-macos/bin/KeychainKeysBuilder
