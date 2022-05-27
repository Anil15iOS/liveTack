import AuthContainerFeature
import ComposableArchitecture

public struct PhoneEntryStepState: Equatable {
  let entryPoint: EntryPoint
  @BindableState var isFocused: Bool
  @BindableState var isValid: Bool
  @BindableState public var phoneNumber: String
  @BindableState public var nextButtonState: NextButtonState

  public init(
    entryPoint: EntryPoint,
    isFocused: Bool = false,
    isValid: Bool = false,
    phoneNumber: String? = nil,
    nextButtonState: NextButtonState = .disabled
  ) {
    self.entryPoint = entryPoint
    self.isFocused = isFocused
    self.isValid = isValid
    self.phoneNumber = phoneNumber ?? ""
    self.nextButtonState = nextButtonState
  }
}

extension PhoneEntryStepState {
  public enum EntryPoint: Equatable {
    case login
    case signup
  }
}

public enum PhoneEntryStepAction: Equatable, BindableAction {
  case binding(BindingAction<PhoneEntryStepState>)
  case next(phoneNumber: String)
  case nextButtonTapped
  case onAppear
  case showKeyboard(Bool)
}

public struct PhoneEntryStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension PhoneEntryStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

public let phoneEntryStepReducer: Reducer<
  PhoneEntryStepState,
  PhoneEntryStepAction,
  PhoneEntryStepEnvironment
> = .init { state, action, environment in
  switch action {
  case .binding(\.$isValid):
    state.nextButtonState = state.isValid ? .enabled : .disabled
    return .none
  case .binding:
    return .none

  case .next:
    state.nextButtonState = .loading
    return .none

  case .nextButtonTapped:
    return .concatenate(
      Effect(value: .showKeyboard(false)),

      Effect(value: .next(phoneNumber: state.phoneNumber))
        .delay(for: 0.5, scheduler: environment.mainQueue)
        .eraseToEffect()
    )

  case .onAppear:
    return Effect(value: .showKeyboard(true))
    // show keyboard after 0.5 seconds
      .delay(for: 0.5, scheduler: environment.mainQueue)
      .eraseToEffect()

  case .showKeyboard(let shouldShow):
    state.isFocused = shouldShow
    return .none
  }
}
.binding()
