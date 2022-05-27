import ComposableArchitecture
import EditProfileFeature
import SwiftUI
import ProfileFeature

public struct MyProfileView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<MyProfileState, MyProfileAction>

  public init(store: Store<MyProfileState, MyProfileAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ProfileView(
        store: store.scope(
          state: \.profile,
          action: MyProfileAction.profile
        )
      )
        .toolbar {
          ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
              viewStore.send(.settingsButtonTapped)
            } label: {
              Image(systemName: "gearshape")
                .foregroundColor(.black)
            }
            .fullScreenCover(
              store.scope(
                state: \.editProfileState,
                action: MyProfileAction.editProfile
              ),
              mapState: { $0 },
              onDismiss: { viewStore.send(.dismissedSettings) },
              content: { editProfileStore in
                NavigationView {
                  EditProfileView.init(store: editProfileStore)
                }
              }
            )

            Button {
              viewStore.send(.notificationsButtonTapped)
            } label: {
              Image(systemName: "bell")
                .foregroundColor(.black)
            }

            Button {
              viewStore.send(.playbookButtonTapped)
            } label: {
              Image("playbook", bundle: .module)
            }
          }
        }
        .alert(
          store.scope(state: \.alert, action: MyProfileAction.alert),
          dismiss: .dismiss
        )
    }
  }
}

// MARK: - Previews

struct MyProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      MyProfileView(
        store: Store(
          initialState: .init(),
          reducer: myProfileReducer,
          environment: .noop
        )
      )
    }
  }
}
