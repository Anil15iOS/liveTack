import ComposableArchitecture
import ComposablePresentation
import PasswordEntryStepFeature
import SwiftUI

struct Step22PasswordEntryStepState: Equatable {
  var state: PasswordEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case loading(Step3LoadingStepState)
  }
}

// MARK: - Action

public enum Step22PasswordEntryStepAction: Equatable {
  case dismissedNextStep
  case passwordEntry(PasswordEntryStepAction)
  case nextAction(NextAction)
}

extension Step22PasswordEntryStepAction {
  public enum NextAction: Equatable {
    case loading(Step3LoadingStepAction)
  }
}

// MARK: - Reducers

let step2_2_NextStepReducer: Reducer<
  Step22PasswordEntryStepState.NextStep,
  Step22PasswordEntryStepAction.NextAction,
  LoginEnvironment
> = .combine(
  step3Reducer.pullback(
    state: /Step22PasswordEntryStepState.NextStep.loading,
    action: /Step22PasswordEntryStepAction.NextAction.loading,
    environment: { $0 })
)

let step2_2_Reducer: Reducer<
  Step22PasswordEntryStepState,
  Step22PasswordEntryStepAction,
  LoginEnvironment
> = .combine(
  passwordEntryStepReducer.pullback(
    state: \.state,
    action: /Step22PasswordEntryStepAction.passwordEntry,
    environment: \.step2_2_PasswordEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .passwordEntry(.next):
      state.next = .loading(.init(state: .init()))
      return .none

    case .passwordEntry:
      return .none

    case .nextAction:
      return .none
    }
  }
)
  .presenting(
    step2_2_NextStepReducer,
    state: .keyPath(\.next),
    id: .notNil(),
    action: /Step22PasswordEntryStepAction.nextAction,
    environment: { $0 }
  )

struct Step22PasswordEntryStepView: View {
  let store: Store<Step22PasswordEntryStepState, Step22PasswordEntryStepAction>

  var body: some View {
    PasswordEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step22PasswordEntryStepAction.passwordEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step22PasswordEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: {
          ViewStore(store.stateless).send(.dismissedNextStep)
        },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step22PasswordEntryStepState.NextStep.loading,
              action: Step22PasswordEntryStepAction.NextAction.loading,
              then: Step3LoadingStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
