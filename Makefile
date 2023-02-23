# You can use `make copy SIDESTORE_REPO="..."` to change the SideStore repo location
SIDESTORE_REPO ?= ../SideStore

build:
	cargo build --release --target aarch64-apple-ios
	strip target/aarch64-apple-ios/release/libem_proxy.a
	cp target/aarch64-apple-ios/release/libem_proxy.a target

	cargo build --release --target aarch64-apple-ios-sim
	cargo build --release --target x86_64-apple-ios
	strip target/aarch64-apple-ios-sim/release/libem_proxy.a
	strip target/x86_64-apple-ios/release/libem_proxy.a
	lipo -create -output target/libem_proxy-sim.a target/aarch64-apple-ios-sim/release/libem_proxy.a target/x86_64-apple-ios/release/libem_proxy.a

copy: build
	@echo SIDESTORE_REPO: $(SIDESTORE_REPO)

	cp target/libem_proxy.a "$(SIDESTORE_REPO)/Dependencies/em_proxy"
	cp target/libem_proxy-sim.a "$(SIDESTORE_REPO)/Dependencies/em_proxy"
	cp em_proxy.h "$(SIDESTORE_REPO)/Dependencies/em_proxy"
	touch "$(SIDESTORE_REPO)/Dependencies/.skip-prebuilt-fetch-em_proxy"
