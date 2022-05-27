import ComposableArchitecture

public struct LoadingStepState: Equatable {
  public init(
  ) {
  }
}

public enum LoadingStepAction: Equatable {
  case finishedLoading
  case onAppear
}

public struct LoadingStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}
extension LoadingStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

public let loadingStepReducer: Reducer<
  LoadingStepState,
  LoadingStepAction,
  LoadingStepEnvironment
> = .init { _, action, environment in
  switch action {
  case .onAppear:
    return .init(value: .finishedLoading)
      .delay(for: 3, scheduler: environment.mainQueue)
      .eraseToEffect()

  case .finishedLoading:
    return .none
  }
}
