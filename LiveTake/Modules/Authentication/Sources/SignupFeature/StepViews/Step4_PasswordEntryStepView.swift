import ComposableArchitecture
import ComposablePresentation
import PasswordEntryStepFeature
import SwiftUI

struct Step4PasswordEntryStepState: Equatable {
  var context: AuthContext
  var state: PasswordEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case profileInfo(Step5ProfileInfoEntryStepState)
  }
}

// MARK: - Action

public enum Step4PasswordEntryStepAction: Equatable {
  case dismissedNextStep
  case passwordEntry(PasswordEntryStepAction)
  case nextAction(NextAction)
}

extension Step4PasswordEntryStepAction {
  public enum NextAction: Equatable {
    case profileInfo(Step5ProfileInfoEntryStepAction)
  }
}

// MARK: - Reducers

let step4NextStepReducer: Reducer<
  Step4PasswordEntryStepState.NextStep,
  Step4PasswordEntryStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step5Reducer.pullback(
    state: /Step4PasswordEntryStepState.NextStep.profileInfo,
    action: /Step4PasswordEntryStepAction.NextAction.profileInfo,
    environment: { $0 })
)

let step4Reducer: Reducer<
  Step4PasswordEntryStepState,
  Step4PasswordEntryStepAction,
  SignupEnvironment
> = .combine(
  passwordEntryStepReducer.pullback(
    state: \.state,
    action: /Step4PasswordEntryStepAction.passwordEntry,
    environment: \.step4_PasswordEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .passwordEntry(.next(let password)):
      state.context.password = password
      state.next = .profileInfo(.init(context: state.context, state: .init()))
      return .none

    case .passwordEntry:
      return .none

    case .nextAction:
      return .none
    }
  }
)
  .presenting(
    step4NextStepReducer,
    state: .keyPath(\.next),
    id: .notNil(),
    action: /Step4PasswordEntryStepAction.nextAction,
    environment: { $0 }
  )

struct Step4PasswordEntryStepView: View {
  let store: Store<Step4PasswordEntryStepState, Step4PasswordEntryStepAction>

  var body: some View {
    PasswordEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step4PasswordEntryStepAction.passwordEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step4PasswordEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: {
          ViewStore(store.stateless).send(.dismissedNextStep)
        },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step4PasswordEntryStepState.NextStep.profileInfo,
              action: Step4PasswordEntryStepAction.NextAction.profileInfo,
              then: Step5ProfileInfoEntryStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
