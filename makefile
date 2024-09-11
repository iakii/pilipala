clean: 
		@echo "Cleaning flutter project..."
		@flutter clean

format:
		@echo "Formatting the code"
		@dart format .

get: ## Get pub packages.
		@flutter pub get

window-release: 
		@echo "Build Windows platform..."
		@flutter clean
		@flutter_distributor package --platform windows --targets exe --skip-clean

linux-deb: 
		@echo "Build Linux deb platform..."
		@flutter_distributor package --platform linux --targets deb --skip-clean

android-release: 
		@echo "Build Android platform..."
		@mv assets/webrtc.zip ./
		@flutter build apk --target lib/main_mobile.dart --target-platform android-arm,android-arm64,android-x64 --split-per-abi
		@mv ./webrtc.zip assets/

gen-go:
		@echo "gen the code"
		@dart run bindgo:run --config bindgo.yaml
		@dart run ffigen --config webrtc_ffi_config.yaml
		@dart run ffigen --config webdav_ffi_config.yaml

gen-rust:
		@echo "gen rust bridge code"
		@flutter_rust_bridge_codegen generate

 
 

android-env:
		@rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android i686-linux-android

macos-release:
		@flutter_distributor package --platform macos --targets dmg