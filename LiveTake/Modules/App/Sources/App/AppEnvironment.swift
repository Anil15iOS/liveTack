import AmplifyClient
import AuthenticationClient
import CombineSchedulers
import FontsLibrary

public struct AppEnvironment {
  public var amplifyClient: AmplifyClient
  public var authentication: AuthenticationClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    amplifyClient: AmplifyClient,
    authentication: AuthenticationClient,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.amplifyClient = amplifyClient
    self.authentication = authentication
    self.mainQueue = mainQueue
  }

  func registerFonts() {
    do { try autoRegisteringFont() } catch { dump(error) }
  }
}

// MARK: - Noop

extension AppEnvironment {
  public static let noop = Self(
    amplifyClient: .noop,
    authentication: .noop,
    mainQueue: .immediate
  )
}
