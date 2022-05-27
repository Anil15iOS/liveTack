import AuthenticationFeature
import ComposableArchitecture
import ComposablePresentation
import Utility
import SwiftUI
import TabsFeature
import TCAHelpers

public struct AppView: View {
  let store: Store<AppState, AppAction>

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.route, action: AppAction.route)) {
      CaseLet(
        state: /AppState.Route.main,
        action: AppAction.RouteAction.main,
        then: TabsView.init(store:))

      CaseLet(
        state: /AppState.Route.authentication,
        action: AppAction.RouteAction.authentication,
        then: {
          AuthenticationView(store: $0)
            .transition(
              .asymmetric(
                insertion: .identity,
                removal: .move(edge: .bottom)
              )
            )
        }
      )

      Default {
        ProgressView()
          .progressViewStyle(.circular)
      }
    }
    .alert(
      store.scope(state: \.alert, action: AppAction.alert),
      dismiss: .dismiss
    )
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      // This is 
      // AppView(
      //   store: Store(
      //     initialState: .init(
      //       route: .authentication(
      //         .init()
      //       )
      //     ),
      //     reducer: appReducer,
      //     environment: .noop
      //   )
      // )

      AppView(
        store: Store(
          initialState: .init(
            route: .main(
              .init()
            )
          ),
          reducer: appReducer,
          environment: .noop
        )
      )
    }
  }
}
