// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Levitan",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "Levitan",
            targets: ["Levitan"]
        ),
        .library(
            name: "LevitanDynamic",
            type: .dynamic,
            targets: ["Levitan"]
        ),
    ],
    targets: [
        .target(
            name: "Levitan",
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "LevitanTests",
            dependencies: ["Levitan"],
            path: "Tests",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
