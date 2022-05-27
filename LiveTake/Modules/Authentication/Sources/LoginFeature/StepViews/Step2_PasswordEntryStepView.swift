import AuthenticationClient
import ComposableArchitecture
import ComposablePresentation
import PasswordEntryStepFeature
import SwiftUI

struct Step2PasswordEntryStepState: Equatable {
  let phoneNumber: String
  var state: PasswordEntryStepState
  var next: NextStep?

  var alert: AlertState<Step2PasswordEntryStepAction.AlertAction>?

  enum NextStep: Equatable {
    case loading(Step3LoadingStepState)
  }
}

// MARK: - Action

public enum Step2PasswordEntryStepAction: Equatable {
  case alert(AlertAction)
  case dismissedNextStep
  case loginResponse(Result<AuthLoginStep, AuthClientError>)
  case passwordEntry(PasswordEntryStepAction)
  case nextAction(NextAction)
}

extension Step2PasswordEntryStepAction {
  public enum NextAction: Equatable {
    case loading(Step3LoadingStepAction)
  }

  public enum AlertAction: Equatable {
    case dismiss
  }
}

// MARK: - Reducers

let step2NextStepReducer: Reducer<
  Step2PasswordEntryStepState.NextStep,
  Step2PasswordEntryStepAction.NextAction,
  LoginEnvironment
> = .combine(
  step3Reducer.pullback(
    state: /Step2PasswordEntryStepState.NextStep.loading,
    action: /Step2PasswordEntryStepAction.NextAction.loading,
    environment: { $0 }
  )
)

let step2Reducer: Reducer<
  Step2PasswordEntryStepState,
  Step2PasswordEntryStepAction,
  LoginEnvironment
> = .combine(
  passwordEntryStepReducer.pullback(
    state: \.state,
    action: /Step2PasswordEntryStepAction.passwordEntry,
    environment: \.step2_PasswordEntry
  ),

  Reducer { state, action, environment in
    switch action {
    case .alert(.dismiss):
      state.alert = nil
      return .none

    case .dismissedNextStep:
      state.next = nil
      return .none

    case .loginResponse(.success):
      state.next = .loading(.init(state: .init()))
      return .none

    case .loginResponse(.failure):
      return .none

    case .passwordEntry(.forgotPasswordButtonTapped):
      state.alert = .init(
        title: TextState("Disabled"),
        message: TextState("Currently disabled until we figure out the OTP issue")
      )
      return .none

    case .passwordEntry(.next(let password)):
      return environment.authentication
        .login(.init(phoneNumber: state.phoneNumber, password: password))
        .receive(on: environment.mainQueue)
        .catchToEffect(Step2PasswordEntryStepAction.loginResponse)

    case .passwordEntry:
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
  action: /Step2PasswordEntryStepAction.nextAction,
  environment: { $0 }
)

struct Step2PasswordEntryStepView: View {
  let store: Store<Step2PasswordEntryStepState, Step2PasswordEntryStepAction>

  var body: some View {
    PasswordEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step2PasswordEntryStepAction.passwordEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step2PasswordEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: {
          ViewStore(store.stateless).send(.dismissedNextStep)
        },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step2PasswordEntryStepState.NextStep.loading,
              action: Step2PasswordEntryStepAction.NextAction.loading,
              then: Step3LoadingStepView.init(store:)
            )
          }
        }
      )
    )
    .alert(
      store.scope(
        state: \.alert,
        action: Step2PasswordEntryStepAction.alert
      ),
      dismiss: .dismiss
    )
  }
}
