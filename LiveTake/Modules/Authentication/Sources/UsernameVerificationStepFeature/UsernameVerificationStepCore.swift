import ComposableArchitecture

public struct UsernameVerificationStepState: Equatable {
  let username: String
  var verificationType: VerificationType?

  public init(
    username: String
  ) {
    self.username = username
  }
}

extension UsernameVerificationStepState {
  public enum VerificationType: Identifiable {
    case instagram
    case twitter

    public var id: Self { self }
  }
}

// MARK: - Action

public enum UsernameVerificationStepAction: BindableAction, Equatable {
  case binding(BindingAction<UsernameVerificationStepState>)
  case next
  case onAppear
  case setVerificationType(UsernameVerificationStepState.VerificationType?)
  case verifiedSuccessfully
}

public struct UsernameVerificationStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension UsernameVerificationStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

// MARK: - Reducer

public let usernameVerificationStepReducer: Reducer<
  UsernameVerificationStepState,
  UsernameVerificationStepAction,
  UsernameVerificationStepEnvironment
> = .init { state, action, _ in
  switch action {
  case .binding:
    return .none

  case .next:
    return .none

  case .onAppear:
    return .none

  case .setVerificationType(let type):
    state.verificationType = type
    return .none

  case .verifiedSuccessfully:
    return .concatenate(
      Effect(value: .setVerificationType(.none)),

      Effect(value: .next)
        .delay(for: 0.5, scheduler: AnySchedulerOf<DispatchQueue>.main)
        .eraseToEffect()
    )
  }
}
.binding()
