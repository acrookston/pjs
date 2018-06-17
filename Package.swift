// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Pretty JSON",
    dependencies: [
        .package(url: "https://github.com/DanToml/Jay", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Pretty JSON",
            dependencies: ["Jay"]),
        .testTarget(
            name: "Pretty JSONTests",
            dependencies: ["Pretty JSON"]),
    ]
)
