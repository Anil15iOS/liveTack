// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Network",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "AmplifyClient",
      targets: ["AmplifyClient"]),
    .library(
      name: "AmplifyClientLive",
      targets: ["AmplifyClientLive"]),
    .library(
      name: "AuthenticationClientLive",
      targets: ["AuthenticationClientLive"])
  ],
  dependencies: [
    .package(path: "../Authentication"),
    .package(name: "Amplify", url: "https://github.com/aws-amplify/amplify-ios", .upToNextMajor(from: "1.19.2")),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0")
  ],
  targets: [
    .target(
      name: "AmplifyClient",
      dependencies: [
      ]
    ),
    .target(
      name: "AmplifyClientLive",
      dependencies: [
        "AmplifyClient",
        .product(name: "Amplify", package: "Amplify"),
        .product(name: "AWSAPIPlugin", package: "Amplify"),
        .product(name: "AWSCognitoAuthPlugin", package: "Amplify")
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "AuthenticationClientLive",
      dependencies: [
        .product(name: "Amplify", package: "Amplify"),
        .product(name: "AuthenticationClient", package: "Authentication"),
        .product(name: "AWSCognitoAuthPlugin", package: "Amplify")
      ]
    )
  ]
)

package.targets.forEach {
  $0.dependencies.append(
    .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
  )
}
