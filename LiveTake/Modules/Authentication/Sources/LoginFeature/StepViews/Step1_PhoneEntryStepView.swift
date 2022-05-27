import ComposableArchitecture
import ComposablePresentation
import PhoneEntryStepFeature
import SwiftUI
import TCAHelpers

struct Step1PhoneEntryStepState: Equatable {
  var state: PhoneEntryStepState
  var next: Step2PasswordEntryStepState?
}

public enum Step1PhoneEntryStepAction: Equatable {
  case dismissedNextStep
  case password(Step2PasswordEntryStepAction)
  case phoneEntry(PhoneEntryStepAction)
  case navigateToPasswordEntry(phoneNumber: String)
}

let step1Reducer: Reducer<
  Step1PhoneEntryStepState,
  Step1PhoneEntryStepAction,
  LoginEnvironment
> = .combine(
  phoneEntryStepReducer.pullback(
    state: \.state,
    action: /Step1PhoneEntryStepAction.phoneEntry,
    environment: \.step1_PhoneEntry
  ),

  Reducer { state, action, _ in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .phoneEntry(.next(let phoneNumber)):
      return .concatenate(
        Effect(value: .phoneEntry(.set(\.$nextButtonState, .enabled))),
        Effect(value: .navigateToPasswordEntry(phoneNumber: phoneNumber))
      )

    case .phoneEntry:
      return .none

    case .navigateToPasswordEntry(let phoneNumber):
      state.next = .init(phoneNumber: phoneNumber, state: .init(entryPoint: .login))
      return .none

    case .password:
      return .none
    }
  }
)
.presenting(
  step2Reducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step1PhoneEntryStepAction.password,
  environment: { $0 }
)

struct Step1PhoneEntryStepView: View {
  let store: Store<Step1PhoneEntryStepState, Step1PhoneEntryStepAction>

  var body: some View {
    WithViewStore(store.stateless) { viewStore in
      PhoneEntryStepView(
        store: store.scope(
          state: \.state,
          action: Step1PhoneEntryStepAction.phoneEntry
        )
      ).background(
        NavigationLinkWithStore(
          store.scope(
            state: \.next,
            action: Step1PhoneEntryStepAction.password
          ),
          mapState: replayNonNil(),
          onDeactivate: { viewStore.send(.dismissedNextStep) },
          destination: Step2PasswordEntryStepView.init(store:)
        )
      )
    }
  }
}
