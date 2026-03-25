// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Lottie",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Lottie", targets: ["Lottie"])
    ],
    targets: [
        .target(name: "Lottie")
    ]
)
