import AuthenticationClient
import AuthenticationFeature
import ComposableArchitecture
import SwiftUI
import TabsFeature

public struct AppState: Equatable {
  var alert: AlertState<AppAction.AlertAction>?
  var route: Route

  public init(
    alert: AlertState<AppAction.AlertAction>? = nil,
    route: Route = .launching
  ) {
    self.alert = alert
    self.route = route
  }
}

extension AppState {
  public enum Route: Equatable, Identifiable {
    case launching
    case authentication(AuthenticationState)
    case main(TabsState)

    public enum Tag: Hashable {
      case launching
      case authentication
      case main
    }

    public var id: Tag {
      switch self {
      case .launching:
        return .launching
      case .authentication:
        return .authentication
      case .main:
        return .main
      }
    }
  }
}

public enum AppAction: Equatable {
  case alert(AlertAction)
  case appDelegate(AppDelegateAction)
  case didChangeScenePhase(ScenePhase)

  case dismissedAuthentication
  case route(RouteAction)
  case navigate(toRoute: AppState.Route.Tag)

  case amplifyConfigurationResponse(Bool)
  case logoutResponse(Result<AuthLogoutStep, AuthClientError>)
}

extension AppAction {
  public enum AlertAction: Equatable {
    case dismiss
  }

  public enum RouteAction: Equatable {
    case authentication(AuthenticationAction)
    case main(TabsAction)
  }
}

extension AppEnvironment {
  var auth: AuthenticationEnvironment {
    .init(
      authentication: self.authentication,
      mainQueue: self.mainQueue
    )
  }

  var main: TabsEnvironment {
    .init(
      authentication: self.authentication,
      mainQueue: self.mainQueue
    )
  }
}

// MARK: - Reducers

private let routeReducer: Reducer<
  AppState.Route,
  AppAction.RouteAction,
  AppEnvironment
> = .init { _, _, _ in
  return .none
}
  .presenting(
    tabsReducer,
    state: .casePath(/AppState.Route.main),
    id: .notNil(),
    action: /AppAction.RouteAction.main,
    environment: \.main
  )
  .presenting(
    authenticationReducer,
    state: .casePath(/AppState.Route.authentication),
    id: .notNil(),
    action: /AppAction.RouteAction.authentication,
    environment: \.auth
  )

public let appReducer: Reducer<
  AppState,
  AppAction,
  AppEnvironment
> = .combine(
  routeReducer.pullback(
    state: \.route,
    action: /AppAction.route,
    environment: { $0 }
  ),

  appReducerCore
)
  .debug()

let appReducerCore = Reducer<
  AppState,
  AppAction,
  AppEnvironment
> { state, action, environment in
  switch action {
  case .alert(.dismiss):
    state.alert = nil
    return .none

  case .appDelegate(.didFinishLaunching):
    return .merge(
      environment.amplifyClient.configure
      .map { $0 == () }
      .replaceError(with: false)
      .map(AppAction.amplifyConfigurationResponse)
      .receive(on: environment.mainQueue)
      .eraseToEffect(),
      .fireAndForget {
        environment.registerFonts()
      }
    )

  case .appDelegate:
    return .none

  case .didChangeScenePhase:
    return .none

  case .navigate(toRoute: .authentication):
    state.route = .authentication(.init())
    return .none

  case .navigate(toRoute: .main):
    state.route = .main(.init())
    return .none

  case .navigate(toRoute: .launching):
    state.route = .launching
    return .none

  case .dismissedAuthentication:
    return Effect(value: .navigate(toRoute: .main))

  case .route(.authentication(.finishedAuthentication)):
    return Effect(value: .navigate(toRoute: .main))

  case .route(.main(.profile(.editProfile(.logout)))):
    return environment.authentication.logout()
      .receive(on: environment.mainQueue.animation())
      .catchToEffect(AppAction.logoutResponse)

  case .route:
    return .none

  case .amplifyConfigurationResponse(false):
    state.alert = .init(
      title: TextState("😩"),
      message: TextState("Amplify wasn't configured."),
      buttons: []
    )
    return .none

  case .amplifyConfigurationResponse(true):
    return environment.authentication.isSignedIn()
      .receive(on: environment.mainQueue)
      .map {
        AppAction.navigate(toRoute: $0 ? .main : .authentication)
      }
      .eraseToEffect()

  case .logoutResponse(.success):
    return Effect(value: .navigate(toRoute: .authentication))

  case .logoutResponse(.failure):
    // still bring them to the welcome screen even if it fails
    return Effect(value: .navigate(toRoute: .authentication))
  }
}
