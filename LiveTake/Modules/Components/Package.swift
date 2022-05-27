// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Components",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "BottomSheet",
      targets: ["BottomSheet"]),
    .library(
      name: "PhoneNumberField",
      targets: ["PhoneNumberField"]),
    .library(
      name: "PhotoPicker",
      targets: ["PhotoPicker"])
  ],
  dependencies: [
    .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.3.3"))
  ],
  targets: [
    .target(name: "BottomSheet"),
    .target(
      name: "PhoneNumberField",
      dependencies: [
        .product(name: "PhoneNumberKit", package: "PhoneNumberKit")
      ],
      resources: [
        .process("Resources/PhoneNumberMetadata.json")
      ]
    ),
    .target(name: "PhotoPicker")
  ]
)
