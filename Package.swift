// swift-tools-version:5.1

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
            dependencies: []
        ),
        .testTarget(
            name: "PainlessInjectionTests",
            dependencies: ["PainlessInjection"]
        )
    ]
)
