import ComposableArchitecture
import ProfileFeature

// MARK: - State

public struct OtherUserProfileState: Equatable {
  var confirmationDialog: ConfirmationDialogState<OtherUserProfileAction.ConfirmationDialogAction>?

  var profile: ProfileState

  public init(isBlockedUser: Bool = false) {
    self.profile = .init(viewMode: .otherUser(blocked: isBlockedUser))
  }
}

// MARK: - Action

public enum OtherUserProfileAction: Equatable {
  case confirmationDialog(ConfirmationDialogAction)
  case onAppear
  case moreButtonTapped
  case profile(ProfileAction)
}

extension OtherUserProfileAction {
  public enum ConfirmationDialogAction: Equatable {
    case blockButtonTapped
    case dialogDismissed
    case reportButtonTapped
    case unblockButtonTapped
  }
}

// MARK: - Environment

public struct OtherUserProfileEnvironment {
  public init() {
  }
}

extension OtherUserProfileEnvironment {
  static let noop = Self()
}

extension OtherUserProfileEnvironment {
  var profile: ProfileEnvironment {
    .init()
  }
}

// MARK: - Reducers

public let otherUserProfileReducer = Reducer<
  OtherUserProfileState, OtherUserProfileAction, OtherUserProfileEnvironment
> .combine(
  profileReducer.pullback(
    state: \.profile,
    action: /OtherUserProfileAction.profile,
    environment: \.profile
  ),

  Reducer { state, action, _ in
    switch action {
    case .confirmationDialog(.dialogDismissed):
      state.confirmationDialog = .none
      return .none
    case .confirmationDialog:
      return .none
    case .onAppear:
      return .none
    case .moreButtonTapped:
      guard case let .otherUser(isBlocked) = state.profile.viewMode else { return .none }
      state.confirmationDialog = .init(
        title: .init(state.profile.username),
        message: isBlocked ?
          .init("Unblock \(state.profile.username)") :
            .init("Report or block if you are experiencing issues with this user."),
        buttons: isBlocked ? [
          .cancel(.init("Cancel")),
          .default(.init("Unblock"), action: .send(.unblockButtonTapped))
        ] : [
          .cancel(.init("Cancel")),
          .destructive(.init("Report"), action: .send(.reportButtonTapped)),
          .destructive(.init("Block"), action: .send(.blockButtonTapped))
        ]
      )
      return .none
    case .profile:
      return .none
    }
  }
)
