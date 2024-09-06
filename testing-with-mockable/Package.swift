// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "docker-swift-pull",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/command", from: "0.8.0")
    ],
    targets: [
        .executableTarget(
            name: "docker-swift-pull",
            dependencies: [
                .product(name: "Command", package: "Command")
            ]
        ),
        .testTarget(
            name: "docker-swift-pull-tests",
            dependencies: [
                "docker-swift-pull",
                .product(name: "Command", package: "Command")
            ]
        )
    ]
)
