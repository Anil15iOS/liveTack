import ComposableArchitecture
import SwiftUI

public struct LoginView: View {
  let store: Store<LoginState, LoginAction>

  public init(store: Store<LoginState, LoginAction>) {
    self.store = store
  }

  public var body: some View {
    Step1PhoneEntryStepView(
      store: store.scope(
        state: \.initialStep,
        action: LoginAction.step1_PhoneEntry
      )
    )
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoginView(
        store: Store(
          initialState: .init(),
          reducer: loginReducer,
          environment: .noop
        )
      )
      .navigationViewStyle(.stack)
    }
  }
}
