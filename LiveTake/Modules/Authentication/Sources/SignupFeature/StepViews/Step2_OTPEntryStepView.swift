import ComposableArchitecture
import ComposablePresentation
import OTPEntryStepFeature
import SwiftUI

struct Step2OTPEntryStepState: Equatable {
  var context: AuthContext
  var state: OTPEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case usernameEntry(Step3UsernameEntryStepState)
  }
}

public enum Step2OTPEntryStepAction: Equatable {
  case dismissedNextStep
  case otpEntry(OTPEntryStepAction)
  case nextAction(NextAction)
}

extension Step2OTPEntryStepAction {
  public enum NextAction: Equatable {
    case usernameEntry(Step3UsernameEntryStepAction)
  }
}

let step2NextStepReducer: Reducer<
  Step2OTPEntryStepState.NextStep,
  Step2OTPEntryStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step3Reducer.pullback(
    state: /Step2OTPEntryStepState.NextStep.usernameEntry,
    action: /Step2OTPEntryStepAction.NextAction.usernameEntry,
    environment: { $0 }
  )
)

let step2Reducer: Reducer<
  Step2OTPEntryStepState,
  Step2OTPEntryStepAction,
  SignupEnvironment
> = .combine(
  otpEntryStepReducer.pullback(
    state: \.state,
    action: /Step2OTPEntryStepAction.otpEntry,
    environment: \.step2_OTPEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .otpEntry(.next):
      state.next = .usernameEntry(
        .init(
          context: state.context,
          state: .init()
        )
      )
      return .none

    case .otpEntry:
      return .none

    case .nextAction:
      return .none
    }
  }
)
.presenting(
  step2NextStepReducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step2OTPEntryStepAction.nextAction,
  environment: { $0 }
)

struct Step2OTPEntryStepView: View {
  let store: Store<Step2OTPEntryStepState, Step2OTPEntryStepAction>

  var body: some View {
    OTPEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step2OTPEntryStepAction.otpEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step2OTPEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: { ViewStore(store.stateless).send(.dismissedNextStep) },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step2OTPEntryStepState.NextStep.usernameEntry,
              action: Step2OTPEntryStepAction.NextAction.usernameEntry,
              then: Step3UsernameEntryStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
