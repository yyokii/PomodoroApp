// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", branch: "swift-5.5-branch")
    ],
    targets: [
        .target(
            name: "BuildTools",
            // Source files for target BuildTools should be located under 'Sources/BuildTools', or a custom sources path can be set with the 'path' property in Package.swift
            path: "")
    ]
)
