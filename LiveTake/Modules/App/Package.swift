// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "App",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "App",
      targets: ["App"]),
    .library(
      name: "AppEnvironmentLive",
      targets: ["AppEnvironmentLive"]),
    .library(
      name: "TabsFeature",
      targets: ["TabsFeature"])
  ],
  dependencies: [
    .package(path: "../Authentication"),
    .package(path: "../Common"),
    .package(path: "../DesignSystem"),
    .package(path: "../Network"),
    .package(path: "../Profile"),
    .package(path: "../Takes"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0"),
    .package(url: "https://github.com/darrarski/swift-composable-presentation", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "App",
      dependencies: [
        "TabsFeature",
        .product(name: "AmplifyClient", package: "Network"),
        .product(name: "AuthenticationClient", package: "Authentication"),
        .product(name: "AuthenticationFeature", package: "Authentication"),
        .product(name: "Utility", package: "Common"),
        .product(name: "FontsLibrary", package: "DesignSystem"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .target(
      name: "AppEnvironmentLive",
      dependencies: [
        "App",
        .product(name: "AmplifyClientLive", package: "Network"),
        .product(name: "AuthenticationClientLive", package: "Network")
      ]
    ),
    .target(
      name: "TabsFeature",
      dependencies: [
        .product(name: "AuthenticationClient", package: "Authentication"),
        .product(name: "ComposeTakesFeature", package: "Takes"),
        .product(name: "MyProfileFeature", package: "Profile"),
        .product(name: "StyleGuide", package: "DesignSystem"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [.process("Resources")]
    )
  ]
)
