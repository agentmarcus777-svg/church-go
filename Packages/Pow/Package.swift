// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Pow",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Pow", targets: ["Pow"])
    ],
    targets: [
        .target(name: "Pow")
    ]
)
