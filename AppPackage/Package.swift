// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppPackage",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AppPackage",
            targets: ["AppPackage"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppPackage",
            dependencies: []),

        // Test
        .testTarget(
            name: "AppPackageTests",
            dependencies: ["AppPackage"]),
    ]
)
