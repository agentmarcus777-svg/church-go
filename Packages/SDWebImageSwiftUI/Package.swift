// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SDWebImageSwiftUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SDWebImageSwiftUI", targets: ["SDWebImageSwiftUI"])
    ],
    targets: [
        .target(name: "SDWebImageSwiftUI")
    ]
)
