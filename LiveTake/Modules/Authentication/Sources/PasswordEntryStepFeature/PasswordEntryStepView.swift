import AuthContainerFeature
import SwiftUI
import ComposableArchitecture
import Utility

public struct PasswordEntryStepView: View {
  let store: Store<PasswordEntryStepState, PasswordEntryStepAction>

  @FocusState private var isFocused

  public init(
    store: Store<PasswordEntryStepState, PasswordEntryStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(nextButtonState: viewStore.binding(\.$nextButtonState)) {
        VStack(alignment: .leading, spacing: 24) {
          HStack {
            Text(viewStore.entryPoint.title)
              .font(.title3)
              .foregroundColor(.white)

            if viewStore.entryPoint.shouldShowCharacterRequirements {
              Text("Min 6 characters")
                .font(.footnote)
                .foregroundColor(.gray)
            }
          }

          VStack(alignment: .trailing, spacing: 12) {
            // Create password field
            HStack {
              SecureField("", text: viewStore.binding(\.$password))
                .focused($isFocused)
                .synchronize(viewStore.binding(\.$isFocused), $isFocused)
                .tint(.white)
                .foregroundColor(.white)
                .accentColor(.gray)

              if viewStore.isValid {
                Image(systemName: "checkmark.circle")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .aspectRatio(1, contentMode: .fit)
                  .padding(.vertical, 12)
                  .foregroundColor(.LiveTake.greenCheckmark)
              }
            }
            .font(.body.weight(.light))
            .frame(height: 48)
            .padding(.horizontal)
            .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))

            if viewStore.entryPoint.shouldShowForgotPasswordButton {
              Button("Forgot Password") {
                viewStore.send(.forgotPasswordButtonTapped)
              }
              .font(.caption)
              .tint(.LiveTake.subtleTextColor)
            }
          }

          // Create conditions check box
          if viewStore.entryPoint.shouldAskForTOSAndPolicyAgreement {
            termsAndPolicyAgreement(viewStore: viewStore)
          }
        }
        .padding(.top, 160)
      } onNext: {
        viewStore.send(.nextButtonTapped)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

extension PasswordEntryStepState.EntryPoint {
  var title: String {
    switch self {
    case .forgotPassword:
      return "Create Password"
    case .login:
      return "Enter Password"
    case .signup:
      return "Create Password"
    }
  }

  var shouldShowCharacterRequirements: Bool {
    switch self {
    case .forgotPassword:
      return true
    case .login:
      return false
    case .signup:
      return true
    }
  }

  var shouldAskForTOSAndPolicyAgreement: Bool {
    switch self {
    case .forgotPassword:
      return false
    case .login:
      return false
    case .signup:
      return true
    }
  }

  var shouldShowForgotPasswordButton: Bool {
    switch self {
    case .forgotPassword:
      return false
    case .login:
      return true
    case .signup:
      return false
    }
  }
}

// MARK: - Subviews

extension PasswordEntryStepView {
  func termsAndPolicyAgreement(viewStore: ViewStore<PasswordEntryStepState, PasswordEntryStepAction>) -> some View {
    HStack(spacing: 8) {
      Toggle("", isOn: viewStore.binding(\.$agreedToTermsAndPolicy))
        .toggleStyle(.checkboxToggle)
        .foregroundColor(.white)

      let termsOfService = Text("[Terms of Service](https://www.google.com)").underline()
      let privacyPolicy = Text("[Privacy Policy](https://www.google.com)").underline()
      let combinedText = Text("I agree to the ") + termsOfService + Text(" & ") + privacyPolicy
      combinedText
        .tint(.white)
        .font(.footnote)
        .foregroundColor(.white)
    }
  }
}

// MARK: - Checkboxes

extension ToggleStyle where Self == CheckboxToggleStyle {
  static var checkboxToggle: CheckboxToggleStyle {
    CheckboxToggleStyle()
  }
}

struct CheckboxToggleStyle: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled
  func makeBody(configuration: Configuration) -> some View {
    Button {
      configuration.isOn.toggle()
    } label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
          .imageScale(.large)
        configuration.label
      }
    }
    .buttonStyle(.plain)
    .disabled(isEnabled == false)
  }
}

// MARK: - Previews

struct PasswordEntryStepView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(PasswordEntryStepState.EntryPoint.allCases, id: \.self) { entry in
      NavigationView {
        PasswordEntryStepView(
          store: Store(
            initialState: .init(entryPoint: entry),
            reducer: passwordEntryStepReducer,
            environment: .noop
          )
        )
      }
    }
  }
}
