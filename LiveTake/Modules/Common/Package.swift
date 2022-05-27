// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Common",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "Utility",
      targets: ["Utility"]
    ),
    .library(
      name: "TCAHelpers",
      targets: ["TCAHelpers"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.7.0"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0")
  ],
  targets: [
    .target(
      name: "Utility",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths")
      ]
    ),
    .target(
      name: "TCAHelpers",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    )
  ]
)
