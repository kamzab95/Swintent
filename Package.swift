// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package. 

import PackageDescription

let package = Package(
    name: "Swintent",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "Swintent",
            targets: ["Swintent"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Swintent",
            dependencies: []),
        .testTarget(
            name: "SwintentTests",
            dependencies: ["Swintent"]),
    ]
)
