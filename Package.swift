// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StreamFeeds",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "StreamFeeds",
            targets: ["StreamFeeds"]
        ),
        // In-app log viewer, meant for demo apps and debug builds only
        .library(
            name: "StreamFeedsLogsUI",
            targets: ["StreamFeedsLogsUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/GetStream/stream-core-swift.git", revision: "67f63d5c2a3cda32ee467b0e711ad150670edea7"),
        .package(url: "https://github.com/GetStream/stream-logs-ui-swift.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "StreamFeeds",
            dependencies: [
                .product(name: "StreamAttachments", package: "stream-core-swift"),
                .product(name: "StreamCore", package: "stream-core-swift")
            ]
        ),
        .target(
            name: "StreamFeedsLogsUI",
            dependencies: [
                "StreamFeeds",
                .product(name: "StreamLogsUI", package: "stream-logs-ui-swift")
            ]
        ),
        .testTarget(
            name: "StreamFeedsTests",
            dependencies: ["StreamFeeds", "StreamFeedsLogsUI"]
        )
    ]
)
