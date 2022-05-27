import AuthContainerFeature
import SwiftUI
import ComposableArchitecture
import ComposablePresentation

public struct LoadingStepView: View {
  let store: Store<LoadingStepState, LoadingStepAction>

  public init(
    store: Store<LoadingStepState, LoadingStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(hideNext: true) {
        ProgressView("Sports banter loading...")
          .font(.callout)
          .tint(.white)
          .foregroundColor(.white)
          .frame(maxHeight: .infinity, alignment: .center)
      } onNext: {
      }
      .navigationBarHidden(true)
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct LoadingStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoadingStepView(
        store: Store(
          initialState: .init(),
          reducer: loadingStepReducer,
          environment: .noop
        )
      )
    }
  }
}
