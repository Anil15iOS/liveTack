import AuthenticationClient
import ComposableArchitecture
import ComposeTakesFeature
import MyProfileFeature

public struct TabsState: Equatable {
  @BindableState var selectedTab: Tab

  var profileState: MyProfileState

  var composeTake: ComposeTakeState?

  public init(
    profileState: MyProfileState = .init(),
    selectedTab: Tab = .liveTake
  ) {
    self.profileState = profileState
    self.selectedTab = selectedTab
  }
}

public enum Tab: Int, CaseIterable, Identifiable {
  case liveTake
  case takes
  case profile

  public var id: Int { rawValue }
}

public enum TabsAction: BindableAction, Equatable {
  case binding(BindingAction<TabsState>)
  case composeTake(ComposeTakeAction)
  case dismissedComposeTake
  case onAppear
  case primaryCTAButtonTapped
  case profile(MyProfileAction)
}

public struct TabsEnvironment {
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

extension TabsEnvironment {
  public static let noop = Self(
    authentication: .noop,
    mainQueue: .immediate
  )
}

extension TabsEnvironment {
  var profile: MyProfileEnvironment {
    .init()
  }
}

public let tabsReducer: Reducer<
  TabsState,
  TabsAction,
  TabsEnvironment
> = .combine(
  myProfileReducer.pullback(
    state: \.profileState,
    action: /TabsAction.profile,
    environment: \.profile
  ),

  Reducer { state, action, _ in
    switch action {
    case .binding:
      return .none
    case .composeTake:
      return .none
    case .dismissedComposeTake:
      state.composeTake = nil
      return .none
    case .onAppear:
      return .none
    case .primaryCTAButtonTapped:
      if state.selectedTab == .takes {
        state.composeTake = .init()
      }
      return .none
    case .profile:
      return .none
    }
  }
)
.presenting(
  composeTakeReducer,
  state: .keyPath(\.composeTake),
  id: .notNil(),
  action: /TabsAction.composeTake,
  environment: { _ in .init() }
)
.binding()
