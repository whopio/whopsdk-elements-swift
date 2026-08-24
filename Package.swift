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
        .package(url: "https://github.com/muxinc/stats-sdk-objc.git", exact: "5.13.0"),
        .package(url: "https://github.com/livekit/webrtc-xcframework.git", exact: "144.7559.3"),
        .package(url: "https://github.com/intercom/intercom-ios-sp.git", .upToNextMajor(from: "19.7.2")),
        .package(url: "https://github.com/SumSubstance/IdensicMobileSDK-iOS.git", .upToNextMajor(from: "1.45.1")),
        .package(url: "https://github.com/TomaszLizer/stripe-terminal-ios-spm.git", .upToNextMajor(from: "5.7.0")),
        .package(url: "https://github.com/whopio/frosted-ui-swift.git", exact: "0.7.4"),
    ],
    targets: [
        .target(
            name: "Bootstrap",
            dependencies: [
                "Framework",
                "NewRelic",
                .product(name: "MuxCore", package: "stats-sdk-objc"),
                "LinkKit",
                .product(name: "LiveKitWebRTC", package: "webrtc-xcframework"),
                .product(name: "Intercom", package: "intercom-ios-sp", condition: .when(platforms: [.iOS])),
                .product(name: "IdensicMobileSDK", package: "IdensicMobileSDK-iOS", condition: .when(platforms: [.iOS])),
                .product(name: "StripeTerminal", package: "stripe-terminal-ios-spm", condition: .when(platforms: [.iOS])),
                .product(name: "FrostedUI", package: "frosted-ui-swift"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-elements-swift/releases/download/0.1.17/WhopElements.xcframework.zip",
            checksum: "030083ebf89492d39b4fda03d4f7d355aab851fee2fb75a4c386aa21422451ec"
        ),
        .binaryTarget(
            name: "NewRelic",
            url: "https://download.newrelic.com/ios_agent/NewRelic_XCFramework_Agent_7.7.5.zip",
            checksum: "bda8bbd756bf9358f145b8b86cdce447ef2c332ea79891f8c4ba1a83a5bbd09b"
        ),
        .binaryTarget(
            name: "LinkKit",
            url: "https://github.com/plaid/plaid-link-ios/releases/download/6.5.0/LinkKit.xcframework.zip",
            checksum: "ad91adccb5eb282cba5ff93437c6a0176a8c7c69092ef2351015705fac386b42"
        ),
    ],
    swiftLanguageModes: [.v5]
)
