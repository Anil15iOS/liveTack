//
//  EditProfileCore.swift
//  
//
//  Created by Laura Guo on 3/4/22.
//

import AboutFeature
import ComposableArchitecture
import EditPersonalInformationFeature
import NotificationSettingsFeature
import PrivacySettingsFeature

public struct EditProfileState: Equatable {
//  @BindableState var profileImage: Image
  @BindableState var username: String
  @BindableState var bio: String
  @BindableState var name: String

  var route: Route?

  public init(
//    profileImage: Image = Image("brettokamoto", bundle: .module),
    name: String = "Kenny Stewart",
    username: String = "easymoneysniper",
    bio: String = "",
    route: Route? = nil
  ) {
//    self.profileImage = profileImage
    self.username = username
    self.bio = bio
    self.name = name
    self.route = route
  }
}

extension EditProfileState {
  public enum Route: Equatable {
    case personalInformation(PersonalInformationState)
    case notificationSettings(NotificationSettingsState)
    case privacySettings(PrivacySettingsState)
    case about(AboutState)

    public enum Tag: Int {
      case personalInformation
      case notificationSettings
      case privacySettings
      case about
    }

    var tag: Tag {
      switch self {
      case .personalInformation:
        return .personalInformation
      case .notificationSettings:
        return .notificationSettings
      case .privacySettings:
        return .privacySettings
      case .about:
        return .about
      }
    }
  }
}

public enum EditProfileAction: BindableAction, Equatable {
  case binding(BindingAction<EditProfileState>)
  case onAppear
  case navigate(to: EditProfileState.Route.Tag?)
  case route(RouteAction)
  case logout
  case logoutButtonTapped
}

extension EditProfileAction {
  public enum RouteAction: Equatable {
    case personalInformation(PersonalInformationAction)
    case notificationSettings(NotificationSettingsAction)
    case privacySettings(PrivacySettingsAction)
    case about(AboutAction)
  }
}

// MARK: - Environment

public struct EditProfileEnvironment {
  public init(
  ) {
  }
}

extension EditProfileEnvironment {
  public static let noop = Self()
}

// MARK: - Reducers

private let routeReducer = Reducer<
  EditProfileState.Route,
  EditProfileAction.RouteAction,
  EditProfileEnvironment
>.empty
  .presenting(
    notificationSettingsReducer,
    state: .casePath(/EditProfileState.Route.notificationSettings),
    id: .notNil(),
    action: /EditProfileAction.RouteAction.notificationSettings,
    environment: { _ in  .init(mainQueue: .main) }
  )
  .presenting(
    privacySettingsReducer,
    state: .casePath(/EditProfileState.Route.privacySettings),
    id: .notNil(),
    action: /EditProfileAction.RouteAction.privacySettings,
    environment: { _ in  .init() }
  )
  .presenting(
    aboutReducer,
    state: .casePath(/EditProfileState.Route.about),
    id: .notNil(),
    action: /EditProfileAction.RouteAction.about,
    environment: { _ in  .init() }
  )

public let editProfileReducer: Reducer<
  EditProfileState, EditProfileAction, EditProfileEnvironment
> = .combine(
  routeReducer.optional().pullback(
    state: \.route,
    action: /EditProfileAction.route,
    environment: { $0 }
  ),

  Reducer { state, action, _ in
    switch action {
    case .binding:
      return .none
    case .onAppear:
      return .none

    case .navigate(to: .personalInformation):
      state.route = .personalInformation(.init())
      return .none

    case .navigate(to: .notificationSettings):
      state.route = .notificationSettings(.init())
      return .none

    case .navigate(to: .privacySettings):
      state.route = .privacySettings(.init())
      return .none

    case .navigate(to: .about):
      state.route = .about(.init())
      return .none

    case .navigate(to: .none):
      state.route = .none
      return .none

    case .route:
      return .none

    case .logout:
      return .none

    case .logoutButtonTapped:
      return Effect(value: .logout)
    }
  }
)
.binding()
