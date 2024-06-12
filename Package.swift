// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "PNChartPackage",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "PNChartPackage",
            targets: ["PNChartPackage"]),
    ],
    dependencies: [
        // .package(url: "https://github.com/another/repo", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "PNChartPackage",
            dependencies: []),
        .testTarget(
            name: "PNChartPackageTests",
            dependencies: ["PNChartPackage"]),
    ]
)
