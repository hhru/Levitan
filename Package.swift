// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Levitan",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
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
    swiftLanguageModes: [.v6]
)
