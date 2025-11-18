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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/GetStream/stream-core-swift.git", exact: "0.6.0")
    ],
    targets: [
        .target(
            name: "StreamFeeds",
            dependencies: [
                .product(name: "StreamAttachments", package: "stream-core-swift"),
                .product(name: "StreamCore", package: "stream-core-swift"),
                .product(name: "StreamOpenAPI", package: "stream-core-swift")
            ]
        ),
        .testTarget(
            name: "StreamFeedsTests",
            dependencies: ["StreamFeeds"]
        )
    ]
)
