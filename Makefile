check: rust-check
test: rust-test
lint: rust-lint swift-lint
format-check: rust-format-check swift-format-check
format: rust-format swift-format

# -- Rust --

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

rust-build:
	cargo build

# -- Swift --
IOS_SWIFT_DIR   := iOS/SimpleCounter

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
		-derivedDataPath build/ios \
		| xcpretty

ios-sim: ios-build
	@[ -n "$(SIM_ID)" ] || \
		{ echo "Simulator '$(SIM_DEVICE_NAME)' not found. Check SIM_DEVICE_NAME."; exit 1; }
	@echo "Targeting simulator: $(SIM_DEVICE_NAME) ($(SIM_ID))"
	xcrun simctl boot $(SIM_ID) 2>/dev/null || true
	open -a Simulator
	xcrun simctl install $(SIM_ID) \
		build/ios/Build/Products/Debug-iphonesimulator/$(XCODE_SCHEME).app
	xcrun simctl launch --console $(SIM_ID) \
		$(shell /usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" \
			build/ios/Build/Products/Debug-iphonesimulator/$(XCODE_SCHEME).app/Info.plist)
