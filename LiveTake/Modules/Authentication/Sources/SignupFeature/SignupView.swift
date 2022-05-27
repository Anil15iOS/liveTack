import ComposableArchitecture
import SwiftUI

public struct SignupView: View {
  let store: Store<SignupState, SignupAction>

  public init(store: Store<SignupState, SignupAction>) {
    self.store = store
  }

  public var body: some View {
    Step1PhoneEntryStepView(
      store: store.scope(
        state: \.initialStep,
        action: SignupAction.step1_PhoneEntry
      )
    )
  }
}

struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      SignupView(
        store: Store(
          initialState: .init(),
          reducer: signupReducer,
          environment: .noop
        )
      )
      .navigationViewStyle(.stack)
    }
  }
}
