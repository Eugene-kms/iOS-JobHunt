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
            name: "JHAccount",
            targets: ["JHAccount"]),
        
        .library(
            name: "JHAuthentication",
            targets: ["JHAuthentication"]),
        
        .library(
            name: "JHCore",
            targets: ["JHCore"]),
        
        .library(
            name: "JHLogin",
            targets: ["JHLogin"])
    ],
    
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.29.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.9.1"))
    ],
    
    targets: [
        
        .target(name: "DesignKit"),
        
        .target(name: "JHAuthentication",
                dependencies: [
                    .product(
                        name: "FirebaseAuth",
                        package: "firebase-ios-sdk")]),
        
        .target(
            name: "JHAccount",
            dependencies: [
                "DesignKit",
                "SnapKit",
                "SDWebImage",
                "Swinject",
                .product(
                    name: "FirebaseAuth",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name:  "FirebaseStorage",
                    package: "firebase-ios-sdk"
                ),
                .product(
                    name: "FirebaseDatabase",
                    package: "firebase-ios-sdk"
                )],
            resources: [.process("Resources")]
        ),
        
        .target(name: "JHCore"),
        
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
