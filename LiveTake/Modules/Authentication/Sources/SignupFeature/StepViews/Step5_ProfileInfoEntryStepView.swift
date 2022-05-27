import AuthenticationClient
import ComposableArchitecture
import ComposablePresentation
import SwiftUI
import ProfileInfoEntryStepFeature

struct Step5ProfileInfoEntryStepState: Equatable {
  var context: AuthContext
  var state: ProfileInfoEntryStepState
  var next: NextStep?

  enum NextStep: Equatable {
    case loading(Step6LoadingStepState)
  }
}

// MARK: - Action

public enum Step5ProfileInfoEntryStepAction: Equatable {
  case dismissedNextStep
  case nextAction(NextAction)
  case profileInfo(ProfileInfoEntryStepAction)
  case signupResponse(Result<AuthSignUpStep, AuthClientError>)
}

extension Step5ProfileInfoEntryStepAction {
  public enum NextAction: Equatable {
    case loading(Step6LoadingStepAction)
  }
}

// MARK: - Reducers

let step5NextStepReducer: Reducer<
  Step5ProfileInfoEntryStepState.NextStep,
  Step5ProfileInfoEntryStepAction.NextAction,
  SignupEnvironment
> = .combine(
  step6Reducer.pullback(
    state: /Step5ProfileInfoEntryStepState.NextStep.loading,
    action: /Step5ProfileInfoEntryStepAction.NextAction.loading,
    environment: { $0 }
  )
)

let step5Reducer: Reducer<
  Step5ProfileInfoEntryStepState,
  Step5ProfileInfoEntryStepAction,
  SignupEnvironment
> = .combine(
  profileInfoEntryStepReducer.pullback(
    state: \.state,
    action: /Step5ProfileInfoEntryStepAction.profileInfo,
    environment: \.step5_ProfileInfo
  ),

  Reducer { state, action, environment in
    switch action {
    case .dismissedNextStep:
      state.next = nil
      return .none

    case .nextAction:
      return .none

    case let .profileInfo(.next(fullname, email, date)):
      state.context.name = fullname
      state.context.email = email
      state.context.birthDate = date

      return environment.authentication
        .signUp(.init(from: state.context))
        .receive(on: environment.mainQueue)
        .catchToEffect(Step5ProfileInfoEntryStepAction.signupResponse)

    case .profileInfo:
      return .none

    case .signupResponse(.success):
      state.next = .loading(.init(context: state.context, state: .init()))
      return .none

    case .signupResponse(.failure):
      return .none
    }
  }
)
.presenting(
  step5NextStepReducer,
  state: .keyPath(\.next),
  id: .notNil(),
  action: /Step5ProfileInfoEntryStepAction.nextAction,
  environment: { $0 }
)


extension SignUpRequest {
  init(from context: AuthContext) {
    self.init(
      phoneNumber: context.phoneNumber,
      username: context.username ?? "",
      password: context.password ?? "",
      name: context.name,
      email: context.email ?? "",
      birthdate: context.birthDate
    )
  }
}

// MARK: - View

struct Step5ProfileInfoEntryStepView: View {
  let store: Store<Step5ProfileInfoEntryStepState, Step5ProfileInfoEntryStepAction>

  var body: some View {
    ProfileInfoEntryStepView(
      store: store.scope(
        state: \.state,
        action: Step5ProfileInfoEntryStepAction.profileInfo
      )
    ).background(
      NavigationLinkWithStore(
        store.scope(state: \.next, action: Step5ProfileInfoEntryStepAction.nextAction),
        mapState: replayNonNil(),
        onDeactivate: { ViewStore(store.stateless).send(.dismissedNextStep) },
        destination: {
          SwitchStore($0) {
            CaseLet(
              state: /Step5ProfileInfoEntryStepState.NextStep.loading,
              action: Step5ProfileInfoEntryStepAction.NextAction.loading,
              then: Step6LoadingStepView.init(store:)
            )
          }
        }
      )
    )
  }
}
