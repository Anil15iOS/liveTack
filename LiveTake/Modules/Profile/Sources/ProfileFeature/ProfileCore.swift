import ComposableArchitecture
import SwiftUI

public struct ProfileState: Equatable {
  @BindableState public var username: String
  @BindableState public var displayName: String
  @BindableState public var followingCount: Int
  @BindableState public var followerCount: Int
  @BindableState public var description: String
  @BindableState public var profileImage: Image
  @BindableState public var viewMode: ViewMode

  var blockedUserState: BlockedUserState

  public init(
    username: String = "easymoneyswiper",
    displayName: String = "",
    followingCount: Int = 10,
    followerCount: Int = 1000,
    description: String = "",
    //    profileImage: Image = Image("brettokamoto", bundle: .module),
    // TODO: Don't pass in default value for viewMode
    viewMode: ViewMode = .loggedInUser
  ) {
    self.username = username
    self.displayName = displayName
    self.followingCount = followingCount
    self.followerCount = followerCount
    self.description = description
    self.profileImage = Image(systemName: "person.crop.circle")
    self.viewMode = viewMode
    self.blockedUserState = .init()
  }
}

extension ProfileState {
  public enum ViewMode: CaseIterable, Equatable, Identifiable, Hashable {
    case loggedInUser
    case otherUser(blocked: Bool) // blocked will actually be on the user model so this is temporary

    public var id: Self { self }

    public static let allCases: [ProfileState.ViewMode] = [
      .loggedInUser,
      .otherUser(blocked: true),
      .otherUser(blocked: false)
    ]
  }
}

public enum ProfileAction: BindableAction, Equatable {
  case binding(BindingAction<ProfileState>)
  case blockedUser(BlockedUserAction)
  case didAppear
}

public struct ProfileEnvironment {
  public init(
  ) {
  }
}

extension ProfileEnvironment {
  public static let noop = Self()
}

public let profileReducer: Reducer<
  ProfileState, ProfileAction, ProfileEnvironment
> = .combine(
  blockedUserReducer.pullback(
    state: \.blockedUserState,
    action: /ProfileAction.blockedUser,
    environment: { _ in .init() }
  ),

  Reducer { _, action, _ in
    switch action {
    case .binding:
      return .none

    case .blockedUser:
      return .none

    case .didAppear:
      return .none
    }
  }
)
  .binding()
