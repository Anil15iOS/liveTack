import ChangePasswordFeature
import ComposableArchitecture
import ComposablePresentation
import TCAHelpers
import StyleGuide
import SwiftUI
import UserListFeature

public struct PrivacySettingsView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<PrivacySettingsState, PrivacySettingsAction>

  public init(store: Store<PrivacySettingsState, PrivacySettingsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVStack(alignment: .leading) {
          Divider().background(.gray)
          VStack(alignment: .leading) {
            // Blocked Accounts HStack
            HStack(alignment: .top) {
              // Chevron Vstack
              VStack {
                HStack {
                  Button {
                    viewStore.send(.blockedUserButtonTapped)
                  } label: {
                    Text("Blocked Accounts")
                      .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                      .foregroundColor(.white)
                  }
                }
                .padding()
                Divider().background(.gray)
              }
              .background(
                NavigationLinkWithStore(
                  store.scope(
                    state: (\PrivacySettingsState.route)
                      .appending(path: /PrivacySettingsState.Route.blockedUsers)
                      .extract(from:),
                    action: (/PrivacySettingsAction.route)
                      .appending(path: /PrivacySettingsAction.RouteAction.blockedUsers)
                      .embed
                  ),
                  onDeactivate: { viewStore.send(.navigate(to: .none)) },
                  destination: UserListView.init(store:))
              )
            }

            // Change Password HStack
            HStack(alignment: .top) {
              // Chevron Vstack
              VStack {
                HStack {
                  Button {
                    viewStore.send(.changePasswordButtonTapped)
                  } label: {
                    Text("Change Password")
                      .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                      .foregroundColor(.white)
                  }
                }
                .padding()
                Divider().background(.gray)
              }
              .background(
                NavigationLinkWithStore(
                  store.scope(
                    state: (\PrivacySettingsState.route)
                      .appending(path: /PrivacySettingsState.Route.changePassword)
                      .extract(from:),
                    action: (/PrivacySettingsAction.route)
                      .appending(path: /PrivacySettingsAction.RouteAction.changePassword)
                      .embed
                  ),
                  onDeactivate: { viewStore.send(.navigate(to: .none)) },
                  destination: ChangePasswordView.init(store:))
              )
            }
          }
        }
      }
      .padding(.top)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(Color.LiveTake.primaryBackgroundColor)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("")
      .navigationBarBackButtonHidden(true)
      .preferredColorScheme(.dark)
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
          Text("Privacy")
            .foregroundColor(.white)
            .bold()
        }
      }
    }
  }
}

// MARK: - Subviews

extension PrivacySettingsView {
  struct Row<Content, State, Action>: View where Content: View {
    let title: String
    let optionalStateStore: Store<State?, Action>
    let setActive: (Bool) -> Void
    let destination: (Store<State, Action>) -> Content

    var body: some View {
      VStack(spacing: 0) {
        NavigationLinkWithStore(
          optionalStateStore,
          setActive: setActive,
          destination: destination) {
            HStack(alignment: .center) {
              Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
              Image(systemName: "chevron.right")
                .font(.system(size: 16))
            }
        }
          .buttonStyle(.plain)
          .frame(height: 56)

        Divider().background(Color.LiveTake.separator)
      }
    }
  }
}

// MARK: - Previews

struct PrivacySettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PrivacySettingsView(
        store: Store(
          initialState: .init(),
          reducer: privacySettingsReducer,
          environment: .noop
        )
      )
    }
  }
}
