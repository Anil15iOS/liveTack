import ComposableArchitecture
import LoadingStepFeature
import SwiftUI

struct Step3LoadingStepState: Equatable {
  var state: LoadingStepState
}

public enum Step3LoadingStepAction: Equatable {
  case loading(LoadingStepAction)
}

let step3Reducer: Reducer<
  Step3LoadingStepState,
  Step3LoadingStepAction,
  LoginEnvironment
> = loadingStepReducer.pullback(
  state: \.state,
  action: /Step3LoadingStepAction.loading,
  environment: \.step3_Loading
)

struct Step3LoadingStepView: View {
  let store: Store<Step3LoadingStepState, Step3LoadingStepAction>

  var body: some View {
    LoadingStepView(
      store: store.scope(
        state: \.state,
        action: Step3LoadingStepAction.loading
      )
    )
  }
}
