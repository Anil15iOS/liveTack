import App
import AmplifyClientLive
import AuthenticationClientLive

extension AppEnvironment {
  public static var live: Self {
    .init(
      amplifyClient: .live,
      authentication: .live,
      mainQueue: .main
    )
  }
}
