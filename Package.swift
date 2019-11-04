// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "PainlessInjection",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(name: "PainlessInjection", targets: ["PainlessInjection"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "PainlessInjection",
            dependencies: [],
            path: "Source"
        ),
        .testTarget(
            name: "PainlessInjectionTests",
            dependencies: ["PainlessInjection"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
