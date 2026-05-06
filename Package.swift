// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WhopElements",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "WhopElements",
            targets: ["Bootstrap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/newrelic/newrelic-ios-agent-spm.git", from: "7.5.11"),
        .package(url: "https://github.com/statsig-io/statsig-kit.git", from: "1.62.4"),
        .package(url: "https://github.com/muxinc/mux-player-swift.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/plaid/plaid-link-ios-spm.git", .upToNextMajor(from: "6.4.3")),
        .package(url: "https://github.com/livekit/client-sdk-swift.git", .upToNextMinor(from: "2.13.0")),
        .package(url: "https://github.com/privy-io/privy-ios", exact: "2.9.0-beta.1"),
        .package(url: "https://github.com/intercom/intercom-ios-sp.git", .upToNextMajor(from: "19.5.7")),
        .package(url: "https://github.com/SumSubstance/IdensicMobileSDK-iOS.git", .upToNextMajor(from: "1.42.0")),
        .package(url: "https://github.com/whopio/frosted-ui-swift.git", from: "0.6.1"),
    ],
    targets: [
        .target(
            name: "Bootstrap",
            dependencies: [
                "Framework",
                .product(name: "NewRelic", package: "newrelic-ios-agent-spm"),
                .product(name: "Statsig", package: "statsig-kit"),
                .product(name: "MuxPlayerSwift", package: "mux-player-swift"),
                .product(name: "LinkKit", package: "plaid-link-ios-spm"),
                .product(name: "LiveKit", package: "client-sdk-swift"),
                .product(name: "Privy", package: "privy-ios"),
                .product(name: "Intercom", package: "intercom-ios-sp"),
                .product(name: "IdensicMobileSDK", package: "IdensicMobileSDK-iOS"),
                .product(name: "FrostedUI", package: "frosted-ui-swift"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-elements-swift/releases/download/0.1.2/WhopElements.xcframework.zip",
            checksum: "6ec491ad1398f9bac0e6598d1be9233b049b0ec478efc0036fc7a1b1eb55e74d"
        ),
    ],
    swiftLanguageModes: [.v5]
)
