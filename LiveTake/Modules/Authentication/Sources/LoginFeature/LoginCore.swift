import AuthenticationClient
import ComposableArchitecture
import PasswordEntryStepFeature
import PhoneEntryStepFeature
import LoadingStepFeature
import OTPEntryStepFeature

public struct LoginState: Equatable {
  var initialStep: Step1PhoneEntryStepState

  public init(
  ) {
    self.initialStep = .init(state: .init(entryPoint: .login))
  }
}

public enum LoginAction: Equatable {
  case step1_PhoneEntry(Step1PhoneEntryStepAction)
  case success

  static let successCase: Self = .step1_PhoneEntry(
    .password(
      .nextAction(
        .loading(
          .loading(.finishedLoading)
        )
      )
    )
  )
}

// MARK: - Environment

public struct LoginEnvironment {
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

extension LoginEnvironment {
  public static let noop = Self(
    authentication: .noop,
    mainQueue: .immediate
  )
}

extension LoginEnvironment {
  var step1_PhoneEntry: PhoneEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step2_PasswordEntry: PasswordEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }
  var step2_1_OTPEntry: OTPEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step2_2_PasswordEntry: PasswordEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step3_Loading: LoadingStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }
}


// MARK: - Reducer

public let loginReducer: Reducer<
  LoginState,
  LoginAction,
  LoginEnvironment
> = .combine(
  step1Reducer.pullback(
    state: \.initialStep,
    action: /LoginAction.step1_PhoneEntry,
    environment: { $0 }
  ),

  Reducer { _, action, _ in
    switch action {
    case .successCase:
      return Effect(value: .success)

    case .step1_PhoneEntry:
      return .none

    case .success:
      return .none
    }
  }
)
