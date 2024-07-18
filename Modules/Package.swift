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
            name: "JHAuthentication",
            targets: ["JHAuthentication"]),
        
        .library(
            name: "JHLogin",
            targets: ["JHLogin"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    
    targets: [
        
        .target(name: "DesignKit"),
        
        .target(name: "JHAuthentication",
                dependencies: [
                    .product(
                        name: "FirebaseAuth",
                        package: "firebase-ios-sdk")]),
        
        .target(
            name: "JHLogin",
            dependencies: [
                "JHAuthentication",
                "DesignKit",
                "SnapKit",
                "PhoneNumberKit"],
            resources: [
                .process("Resources")]
        )
    ]
)
