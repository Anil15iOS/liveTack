import ComposablePresentation
import ComposableArchitecture
import OtherUserProfileFeature
import StyleGuide
import SwiftUI

public struct UserListView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<UserListState, UserListAction>

  public init(store: Store<UserListState, UserListAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
    ScrollView {
      VStack {
        ForEachStore(
          store.scope(
            state: \.blockedUsers,
            action: UserListAction.blockedUser
          ),
          content: Row.init(store:)
        )
        .background(
          NavigationLinkWithStore(
            store.scope(
              state: \.profileState,
              action: UserListAction.profile
            ),
            mapState: replayNonNil(),
            onDeactivate: { viewStore.send(.dismissedProfile) },
            destination: OtherUserProfileView.init(store:)
          )
        )
      }
      .frame(maxWidth: .infinity)
    }
    .background(Color.LiveTake.primaryBackgroundColor)
    .navigationBarTitleDisplayMode(.inline)
    .navigationTitle("")
    .navigationBarBackButtonHidden(true)
    .preferredColorScheme(.dark)
    .searchable(
      text: .constant(""),
      placement: .navigationBarDrawer(displayMode: .always),
      prompt: "Search"
    )
    .toolbar {
      ToolbarItemGroup(placement: .navigation) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.LiveTake.labelGray)
        }
      }

      ToolbarItemGroup(placement: .principal) {
        Text("Blocked User")
          .foregroundColor(.white)
          .bold()
      }
    }
    }
  }
}

// MARK: - Subviews

extension UserListView {
  struct Row: View {
    let store: Store<UserListState.BlockedUser, UserListAction.BlockedUserAction>

    var body: some View {
      WithViewStore(store) { viewStore in
        VStack {
          HStack(spacing: 8) {
            Button {
              viewStore.send(.profileButtonTapped)
            } label: {
              HStack {
                Circle()
                  .strokeBorder(.gray)
                  .frame(width: 40, height: 40)

                Text(viewStore.userName)
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
            .buttonStyle(.plain)

            Button {
              viewStore.send(.unblockButtonTapped)
            } label: {
              Text("Unblock")
                .frame(width: 104)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(.LiveTake.followingButtonBackground)
          }
          .padding(.horizontal)
          .frame(height: 64)
          Divider()
        }
      }
    }
  }
}


// MARK: - Previews

struct UserListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserListView(
        store: Store(
          initialState: .init(
            blockedUsers: IdentifiedArrayOf(
              uniqueElements: (1...5)
                .map(UserListState.BlockedUser.init(id:))
            )
          ),
          reducer: userListReducer,
          environment: .noop
        )
      )
    }
  }
}
