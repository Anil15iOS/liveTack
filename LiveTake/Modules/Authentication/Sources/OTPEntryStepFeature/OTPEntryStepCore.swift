import AuthContainerFeature
import ComposableArchitecture

public struct OTPEntryStepState: Equatable {
  static let numberOfDigits = 4

  @BindableState var focusedField: Field?
  @BindableState var isValid: Bool
  @BindableState var nextButtonState: NextButtonState
  @BindableState var otpField1: Int?
  @BindableState var otpField2: Int?
  @BindableState var otpField3: Int?
  @BindableState var otpField4: Int?
  let phoneNumber: String

  var fields: [Int?] {
    [otpField1, otpField2, otpField3, otpField4]
  }

  public init(
    focusedField: Field? = nil ,
    isValid: Bool = false,
    nextButtonState: NextButtonState = .disabled,
    otpField1: Int? = nil,
    otpField2: Int? = nil,
    otpField3: Int? = nil,
    otpField4: Int? = nil,
    phoneNumber: String
  ) {
    self.focusedField = focusedField
    self.isValid = isValid
    self.nextButtonState = nextButtonState
    self.otpField1 = otpField1
    self.otpField2 = otpField2
    self.otpField3 = otpField3
    self.otpField4 = otpField4
    self.phoneNumber = phoneNumber
  }
}

extension OTPEntryStepState {
  public enum Field: Int {
    case otpField1
    case otpField2
    case otpField3
    case otpField4

    var previous: Field? {
      Self(rawValue: self.rawValue - 1)
    }

    var next: Field? {
      Self(rawValue: self.rawValue + 1)
    }
  }
}

public enum OTPEntryStepAction: BindableAction, Equatable {
  case binding(BindingAction<OTPEntryStepState>)
  case focusOnLastField
  case next
  case nextButtonTapped
  case onAppear
  case otpChanged(Int?, OTPEntryStepState.Field)
  case resendButtonTapped
  case validate
}

public struct OTPEntryStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension OTPEntryStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

public let otpEntryStepReducer: Reducer<
  OTPEntryStepState,
  OTPEntryStepAction,
  OTPEntryStepEnvironment
> = .init { state, action, environment in
  switch action {
  case .binding(\.$otpField1):
    return Effect(value: .otpChanged(state.otpField1, .otpField1))

  case .binding(\.$otpField2):
    return Effect(value: .otpChanged(state.otpField2, .otpField2))

  case .binding(\.$otpField3):
    return Effect(value: .otpChanged(state.otpField3, .otpField3))

  case .binding(\.$otpField4):
    return Effect(value: .otpChanged(state.otpField4, .otpField4))

  case .binding:
    return .none

  case .focusOnLastField:
    state.focusedField = .init(rawValue: state.fields.compactMap { $0 }.count - 1) ?? .otpField1
    return .none

  case .next:
    return .none

  case .nextButtonTapped:
    return .none

  case .onAppear:
    return Effect(value: .focusOnLastField)
    // show keyboard after 0.5 seconds
      .delay(for: 0.5, scheduler: environment.mainQueue)
      .eraseToEffect()

  case let .otpChanged(digit, field):
    state.focusedField = digit == nil ? field.previous : field.next
    return Effect(value: .validate)

  case .resendButtonTapped:
    return .none

  case .validate:
    state.isValid = state.fields.compactMap { $0 }.count == OTPEntryStepState.numberOfDigits
    state.nextButtonState = state.isValid ? .enabled : .disabled
    return .none
  }
}
.binding()
