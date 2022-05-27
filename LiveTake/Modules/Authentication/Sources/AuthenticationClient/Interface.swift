import ComposableArchitecture

public struct LoginRequest: Equatable {
  let _phoneNumber: String
  public let password: String

  public var phoneNumber: String {
    sanitize(phoneNumber: _phoneNumber)
  }

  public init(
    phoneNumber: String,
    password: String
  ) {
    self._phoneNumber = phoneNumber
    self.password = password
  }
}

public struct SignUpRequest: Equatable {
  let _phoneNumber: String
  public let username: String
  public let password: String
  public let name: String?
  public let email: String
  public let birthdate: Date?

  public var phoneNumber: String {
    sanitize(phoneNumber: _phoneNumber)
  }

  public init(
    phoneNumber: String,
    username: String,
    password: String,
    name: String?,
    email: String,
    birthdate: Date?
  ) {
    self._phoneNumber = phoneNumber
    self.username = username
    self.password = password
    self.name = name
    self.email = email
    self.birthdate = birthdate
  }
}

public func sanitize(phoneNumber: String) -> String {
  "+1\(phoneNumber.filter(\.isNumber))"
}

public struct AuthenticationClient {
  public var createUsername: (String) -> Effect<AuthSignUpStep, AuthClientError>
  public var deleteUser: () -> Effect<Void, AuthClientError>
  public var isSignedIn: () -> Effect<Bool, Never>
  public var isUsernameOnVerifiedList: (String) -> Effect<Bool, AuthClientError>
  public var login: (LoginRequest) -> Effect<AuthLoginStep, AuthClientError>
  public var logout: () -> Effect<AuthLogoutStep, AuthClientError>
  public var signUp: (SignUpRequest) -> Effect<AuthSignUpStep, AuthClientError>
  public var verifyUserExists: (String) -> Effect<Bool, AuthClientError>

  public init(
    createUsername: @escaping (String) -> Effect<AuthSignUpStep, AuthClientError>,
    deleteUser: @escaping () -> Effect<Void, AuthClientError>,
    isSignedIn: @escaping () -> Effect<Bool, Never>,
    isUsernameOnVerifiedList: @escaping (String) -> Effect<Bool, AuthClientError>,
    login: @escaping (LoginRequest) -> Effect<AuthLoginStep, AuthClientError>,
    logout: @escaping () -> Effect<AuthLogoutStep, AuthClientError>,
    signUp: @escaping (SignUpRequest) -> Effect<AuthSignUpStep, AuthClientError>,
    verifyUserExists: @escaping (String) -> Effect<Bool, AuthClientError>
  ) {
    self.createUsername = createUsername
    self.deleteUser = deleteUser
    self.isSignedIn = isSignedIn
    self.isUsernameOnVerifiedList = isUsernameOnVerifiedList
    self.login = login
    self.logout = logout
    self.signUp = signUp
    self.verifyUserExists = verifyUserExists
  }
}

// MARK: - Noop

extension AuthenticationClient {
  public static let noop = Self(
    createUsername: { _ in .none },
    deleteUser: { .none },
    isSignedIn: { .none },
    isUsernameOnVerifiedList: { _ in .none },
    login: { _ in .none },
    logout: { .none },
    signUp: { _ in .none },
    verifyUserExists: { _ in .none }
  )
}

public enum AuthSignUpStep {
  case registeringPhoneNumber
  case createUsername
  case verifyUsername
  case createPassword
  case done
}

public enum AuthLoginStep {
  case done
}

public enum AuthLogoutStep: Equatable {
  case done
}


/// Convenience typealias to disambiguate positional parameters of AmplifyErrors
public typealias ErrorDescription = String

/// Convenience typealias to disambiguate positional parameters of AmplifyErrors
public typealias RecoverySuggestion = String

public struct AuthClientError: Error, Equatable {
  public let description: ErrorDescription
  public let recoverySuggestion: RecoverySuggestion

  public init(
    description: ErrorDescription,
    recoverySuggestion: RecoverySuggestion
  ) {
    self.description = description
    self.recoverySuggestion = recoverySuggestion
  }
}
