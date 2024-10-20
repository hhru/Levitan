// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Levitan",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "Levitan",
            targets: ["Levitan"]
        )
    ],
    targets: [
        .target(
            name: "Levitan",
            path: "Sources"
        ),
        .testTarget(
            name: "LevitanTests",
            dependencies: ["Levitan"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
