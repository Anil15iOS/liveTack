import ComposableArchitecture
import SwiftUI

public struct AuthenticationView: View {
  let store: Store<AuthenticationState, AuthenticationAction>
  public init(store: Store<AuthenticationState, AuthenticationAction>) {
    self.store = store
  }
  public var body: some View {
    NavigationView {
      WelcomeView(store: store)
    }
    .navigationViewStyle(.stack)
    .preferredColorScheme(.dark)
  }
}

struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView(
      store: .init(
        initialState: .init(),
        reducer: authenticationReducer,
        environment: .noop
      )
    )
  }
}
