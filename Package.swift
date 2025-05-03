// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fXDKit",
    platforms: [
        .iOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "fXDKit",
            targets: ["fXDObjC", "fXDKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "fXDObjC",
            path: "fXDObjC.xcframework"
        ),
        .target(
            name: "fXDKit",
            dependencies: ["fXDObjC",
                           .product(name: "FirebaseCore", package: "Firebase"),
                           .product(name: "FirebaseAnalytics", package: "Firebase"),
                           .product(name: "FirebaseMessaging", package: "Firebase"),
                           .product(name: "FirebasePerformance", package: "Firebase"),
                           .product(name: "FirebaseRemoteConfig", package: "Firebase"),
            ],
            path: "Sources",
            exclude: ["../fXDObjC"]
        )
    ]
)
