// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v17)],
    products: [
        
        .library(
            name: "DesignKit",
            targets: ["DesignKit"]),
        
        .library(
            name: "JHLogin",
            targets: ["JHLogin"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0")
    ],
    
    targets: [
        
        .target(
            name: "DesignKit"),
        
        .target(
            name: "JHLogin",
            dependencies: [
               "DesignKit",
               "SnapKit",
               "PhoneNumberKit"],
            resources: [
                .process("Resources")]
        )
    ]
)
