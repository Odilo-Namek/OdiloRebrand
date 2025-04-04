// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "OdiloRebrand",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FirebaseAdmin",
            targets: ["FirebaseAdmin"]
        ),
        .library(
            name: "Utils",
            targets: ["Utils"]
        ),
        .executable(
            name: "BrandingCreator",
            targets: ["BrandingCreator"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.3"),
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.14.0")
    ],
    targets: [
        .target(
            name: "FirebaseAdmin",
            dependencies: ["Alamofire", "Utils"]
        ),
        .target(
            name: "Utils",
            dependencies: [.product(name: "Yams", package: "Yams"), "CoreXLSX"]
        ),
        .executableTarget(
            name: "BrandingCreator",
            dependencies: [
                "FirebaseAdmin",
                "Utils",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Yams", package: "Yams")
            ]
        ),
    ]
)
