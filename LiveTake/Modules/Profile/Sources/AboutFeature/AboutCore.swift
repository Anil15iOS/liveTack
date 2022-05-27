import ComposableArchitecture

public struct AboutState: Equatable {
  var alert: AlertState<AboutAction.AlertAction>?

  public init(
    alert: AlertState<AboutAction.AlertAction>? = nil
  ) {
    self.alert = alert
  }
}

public enum AboutAction: BindableAction, Equatable {
  case alert(AlertAction)
  case binding(BindingAction<AboutState>)
  case dataPolicyRowTapped
  case onAppear
  case termsOfUseRowTapped
}

extension AboutAction {
  public enum AlertAction: Equatable {
    case dismiss
  }
}

public struct AboutEnvironment {
  public init() { }
}

public let aboutReducer = Reducer<
  AboutState, AboutAction, AboutEnvironment
> { state, action, _ in
  switch action {
  case .alert(.dismiss):
    state.alert = nil
    return .none
  case .binding:
    return .none
  case .dataPolicyRowTapped:
    state.alert = .init(
      title: .init("Data Policy"),
      message: .init("This is where the data policy screen would show"),
      buttons: []
    )
    return .none
  case .onAppear:
    return .none

  case .termsOfUseRowTapped:
    state.alert = .init(
      title: .init("Term of Use"),
      message: .init("This is where the term of use screen would show"),
      buttons: []
    )
    return .none
  }
}
.binding()
