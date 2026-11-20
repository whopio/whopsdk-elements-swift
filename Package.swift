// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WhopElements",
    platforms: [
        .iOS(.v18),
        .macCatalyst(.v18),
    ],
    products: [
        .library(
            name: "WhopElements",
            targets: ["Bootstrap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/livekit/webrtc-xcframework.git", exact: "144.7559.3"),
        .package(url: "https://github.com/intercom/intercom-ios-sp.git", .upToNextMajor(from: "19.10.0")),
        .package(url: "https://github.com/SumSubstance/IdensicMobileSDK-iOS.git", .upToNextMajor(from: "1.45.1")),
        .package(url: "https://github.com/TomaszLizer/stripe-terminal-ios-spm.git", .upToNextMajor(from: "5.8.0")),
    ],
    targets: [
        .target(
            name: "Bootstrap",
            dependencies: [
                "Framework",
                "FrostedUI",
                "NewRelic",
                "LinkKit",
                .product(name: "LiveKitWebRTC", package: "webrtc-xcframework"),
                .product(name: "Intercom", package: "intercom-ios-sp", condition: .when(platforms: [.iOS])),
                .product(name: "IdensicMobileSDK", package: "IdensicMobileSDK-iOS", condition: .when(platforms: [.iOS])),
                .product(name: "StripeTerminal", package: "stripe-terminal-ios-spm", condition: .when(platforms: [.iOS])),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-elements-swift/releases/download/0.1.24/WhopElements.xcframework.zip",
            checksum: "0b7b9ded63412f72f9dbdde546673a8c3ab967135c0e9fd3b5df027aa21cb0d0"
        ),
        .binaryTarget(
            name: "FrostedUI",
            url: "https://github.com/whopio/frosted-ui-swift/releases/download/0.9.1/FrostedUI.xcframework.zip",
            checksum: "8799cbe8034fe797cd5a576c4285e03ccec671b5400ee6bdff66451780b0f4bd"
        ),
        .binaryTarget(
            name: "NewRelic",
            url: "https://download.newrelic.com/ios_agent/NewRelic_XCFramework_Agent_7.7.10.zip",
            checksum: "a97047f5aeebaee4b7651f2c3a3c4bf73c51e66834de441bc1b51f5eddaadcf3"
        ),
        .binaryTarget(
            name: "LinkKit",
            url: "https://github.com/plaid/plaid-link-ios/releases/download/6.5.8/LinkKit.xcframework.zip",
            checksum: "8fde5fd34c691e67a274babb8c5316ad647e4ed00834b45f9d3101f0f019ce19"
        ),
    ],
    swiftLanguageModes: [.v5]
)
