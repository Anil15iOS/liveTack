// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Authentication",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "AuthContainerFeature",
      targets: ["AuthContainerFeature"]),
    .library(
      name: "AuthenticationClient",
      targets: ["AuthenticationClient"]),
    .library(
      name: "AuthenticationFeature",
      targets: ["AuthenticationFeature"]),
    .library(
      name: "LoadingStepFeature",
      targets: ["LoadingStepFeature"]),
    .library(
      name: "LoginFeature",
      targets: ["LoginFeature"]),
    .library(
      name: "OTPEntryStepFeature",
      targets: ["OTPEntryStepFeature"]),
    .library(
      name: "PasswordEntryStepFeature",
      targets: ["PasswordEntryStepFeature"]),
    .library(
      name: "PhoneEntryStepFeature",
      targets: ["PhoneEntryStepFeature"]),
    .library(
      name: "ProfileInfoEntryStepFeature",
      targets: ["ProfileInfoEntryStepFeature"]),
    .library(
      name: "SignupFeature",
      targets: ["SignupFeature"]),
    .library(
      name: "UsernameEntryStepFeature",
      targets: ["UsernameEntryStepFeature"]),
    .library(
      name: "UsernameVerificationStepFeature",
      targets: ["UsernameVerificationStepFeature"])
  ],
  dependencies: [
    .package(path: "../Common"),
    .package(path: "../Components"),
    .package(path: "../DesignSystem"),
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.34.0"),
    .package(url: "https://github.com/darrarski/swift-composable-presentation", from: "0.4.0")
  ],
  targets: [
    .target(
      name: "AuthContainerFeature",
      dependencies: [
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(name: "AuthenticationClient"),
    .target(
      name: "AuthenticationFeature",
      dependencies: [
        "AuthenticationClient",
        "LoginFeature",
        "SignupFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "StyleGuide", package: "DesignSystem"),
        .product(name: "TCAHelpers", package: "Common")
      ],
      resources: [
        .process("Resources/")
      ]
    ),
    .target(
      name: "LoadingStepFeature",
      dependencies: [
        "AuthContainerFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation")
      ]
    ),
    .target(
      name: "LoginFeature",
      dependencies: [
        "AuthenticationClient",
        "LoadingStepFeature",
        "OTPEntryStepFeature",
        "PasswordEntryStepFeature",
        "PhoneEntryStepFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "TCAHelpers", package: "Common")
      ]
    ),
    .target(
      name: "OTPEntryStepFeature",
      dependencies: [
        "AuthContainerFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "Utility", package: "Common")
      ]
    ),
    .target(
      name: "PasswordEntryStepFeature",
      dependencies: [
        "AuthContainerFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "Utility", package: "Common")
      ]
    ),
    .target(
      name: "PhoneEntryStepFeature",
      dependencies: [
        "AuthContainerFeature",
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "PhoneNumberField", package: "Components"),
        .product(name: "Utility", package: "Common")
      ]
    ),
    .target(
      name: "ProfileInfoEntryStepFeature",
      dependencies: [
        "AuthContainerFeature",
        .product(name: "PhotoPicker", package: "Components"),
        .product(name: "Utility", package: "Common")
      ]
    ),
    .target(
      name: "SignupFeature",
      dependencies: [
        "AuthenticationClient",
        "LoadingStepFeature",
        "OTPEntryStepFeature",
        "PasswordEntryStepFeature",
        "PhoneEntryStepFeature",
        "ProfileInfoEntryStepFeature",
        "UsernameEntryStepFeature",
        "UsernameVerificationStepFeature"
      ]
    ),
    .target(
      name: "UsernameEntryStepFeature",
      dependencies: [
        "AuthContainerFeature"
      ]
    ),
    .target(
      name: "UsernameVerificationStepFeature",
      dependencies: [
        "AuthContainerFeature"
      ]
    )
  ]
)

package.targets.forEach {
  $0.dependencies.append(
    .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
  )
}
