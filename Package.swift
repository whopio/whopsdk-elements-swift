// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "WhopPayments",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "WhopPayments",
            targets: ["Bootstrap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/newrelic/newrelic-ios-agent-spm.git", from: "7.5.11"),
        .package(url: "https://github.com/veriff/veriff-ios-spm.git", from: "8.8.0"),
        .package(url: "https://github.com/statsig-io/ios-sdk.git", from: "1.54.0"),
        .package(url: "https://github.com/muxinc/mux-player-swift.git", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/Giphy/giphy-ios-sdk.git", .upToNextMajor(from: "2.2.7")),
        .package(url: "https://github.com/privy-io/privy-ios", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        .target(
            name: "Bootstrap",
            dependencies: [
                "Framework",
                "SardineSDK",
                .product(name: "NewRelic", package: "newrelic-ios-agent-spm"),
                .product(name: "Veriff", package: "veriff-ios-spm"),
                .product(name: "Statsig", package: "ios-sdk"),
                .product(name: "MuxPlayerSwift", package: "mux-player-swift"),
                .product(name: "GiphyUISDK", package: "giphy-ios-sdk"),
                .product(name: "Privy", package: "privy-ios"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-payments-swift/releases/download/0.0.11/WhopPayments.xcframework.zip",
            checksum: "37e0de4b2a0d5c2c6639091e7ea6087fe6340e7e214b3c6602bc51ec1657d1be"
        ),
        .binaryTarget(
            name: "SardineSDK",
            url: "https://github.com/whopio/whopsdk-payments-swift/releases/download/0.0.11/MobileIntelligence.xcframework.zip",
            checksum: "3f1694622fe570f21eeccc36266f5dea6ecae0019e35fbb3ad3322574dd5ee4d"
        ),
    ]
)
