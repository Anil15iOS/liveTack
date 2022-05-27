import ComposableArchitecture
import SwiftUI
import ProfileFeature

public struct OtherUserProfileView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<OtherUserProfileState, OtherUserProfileAction>

  public init(store: Store<OtherUserProfileState, OtherUserProfileAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ProfileView(
        store: store.scope(
          state: \.profile,
          action: OtherUserProfileAction.profile
        )
      )
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(.black)
          }
        }
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button {
            viewStore.send(.moreButtonTapped)
          } label: {
            Image(systemName: "ellipsis")
          }
          .foregroundColor(.black)
          .confirmationDialog(
            store.scope(
              state: \.confirmationDialog,
              action: OtherUserProfileAction.confirmationDialog
            ),
            dismiss: .dialogDismissed
          )
        }
      }
    }
  }
}

// MARK: - Previews

struct OtherUserProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      OtherUserProfileView(
        store: Store(
          initialState: .init(),
          reducer: otherUserProfileReducer,
          environment: .noop
        )
      )
    }
  }
}
