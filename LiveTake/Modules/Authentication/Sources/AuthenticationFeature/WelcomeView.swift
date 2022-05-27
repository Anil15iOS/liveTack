import ComposableArchitecture
import ComposablePresentation
import LoginFeature
import TCAHelpers
import SignupFeature
import StyleGuide
import SwiftUI

struct WelcomeView: View {
  let store: Store<AuthenticationState, AuthenticationAction>

  init(store: Store<AuthenticationState, AuthenticationAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.stateless) { viewStore in
      VStack {
        // Logo
        Image("logo", bundle: .module)
          .resizable()
          .frame(width: 126, height: 126)
          .frame(maxHeight: .infinity, alignment: .center)

        // Get Started button
        Button {
          viewStore.send(.getStartedButtonTapped)
        } label: {
          Text("Get Started")
            .font(.body.bold())
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .tint(.white)
        .foregroundColor(.black)
        .padding(.horizontal)
        .background(
          NavigationLinkWithStore(
            store.scope(
              state: (\AuthenticationState.route)
                .appending(path: /AuthenticationState.Route.signup)
                .extract(from:),
              action: (/AuthenticationAction.route).appending(path: /AuthenticationAction.RouteAction.signup).embed
            ),
            mapState: replayNonNil(),
            onDeactivate: { viewStore.send(.setRoute(for: .none)) },
            destination: SignupView.init(store:)
          )
        )

        // Sign In button
        Button {
          viewStore.send(.signInButtonTapped)
        } label: {
          Text("Sign In")
            .font(.body.weight(.medium))
            .frame(height: 52)
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.capsule)
        .foregroundColor(.white)
        .background(
          NavigationLinkWithStore(
            store.scope(
              state: (\AuthenticationState.route)
                .appending(path: /AuthenticationState.Route.login)
                .extract(from:),
              action: (/AuthenticationAction.route).appending(path: /AuthenticationAction.RouteAction.login).embed
            ),
            mapState: replayNonNil(),
            onDeactivate: { viewStore.send(.setRoute(for: .none)) },
            destination: LoginView.init(store:)
          )
        )
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .background(Color.LiveTake.darkBackground)
    }
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView(
      store: Store(
        initialState: .init(route: nil),
        reducer: authenticationReducer,
        environment: .noop
      )
    )
  }
}
