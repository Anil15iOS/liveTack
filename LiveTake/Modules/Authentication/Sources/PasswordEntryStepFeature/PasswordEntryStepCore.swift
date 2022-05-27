import AuthContainerFeature
import ComposableArchitecture

public struct PasswordEntryStepState: Equatable {
  static let mininumPasswordLength = 6

  public enum EntryPoint: CaseIterable {
    case forgotPassword
    case login
    case signup
  }

  @BindableState var agreedToTermsAndPolicy: Bool
  let entryPoint: EntryPoint
  @BindableState var isFocused: Bool
  @BindableState var isValid: Bool
  @BindableState var nextButtonState: NextButtonState
  @BindableState var password: String

  public init(
    agreedToTermsAndPolicy: Bool = false,
    entryPoint: EntryPoint,
    isFocused: Bool = false,
    isValid: Bool = false,
    nextButtonState: NextButtonState = .disabled,
    password: String = ""
  ) {
    self.agreedToTermsAndPolicy = agreedToTermsAndPolicy
    self.entryPoint = entryPoint
    self.isFocused = isFocused
    self.isValid = isValid
    self.nextButtonState = nextButtonState
    self.password = password
  }
}

public enum PasswordEntryStepAction: BindableAction, Equatable {
  case binding(BindingAction<PasswordEntryStepState>)
  case dismiss
  case forgotPasswordButtonTapped
  case onAppear
  case next(password: String)
  case nextButtonTapped
  case showKeyboard(Bool)
  case validate(PasswordEntryStepState.EntryPoint)
}

public struct PasswordEntryStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension PasswordEntryStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

// MARK: - Reducer

public let passwordEntryStepReducer: Reducer<
  PasswordEntryStepState,
  PasswordEntryStepAction,
  PasswordEntryStepEnvironment
> = .init { state, action, environment in
  switch action {
  case .binding(\.$agreedToTermsAndPolicy):
    return Effect(value: .validate(state.entryPoint))

  case .binding(\.$password):
    return Effect(value: .validate(state.entryPoint))

  case .binding:
    return .none

  case .dismiss:
    return .none

  case .forgotPasswordButtonTapped:
    return .none

  case .onAppear:
    return Effect(value: .showKeyboard(true))
    // show keyboard after 0.5 seconds
      .delay(for: 0.5, scheduler: environment.mainQueue)
      .eraseToEffect()

  case .next:
    return .none

  case .nextButtonTapped:
    return .concatenate(
      Effect(value: .showKeyboard(false)),

      Effect(value: .next(password: state.password))
        .delay(for: 0.5, scheduler: environment.mainQueue)
        .eraseToEffect()
    )

  case .showKeyboard(let isShown):
    state.isFocused = isShown
    return .none

  case .validate(.forgotPassword):
    state.isValid = state.password.count >= PasswordEntryStepState.mininumPasswordLength
    state.nextButtonState = state.isValid ? .enabled : .disabled
    return .none

  case .validate(.login):
    state.isValid = state.password.count >= PasswordEntryStepState.mininumPasswordLength
    state.nextButtonState = state.isValid ? .enabled : .disabled
    return .none

  case .validate(.signup):
    state.isValid = state.password.count >= PasswordEntryStepState.mininumPasswordLength
    let isNextEnabled = state.isValid && state.agreedToTermsAndPolicy
    state.nextButtonState = isNextEnabled ? .enabled : .disabled
    return .none
  }
}
.binding()
