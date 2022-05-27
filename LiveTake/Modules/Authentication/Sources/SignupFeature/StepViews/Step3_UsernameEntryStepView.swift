import ComposableArchitecture
import ComposablePresentation
import SwiftUI
import UsernameEntryStepFeature

struct Step3UsernameEntryStepState: Equatable {
  var context: AuthContext
  var state: UsernameEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case password(Step4PasswordEntryStepState)
    case usernameVerification(Step31UsernameVerificationStepState)
  }
}

// MARK: - Action

public enum Step3UsernameEntryStepAction: Equatable {
  case dismissedNextStep
  case nextAction(NextAction)
  case usernameEntry(UsernameEntryStepAction)
}

extension Step3UsernameEntryStepAction {
  public enum NextAction: Equatable {
    case password(Step4PasswordEntryStepAction)
    case usernameVerification(Step31UsernameVerificationStepAction)
  }
}

// MARK: - Reducers

let step3NextStepReducer: Reducer<
  Step3UsernameEntryStepState.NextStep,
  Step3UsernameEntryStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step3_1_Reducer.pullback(
    state: /Step3UsernameEntryStepState.NextStep.usernameVerification,
    action: /Step3UsernameEntryStepAction.NextAction.usernameVerification,
    environment: { $0 }
  ),

  step4Reducer.pullback(
    state: /Step3UsernameEntryStepState.NextStep.password,
    action: /Step3UsernameEntryStepAction.NextAction.password,
    environment: { $0 }
  )
)

let step3Reducer: Reducer<
  Step3UsernameEntryStepState,
  Step3UsernameEntryStepAction,
  SignupEnvironment
> = .combine(
  usernameEntryStepReducer.pullback(
    state: \.state,
    action: /Step3UsernameEntryStepAction.usernameEntry,
    environment: \.step3_UsernameEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .nextAction:
      return .none

    case .usernameEntry(.next(let username)):
      state.context.username = username
      state.next = .password(.init(context: state.context, state: .init(entryPoint: .signup)))
      return .none

    case .usernameEntry:
      return .none
    }
  }
)
.presenting(
  step3NextStepReducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step3UsernameEntryStepAction.nextAction,
  environment: { $0 }
)

// MARK: - View

struct Step3UsernameEntryStepView: View {
  let store: Store<Step3UsernameEntryStepState, Step3UsernameEntryStepAction>

  var body: some View {
    UsernameEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step3UsernameEntryStepAction.usernameEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step3UsernameEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: {
          ViewStore(store.stateless).send(.dismissedNextStep)
        },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step3UsernameEntryStepState.NextStep.usernameVerification,
              action: Step3UsernameEntryStepAction.NextAction.usernameVerification,
              then: Step31UsernameVerificationStepView.init(store:)
            )

            CaseLet(
              state: /Step3UsernameEntryStepState.NextStep.password,
              action: Step3UsernameEntryStepAction.NextAction.password,
              then: Step4PasswordEntryStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
