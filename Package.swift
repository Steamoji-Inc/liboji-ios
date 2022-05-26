// swift-tools-version:5.2

import PackageDescription

let package = Package(
        name: "liboji",
        products: [
            .library(name: "liboji", targets: ["liboji"])
        ],
        dependencies: [],
        targets: [
            .target(name: "liboji",
                    path: "liboji")
        ]
)
