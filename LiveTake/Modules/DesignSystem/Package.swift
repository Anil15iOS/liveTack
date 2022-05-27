// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DesignSystem",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "AssetsLibrary",
      targets: ["AssetsLibrary"]),
    .library(
      name: "FontsLibrary",
      targets: ["FontsLibrary"]),
    .library(
      name: "StyleGuide",
      targets: ["StyleGuide"])
  ],
  dependencies: [
    .package(path: "../Common")
  ],
  targets: [
    .target(
      name: "AssetsLibrary",
      dependencies: [
        .product(name: "Utility", package: "Common")
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "FontsLibrary",
      resources: [
        .copy("Resources/Fonts")
      ]
    ),
    .target(
      name: "StyleGuide",
      dependencies: [])
  ]
)
