import ComposableArchitecture
import EditProfileFeature
import ProfileFeature

// MARK: - State

public struct MyProfileState: Equatable {
  var editProfileState: EditProfileState?
  var alert: AlertState<MyProfileAction.AlertAction>?

  var profile: ProfileState

  public init(
    alert: AlertState<MyProfileAction.AlertAction>? = nil
  ) {
    self.alert = alert
    self.profile = .init(viewMode: .loggedInUser)
  }
}

// MARK: - Action

public enum MyProfileAction: Equatable {
  case alert(AlertAction)
  case dismissedSettings
  case editProfile(EditProfileAction)
  case onAppear
  case notificationsButtonTapped
  case settingsButtonTapped
  case playbookButtonTapped
  case profile(ProfileAction)
}

extension MyProfileAction {
  public enum AlertAction: Equatable {
    case dismiss
  }
}

// MARK: - Environment

public struct MyProfileEnvironment {
  public init() {
  }
}


extension MyProfileEnvironment {
  static let noop = Self()
}

extension MyProfileEnvironment {
  var editProfile: EditProfileEnvironment {
    .init()
  }

  var profile: ProfileEnvironment {
    .init()
  }
}

// MARK: - Reducers

public let myProfileReducer = Reducer<
  MyProfileState, MyProfileAction, MyProfileEnvironment
> .combine(
  profileReducer.pullback(
    state: \.profile,
    action: /MyProfileAction.profile,
    environment: \.profile
  ),

  Reducer { state, action, _ in
    switch action {
    case .alert(.dismiss):
      state.alert = nil
      return .none

    case .dismissedSettings:
      state.editProfileState = nil
      return .none

    case .editProfile(.logout):
      return .init(value: .dismissedSettings)

    case .editProfile:
      return .none

    case .onAppear:
      return .none

    case .notificationsButtonTapped:
      state.alert = .init(title: .init("Notifications goes here"))
      return .none

    case .settingsButtonTapped:
      state.editProfileState = .init()
      return .none

    case .playbookButtonTapped:
      state.alert = .init(title: .init("Play book goes here"))
      return .none

    case .profile:
      return .none
    }
  }
)
.presenting(
  editProfileReducer,
  state: .keyPath(\.editProfileState),
  id: .notNil(),
  action: /MyProfileAction.editProfile,
  environment: \.editProfile
)
