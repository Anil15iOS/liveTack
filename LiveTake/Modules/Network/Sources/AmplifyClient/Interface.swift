import ComposableArchitecture

public struct AmplifyClient {
  public var configure: Effect<Void, Error>

  public init(
    configure: Effect<Void, Error>
  ) {
    self.configure = configure
  }
}

// MARK: - Failing

extension AmplifyClient {
  public static let failing = Self(
    configure: .failing("\(Self.self).configure is not implemented")
  )
}

// MARK: - Noop

extension AmplifyClient {
  public static let noop = Self(
    configure: .none
  )
}
