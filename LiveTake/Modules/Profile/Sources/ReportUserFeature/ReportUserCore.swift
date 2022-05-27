import ComposableArchitecture

public struct ReportUserState: Equatable {
  let reportedUser: User
  @BindableState var reportMessage: String = ""

  init(
    reportedUser: User = .init(id: "", username: "kennyforreal", image: "person.crop.circle")
  ) {
    self.reportedUser = reportedUser
  }
}

extension ReportUserState {
  public struct User: Equatable {
    let id: String
    let username: String
    let image: String
  }
}

// MARK: - Action

public enum ReportUserAction: BindableAction {
  case didAppear
  case previous
  case next
  case binding(BindingAction<ReportUserState>)
}

// MARK: - Environment

public struct ReportUserEnvironment {
  public init() {
  }
}

extension ReportUserEnvironment {
  static let noop = Self()
}

// MARK: - Reducers

public let reportUserReducer = Reducer<
  ReportUserState, ReportUserAction, ReportUserEnvironment
> { _, action, _ in
  switch action {
  case .didAppear:
    return .none
  case .previous:
    return .none
  case .next:
    return .none
  case .binding:
    return .none
  }
}
.binding()
