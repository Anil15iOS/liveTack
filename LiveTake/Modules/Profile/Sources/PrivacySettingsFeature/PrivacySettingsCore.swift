import ChangePasswordFeature
import ComposableArchitecture
import UserListFeature

public struct PrivacySettingsState: Equatable {
  var route: Route?

  public init() {
  }
}

extension PrivacySettingsState {
  public enum Route: Equatable {
    case blockedUsers(UserListState)
    case changePassword(ChangePasswordState)

    public enum Tag: Int {
      case blockedUsers
      case changePassword
    }
  }
}

public enum PrivacySettingsAction: BindableAction, Equatable {
  case didAppear
  case binding(BindingAction<PrivacySettingsState>)
  case blockedUserButtonTapped
  case changePasswordButtonTapped
  case navigate(to: PrivacySettingsState.Route.Tag?)
  case route(RouteAction)
}

extension PrivacySettingsAction {
  public enum RouteAction: Equatable {
    case blockedUsers(UserListAction)
    case changePassword(ChangePasswordAction)
  }
}

public struct PrivacySettingsEnvironment {
  public init() {
  }
}

extension PrivacySettingsEnvironment {
  static let noop = Self()
}

extension PrivacySettingsEnvironment {
  var blockedUser: UserListEnvironment {
    .init()
  }

  var changePassword: ChangePasswordEnvironment {
    .init()
  }
}

private let routeReducer = Reducer<
  PrivacySettingsState.Route,
  PrivacySettingsAction.RouteAction,
  PrivacySettingsEnvironment
>.empty
.presenting(
  userListReducer,
  state: .casePath(/PrivacySettingsState.Route.blockedUsers),
  id: .notNil(),
  action: /PrivacySettingsAction.RouteAction.blockedUsers,
  environment: \.blockedUser
)
.presenting(
  changePasswordReducer,
  state: .casePath(/PrivacySettingsState.Route.changePassword),
  id: .notNil(),
  action: /PrivacySettingsAction.RouteAction.changePassword,
  environment: \.changePassword
)

public let privacySettingsReducer = Reducer<
  PrivacySettingsState, PrivacySettingsAction, PrivacySettingsEnvironment
> .combine(
  routeReducer.optional()
    .pullback(
      state: \.route,
      action: /PrivacySettingsAction.route,
      environment: { $0 }
    ),

  Reducer { state, action, _ in
    switch action {
    case .didAppear:
      return .none
    case .binding:
      return .none
    case .blockedUserButtonTapped:
      return .init(value: .navigate(to: .blockedUsers))
    case .changePasswordButtonTapped:
      return .init(value: .navigate(to: .changePassword))
    case .navigate(to: .blockedUsers):
      state.route = .blockedUsers(
        .init(
          blockedUsers: IdentifiedArrayOf(
            uniqueElements: (1...5)
              .map(UserListState.BlockedUser.init(id:))
          )
        )
      )
      return .none
    case .navigate(to: .changePassword):
      state.route = .changePassword(.init())
      return .none
    case .navigate(to: .none):
      state.route = .none
      return .none
    case .route:
      return .none
    }
  }
)
.binding()
