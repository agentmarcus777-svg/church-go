// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChurchGo",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ChurchGo", targets: ["ChurchGo"])
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.0"),
        .package(url: "https://github.com/simibac/ConfettiSwiftUI.git", from: "1.1.0"),
        .package(url: "https://github.com/EmergeTools/Pow.git", from: "1.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "3.0.0"),
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "ChurchGo",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios"),
                "ConfettiSwiftUI",
                "Pow",
                "SDWebImageSwiftUI",
                .product(name: "Supabase", package: "supabase-swift"),
            ],
            path: "Sources/ChurchGo"
        )
    ]
)
