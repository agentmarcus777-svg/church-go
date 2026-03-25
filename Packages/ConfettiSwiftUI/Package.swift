// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ConfettiSwiftUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "ConfettiSwiftUI", targets: ["ConfettiSwiftUI"])
    ],
    targets: [
        .target(name: "ConfettiSwiftUI")
    ]
)
