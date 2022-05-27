// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Profile",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "AboutFeature",
      targets: ["AboutFeature"]),
    .library(
      name: "ChangePasswordFeature",
      targets: ["ChangePasswordFeature"]),
    .library(
      name: "EditPersonalInformationFeature",
      targets: ["EditPersonalInformationFeature"]),
    .library(
      name: "EditProfileFeature",
      targets: ["EditProfileFeature"]),
    .library(
      name: "MyProfileFeature",
      targets: ["MyProfileFeature"]),
    .library(
      name: "NotificationSettingsFeature",
      targets: ["NotificationSettingsFeature"]),
    .library(
      name: "OtherUserProfileFeature",
      targets: ["OtherUserProfileFeature"]),
    .library(
      name: "PrivacySettingsFeature",
      targets: ["PrivacySettingsFeature"]),
    .library(
      name: "ProfileFeature",
      targets: ["ProfileFeature"]),
    .library(
      name: "ReportUserFeature",
      targets: ["ReportUserFeature"]),
    .library(
      name: "UserListFeature",
      targets: ["UserListFeature"])
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
      name: "AboutFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "ChangePasswordFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "EditProfileFeature",
      dependencies: [
        "AboutFeature",
        "EditPersonalInformationFeature",
        "NotificationSettingsFeature",
        "PrivacySettingsFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem"),
        .product(name: "TCAHelpers", package: "Common")
      ]
    ),
    .target(
      name: "EditPersonalInformationFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "MyProfileFeature",
      dependencies: [
        "EditProfileFeature",
        "ProfileFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ],
      resources: [.process("Resources")]
    ),
    .target(
      name: "NotificationSettingsFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "OtherUserProfileFeature",
      dependencies: [
        "ProfileFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "PrivacySettingsFeature",
      dependencies: [
        "ChangePasswordFeature",
        "UserListFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "TCAHelpers", package: "Common"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "ProfileFeature",
      dependencies: [
        .product(name: "BottomSheet", package: "Components"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "StyleGuide", package: "DesignSystem"),
        .product(name: "Utility", package: "Common")
      ],
      resources: [.process("Resources")]
    ),
    .target(
      name: "ReportUserFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    ),
    .target(
      name: "UserListFeature",
      dependencies: [
        "OtherUserProfileFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "StyleGuide", package: "DesignSystem")
      ]
    )
  ]
)
