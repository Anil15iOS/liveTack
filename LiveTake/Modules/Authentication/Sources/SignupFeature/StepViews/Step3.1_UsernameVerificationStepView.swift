import ComposableArchitecture
import ComposablePresentation
import SwiftUI
import UsernameVerificationStepFeature

struct Step31UsernameVerificationStepState: Equatable {
  var context: AuthContext
  var state: UsernameVerificationStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case password(Step4PasswordEntryStepState)
  }
}

// MARK: - Action

public enum Step31UsernameVerificationStepAction: Equatable {
  case dismissedNextStep
  case nextAction(NextAction)
  case usernameVerification(UsernameVerificationStepAction)
}

extension Step31UsernameVerificationStepAction {
  public enum NextAction: Equatable {
    case password(Step4PasswordEntryStepAction)
  }
}

// MARK: - Reducers

let step3_1_NextStepReducer: Reducer<
  Step31UsernameVerificationStepState.NextStep,
  Step31UsernameVerificationStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step4Reducer.pullback(
    state: /Step31UsernameVerificationStepState.NextStep.password,
    action: /Step31UsernameVerificationStepAction.NextAction.password,
    environment: { $0 }
  )
)

let step3_1_Reducer: Reducer<
  Step31UsernameVerificationStepState,
  Step31UsernameVerificationStepAction,
  SignupEnvironment
> = .combine(
  usernameVerificationStepReducer.pullback(
    state: \.state,
    action: /Step31UsernameVerificationStepAction.usernameVerification,
    environment: \.step3_1_UsernameVerification
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .nextAction:
      return .none

    case .usernameVerification(.next):
      state.next = .password(
        .init(context: state.context, state: .init(entryPoint: .signup))
      )
      return .none
    case .usernameVerification:
      return .none
    }
  }
)
  .presenting(
    step3_1_NextStepReducer,
    state: .keyPath(\.next),
    id: .notNil(),
    action: /Step31UsernameVerificationStepAction.nextAction,
    environment: { $0 }
  )

// MARK: - View

struct Step31UsernameVerificationStepView: View {
  let store: Store<Step31UsernameVerificationStepState, Step31UsernameVerificationStepAction>

  var body: some View {
    UsernameVerificationStepView(
      store: store.scope(
        state: \.state,
        action: Step31UsernameVerificationStepAction.usernameVerification
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step31UsernameVerificationStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: { ViewStore(store.stateless).send(.dismissedNextStep) },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step31UsernameVerificationStepState.NextStep.password,
              action: Step31UsernameVerificationStepAction.NextAction.password,
              then: Step4PasswordEntryStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
