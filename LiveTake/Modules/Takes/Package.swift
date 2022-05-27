// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Takes",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "ComposeTakesFeature",
      targets: ["ComposeTakesFeature"])
  ],
  dependencies: [
    .package(path: "../Common"),
    .package(path: "../Components"),
    .package(path: "../DesignSystem"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.28.1"),
    .package(url: "https://github.com/darrarski/swift-composable-presentation", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "ComposeTakesFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "PhoneNumberField", package: "Components"),
        .product(name: "AssetsLibrary", package: "DesignSystem"),
        .product(name: "StyleGuide", package: "DesignSystem"),
        .product(name: "Utility", package: "Common")
      ]
    )
  ]
)
