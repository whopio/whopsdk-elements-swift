// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "WhopElements",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "WhopElements",
            targets: ["Bootstrap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/newrelic/newrelic-ios-agent-spm.git", from: "7.5.11"),
        .package(url: "https://github.com/veriff/veriff-ios-spm.git", from: "8.8.0"),
        .package(url: "https://github.com/statsig-io/ios-sdk.git", from: "1.54.0"),
        .package(url: "https://github.com/muxinc/mux-player-swift.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/plaid/plaid-link-ios-spm.git", .upToNextMajor(from: "6.4.3")),
        .package(url: "https://github.com/livekit/client-sdk-swift.git", .upToNextMinor(from: "2.7.2")),
        .package(url: "https://github.com/privy-io/privy-ios", exact: "2.9.0-beta.1"),
    ],
    targets: [
        .target(
            name: "Bootstrap",
            dependencies: [
                "Framework",
                .product(name: "NewRelic", package: "newrelic-ios-agent-spm"),
                .product(name: "Veriff", package: "veriff-ios-spm"),
                .product(name: "Statsig", package: "ios-sdk"),
                .product(name: "MuxPlayerSwift", package: "mux-player-swift"),
                .product(name: "LinkKit", package: "plaid-link-ios-spm"),
                .product(name: "LiveKit", package: "client-sdk-swift"),
                .product(name: "Privy", package: "privy-ios"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-elements-swift/releases/download/0.0.18/WhopElements.xcframework.zip",
            checksum: "ceda5191e1da4b19f91ecf5419a62c655150f9f936f50ca382835aecafab5bb0"
        ),
    ]
)
