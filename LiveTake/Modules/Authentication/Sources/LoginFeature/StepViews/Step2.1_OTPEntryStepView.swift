import ComposableArchitecture
import ComposablePresentation
import OTPEntryStepFeature
import SwiftUI

struct Step21OTPEntryStepState: Equatable {
  var state: OTPEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case password(Step22PasswordEntryStepState)
  }
}

public enum Step21OTPEntryStepAction: Equatable {
  case dismissedNextStep
  case otpEntry(OTPEntryStepAction)
  case nextAction(NextAction)
}

extension Step21OTPEntryStepAction {
  public enum NextAction: Equatable {
    case password(Step22PasswordEntryStepAction)
  }
}

let step2_1_NextStepReducer: Reducer<
  Step21OTPEntryStepState.NextStep,
  Step21OTPEntryStepAction.NextAction,
  LoginEnvironment
> = .combine(
  step2_2_Reducer.pullback(
    state: /Step21OTPEntryStepState.NextStep.password,
    action: /Step21OTPEntryStepAction.NextAction.password,
    environment: { $0 }
  )
)

let step2_1_Reducer: Reducer<
  Step21OTPEntryStepState,
  Step21OTPEntryStepAction,
  LoginEnvironment
> = .combine(
  otpEntryStepReducer.pullback(
    state: \.state,
    action: /Step21OTPEntryStepAction.otpEntry,
    environment: \.step2_1_OTPEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .otpEntry(.next):
      state.next = .password(.init(state: .init(entryPoint: .forgotPassword)))
      return .none

    case .otpEntry:
      return .none

    case .nextAction:
      return .none
    }
  }
)
.presenting(
  step2_1_NextStepReducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step21OTPEntryStepAction.nextAction,
  environment: { $0 }
)

struct Step21OTPEntryStepView: View {
  let store: Store<Step21OTPEntryStepState, Step21OTPEntryStepAction>

  var body: some View {
    OTPEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step21OTPEntryStepAction.otpEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step21OTPEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: { ViewStore(store.stateless).send(.dismissedNextStep) },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step21OTPEntryStepState.NextStep.password,
              action: Step21OTPEntryStepAction.NextAction.password,
              then: Step22PasswordEntryStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
