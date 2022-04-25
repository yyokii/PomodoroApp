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
                "AppFeature",
                "Settings"
            ]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.34.0")
    ],
    targets: [
        .target(
            name: "AccountFeature",
            dependencies: [
                "APIClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "APIClient",
            dependencies: [
                "Model",
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseAuthCombine-Community", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "AppFeature",
            dependencies: [
                "AccountFeature",
                "APIClient",
                "MyDataFeature",
                "PomodoroTimerFeature",
                "Settings",
                "SwiftHelper",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "Model",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase"),
            ]),
        .target(
            name: "MyDataFeature",
            dependencies: [
                "APIClient",
                "SwiftHelper"
            ]),
        .target(
            name: "PomodoroTimerFeature",
            dependencies: [
                "APIClient",
                "MyDataFeature",
                "SwiftHelper",
                .product(name: "FirebaseAuth", package: "Firebase"),
            ]),
        .target(
            name: "Settings",
            dependencies: []),
        .target(
            name: "SwiftHelper",
            dependencies: []),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        
        // Test
    ]
)
