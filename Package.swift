// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "CybridSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "CybridSDK", targets: ["CybridSDK"])
    ],
    dependencies: [
        .package(url: "https://github.com/Cybrid-app/cybrid-api-bank-swift", exact: "0.113.6"),
        .package(url: "https://github.com/attaswift/BigInt", exact: "5.2.0"),
        .package(url: "https://github.com/plaid/plaid-link-ios-spm", exact: "5.6.1"),
        .package(url: "https://github.com/persona-id/inquiry-ios-2", exact: "2.56.0")
    ],
    targets: [
        .target(
            name: "CybridSDK",
            dependencies: [
                .product(name: "CybridApiBankSwift", package: "cybrid-api-bank-swift"),
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "LinkKit", package: "plaid-link-ios-spm"),
                .product(name: "PersonaInquirySDK2", package: "inquiry-ios-2")
            ],
            path: "CybridSDK",
            exclude: [
                "Info.plist",
                "CybridSDK.h",
                "Core/Auth/CybridAuthenticator.swift",
                "Components/Trade/SellQuoteViewController.swift",
                "Components/Trade/Buy Quote"
            ],
            resources: [
                .process("Resources"),
                .process("Utilities/Localization/en.lproj"),
                .process("Utilities/Localization/fr.lproj"),
                .process("Utilities/Localization/fr-CA.lproj")
            ]
        ),
        .testTarget(name: "ResourceTests", dependencies: ["CybridSDK"], path: "Tests/ResourceTests")
    ]
)
