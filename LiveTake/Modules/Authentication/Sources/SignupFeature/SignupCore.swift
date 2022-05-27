import AuthenticationClient
import ComposableArchitecture
import PhoneEntryStepFeature
import OTPEntryStepFeature
import UsernameEntryStepFeature
import UsernameVerificationStepFeature
import ProfileInfoEntryStepFeature
import LoadingStepFeature
import PasswordEntryStepFeature

struct AuthContext: Equatable {
  var phoneNumber: String
  var username: String?
  var password: String?

  var name: String?
  var email: String?
  var birthDate: Date?

  static let draff = Self(phoneNumber: "")
}

public struct SignupState: Equatable {
  var initialStep: Step1PhoneEntryStepState

  public init(
  ) {
    self.initialStep = .init(context: .draff, state: .init(entryPoint: .signup))
  }
}

public enum SignupAction: Equatable {
  case step1_PhoneEntry(Step1PhoneEntryStepAction)
  case success

  static let successCaseWithUsernameVerification: Self =
    .step1_PhoneEntry(
      .nextAction(
        .usernameEntry(
          .nextAction(
            .usernameVerification(
              .nextAction(
                .password(
                  .nextAction(
                    .profileInfo(
                      .nextAction(
                        .loading(.loading(.finishedLoading))
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )

  static let successCaseWithoutUsernameVerification: Self =
    .step1_PhoneEntry(
      .nextAction(
        .usernameEntry(
          .nextAction(
            .password(
              .nextAction(
                .profileInfo(
                  .nextAction(
                    .loading(.loading(.finishedLoading))
                  )
                )
              )
            )
          )
        )
      )
    )
}

// MARK: - Environment

public struct SignupEnvironment {
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

extension SignupEnvironment {
  public static let noop = Self(
    authentication: .noop,
    mainQueue: .immediate
  )
}

extension SignupEnvironment {
  var step1_PhoneEntry: PhoneEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step2_OTPEntry: OTPEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step3_UsernameEntry: UsernameEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step3_1_UsernameVerification: UsernameVerificationStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step4_PasswordEntry: PasswordEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step5_ProfileInfo: ProfileInfoEntryStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }

  var step6_Loading: LoadingStepEnvironment {
    .init(mainQueue: self.mainQueue)
  }
}

// MARK: - Reducer

public let signupReducer: Reducer<
  SignupState,
  SignupAction,
  SignupEnvironment
> = .combine(
  step1Reducer.pullback(
    state: \.initialStep,
    action: /SignupAction.step1_PhoneEntry,
    environment: { $0 }
  ),

  Reducer { _, action, _ in
    switch action {
    case .successCaseWithoutUsernameVerification:
      return Effect(value: .success)

    case .successCaseWithUsernameVerification:
      return Effect(value: .success)

    case .step1_PhoneEntry:
      return .none

    case .success:
      return .none
    }
  }
)
