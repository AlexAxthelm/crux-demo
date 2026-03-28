check: rust-all-checks swift-all-checks
test: rust-test
lint: rust-lint swift-lint
format-check: rust-format-check swift-format-check
format: rust-format swift-format

clean: rust-clean swift-clean

# -- Rust --

rust-all-checks: rust-check rust-test rust-lint rust-format-check rust-lock-check

rust-check:
	cargo check

rust-test:
	cargo test

rust-lint:
	cargo clippy -- -D warnings

rust-format:
	cargo fmt

rust-format-check:
	cargo fmt -- --check

rust-lock-check:
	cargo check --locked

rust-build:
	cargo build

rust-clean:
	cargo clean

# -- Swift --
IOS_SWIFT_DIR   := iOS/SimpleCounter

swift-all-checks: swift-lint swift-format-check

swift-lint:
	swiftlint lint --strict $(IOS_SWIFT_DIR)

swift-format:
	swiftformat $(IOS_SWIFT_DIR)

swift-format-check:
	swiftformat --lint $(IOS_SWIFT_DIR)

# -- iOS --
XCODE_PROJECT   := iOS/SimpleCounter.xcodeproj
XCODE_SCHEME    := SimpleCounter

SIM_DEVICE_NAME := iPhone 14 Pro Max
SIM_ID := $(shell \
	xcrun simctl list devices available -j \
	| jq -r '.devices \
		| to_entries[].value[] \
		| select(.name == "$(SIM_DEVICE_NAME)" and .isAvailable == true) \
		| .udid' \
	| head -1)

ios-open:
	open $(XCODE_PROJECT)

xcodegen:
	xcodegen --spec iOS/project.yml --project iOS

ios-build: rust-build xcodegen
	xcodebuild \
		-project $(XCODE_PROJECT) \
		-scheme $(XCODE_SCHEME) \
		-configuration Debug \
		-destination 'platform=iOS Simulator,id=$(SIM_ID)' \
		| xcpretty

ios-sim: ios-build
	$(eval APP_PATH := $(shell find ~/Library/Developer/Xcode/DerivedData \
		-name "$(XCODE_SCHEME).app" \
		-path "*/Debug-iphonesimulator/*" \
		-not -path "*/Index.noindex/*" \
		2>/dev/null | head -1))
	@[ -n "$(APP_PATH)" ] || \
		{ echo "App not found in DerivedData."; exit 1; }
	@[ -n "$(SIM_ID)" ] || \
		{ echo "Simulator '$(SIM_DEVICE_NAME)' not found."; exit 1; }
	@echo "Targeting: $(SIM_DEVICE_NAME) ($(SIM_ID))"
	@echo "Installing: $(APP_PATH)"
	xcrun simctl boot $(SIM_ID) 2>/dev/null || true
	open -a Simulator
	xcrun simctl install $(SIM_ID) "$(APP_PATH)"
	xcrun simctl launch --console $(SIM_ID) \
		$$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$(APP_PATH)/Info.plist")

swift-clean: xcode-clean swift-generated-clean

xcode-clean:
	rm -rf $(XCODE_PROJECT)

swift-generated-clean:
	rm -rf iOS/generated
	rm -rf shared_types/generated/swift

.PHONY: check test lint format format-check \
        rust-check rust-test rust-lint rust-format rust-format-check rust-build \
        swift-lint swift-format swift-format-check \
        ios-open xcodegen ios-build ios-sim
