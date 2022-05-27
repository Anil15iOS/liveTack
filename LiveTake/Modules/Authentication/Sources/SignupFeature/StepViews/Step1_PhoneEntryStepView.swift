import AuthenticationClient
import ComposableArchitecture
import ComposablePresentation
import PhoneEntryStepFeature
import SwiftUI

struct Step1PhoneEntryStepState: Equatable {
  var context: AuthContext
  var state: PhoneEntryStepState
  var next: NextStep?

  var alert: AlertState<Step1PhoneEntryStepAction.AlertAction>?

  enum NextStep: Equatable {
    case usernameEntry(Step3UsernameEntryStepState)
  }
}

public enum Step1PhoneEntryStepAction: Equatable {
  case alert(AlertAction)
  case dismissedNextStep
  case phoneEntry(PhoneEntryStepAction)
  case nextAction(NextAction)
  case verifyUserExists(Result<Bool, AuthClientError>)
}

extension Step1PhoneEntryStepAction {
  public enum NextAction: Equatable {
    case usernameEntry(Step3UsernameEntryStepAction)
  }

  public enum AlertAction: Equatable {
    case dismiss
  }
}

let step1NextStepReducer: Reducer<
  Step1PhoneEntryStepState.NextStep,
  Step1PhoneEntryStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step3Reducer.pullback(
    state: /Step1PhoneEntryStepState.NextStep.usernameEntry,
    action: /Step1PhoneEntryStepAction.NextAction.usernameEntry,
    environment: { $0 }
  )
)

let step1Reducer: Reducer<
  Step1PhoneEntryStepState,
  Step1PhoneEntryStepAction,
  SignupEnvironment
> = .combine(
  phoneEntryStepReducer.pullback(
    state: \.state,
    action: /Step1PhoneEntryStepAction.phoneEntry,
    environment: \.step1_PhoneEntry
  ),

  Reducer { state, action, environment in
    switch action {
    case .alert(.dismiss):
      state.alert = nil
      return .none

    case .dismissedNextStep:
      state.next = nil
      return environment.authentication
        .deleteUser()
        .fireAndForget()

    case .phoneEntry(.next(let phoneNumber)):
      state.context.phoneNumber = phoneNumber
      return environment.authentication
        .verifyUserExists(phoneNumber)
        .receive(on: environment.mainQueue)
        .catchToEffect(Step1PhoneEntryStepAction.verifyUserExists)

    case .phoneEntry:
      return .none

    case .nextAction:
      return .none

    case .verifyUserExists(.success(let exists)):
      if exists {
        state.alert = .init(title: TextState("User exists"))
      } else {
        state.next = .usernameEntry(
          .init(context: state.context, state: .init())
        )
      }
      print("✅ \(exists)")
      return Effect(value: .phoneEntry(.set(\.$nextButtonState, .enabled)))

    case .verifyUserExists(.failure(let error)):
      state.alert = .init(title: TextState("Error Occured"))
      print("🚫 \(error)")
      return Effect(value: .phoneEntry(.set(\.$nextButtonState, .enabled)))
    }
  }
)
.presenting(
  step1NextStepReducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step1PhoneEntryStepAction.nextAction,
  environment: { $0 }
)

struct Step1PhoneEntryStepView: View {
  let store: Store<Step1PhoneEntryStepState, Step1PhoneEntryStepAction>

  var body: some View {
    PhoneEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step1PhoneEntryStepAction.phoneEntry
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step1PhoneEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: { ViewStore(store.stateless).send(.dismissedNextStep) },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step1PhoneEntryStepState.NextStep.usernameEntry,
              action: Step1PhoneEntryStepAction.NextAction.usernameEntry,
              then: Step3UsernameEntryStepView.init(store:)
            )
          }
        }
      )
    )
    .alert(
      store.scope(
        state: \.alert,
        action: Step1PhoneEntryStepAction.alert
      ),
      dismiss: .dismiss
    )
  }
}
