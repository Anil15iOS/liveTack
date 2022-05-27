import AuthenticationClient
import ComposableArchitecture
import ComposablePresentation
import LoginFeature
import SignupFeature

public struct AuthenticationState: Equatable {
  @BindableState var route: Route?

  public init(route: Route? = nil) {
    self.route = route
  }
}

extension AuthenticationState {
  public enum Route: Equatable {
    case signup(SignupState)
    case login(LoginState)

    public enum Tag: Int {
      case signup
      case login
    }

    var tag: Tag {
      switch self {
      case .signup:
        return .signup
      case .login:
        return .login
      }
    }
  }
}

public enum AuthenticationAction: Equatable, BindableAction {
  case getStartedButtonTapped
  case signInButtonTapped

  case finishedAuthentication

  case setRoute(for: AuthenticationState.Route.Tag?)
  case route(RouteAction)

  case binding(BindingAction<AuthenticationState>)
}

extension AuthenticationAction {
  public enum RouteAction: Equatable {
    case signup(SignupAction)
    case login(LoginAction)
  }
}

public struct AuthenticationEnvironment {
  public var authentication: AuthenticationClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public init(
    authentication: AuthenticationClient,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.authentication = authentication
    self.mainQueue = mainQueue
  }
}

extension AuthenticationEnvironment {
  var login: LoginEnvironment {
    .init(
      authentication: self.authentication,
      mainQueue: self.mainQueue
    )
  }

  var signup: SignupEnvironment {
    .init(
      authentication: self.authentication,
      mainQueue: self.mainQueue
    )
  }
}

extension AuthenticationEnvironment {
  public static let noop = Self(
    authentication: .noop,
    mainQueue: .immediate
  )
}

// MARK: - Reducer

private let routeReducer = Reducer<
  AuthenticationState.Route,
  AuthenticationAction.RouteAction,
  AuthenticationEnvironment
>.combine(
  signupReducer.pullback(
    state: /AuthenticationState.Route.signup,
    action: /AuthenticationAction.RouteAction.signup,
    environment: \.signup
  ),

  loginReducer.pullback(
    state: /AuthenticationState.Route.login,
    action: /AuthenticationAction.RouteAction.login,
    environment: \.login
  )
)

public let authenticationReducer = Reducer<
  AuthenticationState,
  AuthenticationAction,
  AuthenticationEnvironment
> { state, action, _ in
  switch action {
  case .getStartedButtonTapped:
    return Effect(value: .setRoute(for: .signup))
  case .signInButtonTapped:
    return Effect(value: .setRoute(for: .login))

  case .finishedAuthentication:
    return .none

  case .setRoute(.signup):
    state.route = .signup(.init())
    return .none

  case .setRoute(.login):
    state.route = .login(.init())
    return .none

  case .setRoute(.none):
    state.route = nil
    return .none

  case .route(.login(.success)):
    return Effect(value: .finishedAuthentication)

  case .route(.signup(.success)):
    return Effect(value: .finishedAuthentication)

  case .route:
    return .none

  case .binding:
    return .none
  }
}
.presenting(
  routeReducer,
  state: .keyPath(\.route),
  id: .notNil(),
  action: /AuthenticationAction.route,
  environment: { $0 }
)
.binding()
