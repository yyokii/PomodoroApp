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
            name: "App",
            targets: [
                "AppPackage",
                "TimerFeature"
            ]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppPackage",
            dependencies: []),
        .target(
            name: "TimerFeature",
            dependencies: []),
        
        // Test
        .testTarget(
            name: "AppPackageTests",
            dependencies: ["AppPackage"]),
    ]
)
