import AuthContainerFeature
import ComposableArchitecture
import SwiftUI
import Utility

public struct UsernameEntryStepView: View {
  let store: Store<UsernameEntryStepState, UsernameEntryStepAction>

  @FocusState private var isFocused

  public init(
    store: Store<UsernameEntryStepState, UsernameEntryStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(nextButtonState: viewStore.binding(\.$nextButtonState)) {
        VStack(alignment: .leading, spacing: 24) {
          HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("Create Username")
              .font(.title3)
              .foregroundColor(.white)
            Text("Make it 🔥")
              .font(.footnote)
              .foregroundColor(Color.LiveTake.subtleTextColor)
          }

          HStack {
            TextField(
              "",
              text: viewStore.binding(\.$username),
              onCommit: {
                viewStore.send(.nextButtonTapped)
              })
              .focused($isFocused)
              .synchronize(viewStore.binding(\.$isFocused), $isFocused)
              .textInputAutocapitalization(.never)
              .tint(.white)
              .foregroundColor(.white)
              .font(.body.weight(.light))
            // Show check mark if is valid username
            // TODO: check if username is available
            // NOTE: isn't it expensive to check username valid on
            // every keystroke?
            if viewStore.isValid {
              Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(1, contentMode: .fit)
                .padding(.vertical, 12)
                .foregroundColor(.LiveTake.greenCheckmark)
            }
          }
          .tint(.white)
          .accentColor(.gray)
          .frame(height: 48)
          .padding(.horizontal)
          .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
        }
        .padding(.top, 160)
        .onAppear {
          viewStore.send(.onAppear)
        }
      } onNext: {
        viewStore.send(.nextButtonTapped)
      }
    }
  }
}

// MARK: - Previews

struct UsernameEntryStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UsernameEntryStepView(
        store: Store(
          initialState: .init(),
          reducer: usernameEntryStepReducer,
          environment: .noop
        )
      )
    }
  }
}
