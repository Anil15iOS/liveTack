import ComposableArchitecture
import ComposablePresentation
import OtherUserProfileFeature

// MARK: - State

public struct UserListState: Equatable {
  var blockedUsers: IdentifiedArrayOf<BlockedUser>

  var profileState: OtherUserProfileState?

  public init(
    blockedUsers: IdentifiedArrayOf<BlockedUser>// = []
  ) {
    self.blockedUsers = blockedUsers
  }
}

extension UserListState {
  // TODO: Extract into actual models modules
  public struct BlockedUser: Equatable, Identifiable {
    public let id: Int
    public var userName: String { "User \(id)" }

    public init(id: Int) {
      self.id = id
    }
  }
}

// MARK: - Action

public enum UserListAction: BindableAction, Equatable {
  case binding(BindingAction<UserListState>)
  case blockedUser(id: UserListState.BlockedUser.ID, action: BlockedUserAction)
  case dismissedProfile
  case profile(OtherUserProfileAction)
  case onAppear
}

extension UserListAction {
  public enum BlockedUserAction: Equatable {
    case unblockButtonTapped
    case profileButtonTapped
  }
}

// MARK: - Environment

public struct UserListEnvironment {
  public init() {
  }
}

extension UserListEnvironment {
  static let noop = Self()
}

// MARK: - Reducers

public let userListReducer = Reducer<
  UserListState, UserListAction, UserListEnvironment
> { state, action, _ in
  switch action {
  case .binding:
    return .none
  case .blockedUser(let id, action: .profileButtonTapped):
    state.profileState = .init(isBlockedUser: true)
    return .none
  case .blockedUser(_, action: .unblockButtonTapped):
    return .none
  case .dismissedProfile:
    state.profileState = .none
    return .none
  case .profile:
    return .none
  case .onAppear:
    return .none
  }
}
.binding()
.presenting(
  otherUserProfileReducer,
  state: .keyPath(\.profileState),
  id: .notNil(),
  action: /UserListAction.profile,
  environment: { _ in .init() }
)
