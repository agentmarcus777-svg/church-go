// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Supabase",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Supabase", targets: ["Supabase"])
    ],
    targets: [
        .target(name: "Supabase")
    ]
)
