// swift-tools-version:5.2

import PackageDescription

let package = Package(
        name: "liboji",
        products: [
            .library(name: "liboji", targets: ["liboji"])
        ],
        dependencies: [
            .package(
                url: "https://github.com/jb55/macaroon-swift.git", 
                from: "0.2.1"
            )
        ],
        targets: [
            .target(name: "liboji", path: "liboji", dependencies: ["Macaroons"])
        ]
)
