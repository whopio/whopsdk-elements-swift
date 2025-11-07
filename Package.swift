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
            url: "https://github.com/whopio/whopsdk-payments-swift/releases/download/0.0.4/WhopPayments.xcframework.zip",
            checksum: "ff556527fcb63ac4b5a68849408908218cdf80863a199abea7939917e85469f8"
        ),    ]
)
