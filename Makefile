BUILDER_ARTIFACT_BIN := Binaries/KeychainKeysBuilder.artifactbundle/KeychainKeysBuilder-1.0.0-macos/bin
BUILDER_RESOURCE_BUNDLE := KeychainKeysBuilder_KeychainKeysBuilder.bundle

.PHONY: keychain_keys_builder

keychain_keys_builder:
	cd KeychainKeysBuilder && swift build -c release --arch arm64
	@set -e; \
	build_output="$$(cd KeychainKeysBuilder && swift build -c release --arch arm64 --show-bin-path)"; \
	test -x "$$build_output/KeychainKeysBuilder"; \
	resource_bundle="$$build_output/$(BUILDER_RESOURCE_BUNDLE)"; \
	if ! test -s "$$resource_bundle/SourceKitRequest.yml" && ! test -s "$$resource_bundle/Contents/Resources/SourceKitRequest.yml"; then \
		echo "Missing SourceKitRequest.yml in $$resource_bundle" >&2; \
		exit 1; \
	fi; \
	rm -rf "$(BUILDER_ARTIFACT_BIN)"; \
	mkdir -p "$(BUILDER_ARTIFACT_BIN)"; \
	cp "$$build_output/KeychainKeysBuilder" "$(BUILDER_ARTIFACT_BIN)/"; \
	cp -R "$$resource_bundle" "$(BUILDER_ARTIFACT_BIN)/"
