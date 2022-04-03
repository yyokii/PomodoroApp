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
                "DataFeature",
                "TimerFeature",
            ]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0"),
//        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .from: "0.34.0")
    ],
    targets: [
        .target(
            name: "AppPackage",
            dependencies: []),
        .target(
            name: "DataFeature",
            dependencies: [
                "SwiftHelper"
            ]),
        .target(
            name: "SwiftHelper",
            dependencies: []),
        .target(
            name: "TimerFeature",
            dependencies: [
                "SwiftHelper",
                .product(name: "FirebaseAuth", package: "Firebase"),
            ]),
        
        // Test
        .testTarget(
            name: "AppPackageTests",
            dependencies: ["AppPackage"]),
    ]
)
