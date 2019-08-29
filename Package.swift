// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Once",
    products: [
        .library(name: "Once", targets: ["Once"])
    ],
    targets: [
        .target(name: "Once", dependencies: []),
        .testTarget(name: "OnceTests", dependencies: ["Once"])
    ]
)
