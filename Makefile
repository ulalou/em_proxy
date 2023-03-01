# You can use `make copy SIDESTORE_REPO="..."` to change the SideStore repo location
SIDESTORE_REPO ?= ../SideStore

add_targets:
	@echo "add_targets"
	rustup target add aarch64-apple-ios aarch64-apple-ios-sim x86_64-apple-ios

build:
	@echo "build aarch64-apple-ios"
	@cargo build --release --target aarch64-apple-ios
	@strip target/aarch64-apple-ios/release/libem_proxy.a

	@echo "build aarch64-apple-ios-sim"
	@cargo build --release --target aarch64-apple-ios-sim
	@strip target/aarch64-apple-ios-sim/release/libem_proxy.a

	@echo "build x86_64-apple-ios"
	@cargo build --release --target x86_64-apple-ios
	@strip target/x86_64-apple-ios/release/libem_proxy.a

clean:
	@echo "clean"
	@if [ -d "target" ]; then \
		echo "cleaning target"; \
        rm -r target; \
    fi
	@if [ -d "em_proxy.xcframework" ]; then \
		echo "cleaning em_proxy.xcframework"; \
        rm -r em_proxy.xcframework; \
    fi
	@if [ -f "em_proxy.xcframework.zip" ]; then \
		echo "cleaning em_proxy.xcframework.zip"; \
        rm em_proxy.xcframework.zip; \
    fi

xcframework: build
	@echo "xcframework"
	xcodebuild -create-xcframework \
			-library target/aarch64-apple-ios/release/libem_proxy.a -headers ./ \
			-library target/aarch64-apple-ios-sim/release/libem_proxy.a -headers ./ \
			-library target/x86_64-apple-ios/release/libem_proxy.a -headers ./ \
			-output em_proxy.xcframework

zip: xcframework
	@echo "zip"
	zip -r em_proxy.xcframework.zip em_proxy.xcframework
