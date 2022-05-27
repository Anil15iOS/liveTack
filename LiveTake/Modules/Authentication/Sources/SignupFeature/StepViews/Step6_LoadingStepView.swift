import ComposableArchitecture
import LoadingStepFeature
import SwiftUI

struct Step6LoadingStepState: Equatable {
  var context: AuthContext
  var state: LoadingStepState
}

public enum Step6LoadingStepAction: Equatable {
  case loading(LoadingStepAction)
}

let step6Reducer: Reducer<
  Step6LoadingStepState,
  Step6LoadingStepAction,
  SignupEnvironment
> = .combine(
  loadingStepReducer.pullback(
    state: \.state,
    action: /Step6LoadingStepAction.loading,
    environment: \.step6_Loading
  ),

  Reducer { _, action, _ in
    switch action {
    case.loading(.onAppear):
      return .none

    case .loading:
      return .none
    }
  }
)


struct Step6LoadingStepView: View {
  let store: Store<Step6LoadingStepState, Step6LoadingStepAction>

  var body: some View {
    LoadingStepView(
      store: store.scope(
        state: \.state,
        action: Step6LoadingStepAction.loading
      )
    )
  }
}
