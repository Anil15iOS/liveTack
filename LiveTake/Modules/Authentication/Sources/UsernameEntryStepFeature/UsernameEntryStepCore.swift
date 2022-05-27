import AuthContainerFeature
import ComposableArchitecture

public struct UsernameEntryStepState: Equatable {
  static let minUsernameChars = 2

  @BindableState var isFocused: Bool
  @BindableState var isValid: Bool
  @BindableState var nextButtonState: NextButtonState
  @BindableState public var username: String

  public init(
    isFocused: Bool = false,
    isValid: Bool = false,
    nextButtonState: NextButtonState = .disabled,
    username: String = ""
  ) {
    self.isFocused = isFocused
    self.isValid = isValid
    self.nextButtonState = nextButtonState
    self.username = username
  }
}

// MARK: - Action

public enum UsernameEntryStepAction: BindableAction, Equatable {
  case binding(BindingAction<UsernameEntryStepState>)
  case next(username: String)
  case nextButtonTapped
  case onAppear
  case showKeyboard(Bool)
  case validate
}

public struct UsernameEntryStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension UsernameEntryStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

// MARK: - Reducer

public let usernameEntryStepReducer: Reducer<
  UsernameEntryStepState,
  UsernameEntryStepAction,
  UsernameEntryStepEnvironment
> = .init { state, action, environment in
  switch action {
  case .binding(\.$username):
    return Effect(value: .validate)

  case .binding:
    return .none

  case .next:
    return .none

  case .nextButtonTapped:
    return .concatenate(
      Effect(value: .showKeyboard(false)),

      Effect(value: .next(username: state.username))
        .delay(for: 0.5, scheduler: AnySchedulerOf<DispatchQueue>.main)
        .eraseToEffect()
    )

  case .onAppear:
    return Effect(value: .showKeyboard(true))
    // show keyboard after 0.5 seconds
      .delay(for: 0.5, scheduler: environment.mainQueue)
      .eraseToEffect()

  case .showKeyboard(let isShown):
    state.isFocused = isShown
    return .none

  case .validate:
    state.isValid = state.username.count >= UsernameEntryStepState.minUsernameChars
    state.nextButtonState = state.isValid ? .enabled : .disabled
    return .none
  }
}
.binding()
