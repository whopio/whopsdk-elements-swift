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
                .product(name: "GiphyUISDK", package: "giphy-ios-sdk"),
            ],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Framework",
            url: "https://github.com/whopio/whopsdk-payments-swift/releases/download/0.0.6/WhopPayments.xcframework.zip",
            checksum: "ab3235b9d53eafaf9a0f6c2685574c94b5c5d058a09bb64b0857f0c079d4a24d"
        ),    ]
)
