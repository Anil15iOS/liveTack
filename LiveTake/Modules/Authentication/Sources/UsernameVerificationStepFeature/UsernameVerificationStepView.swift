import AuthContainerFeature
import ComposableArchitecture
import SwiftUI

public struct UsernameVerificationStepView: View {
  let store: Store<UsernameVerificationStepState, UsernameVerificationStepAction>

  @Environment(\.dismiss) private var dismiss

  public init(
    store: Store<UsernameVerificationStepState, UsernameVerificationStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(hideNext: true) {
        VStack(alignment: .leading, spacing: 24) {
          Text("Username Verification")
            .foregroundColor(.LiveTake.blueLabel)

          VStack(alignment: .leading, spacing: 12) {
            Text("Kevin? 👀")
              .font(.title3)
              .foregroundColor(.white)

            Text("Welcome to LiveTake. Let’s verify your username.")
              .font(.callout)
              .foregroundColor(.LiveTake.subtleTextColor)
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 160)

        Spacer()

        VStack(spacing: 16) {
          Text(viewStore.username)
            .foregroundColor(.white)

          Group {
            Button {
              viewStore.send(.setVerificationType(.instagram))
            } label: {
              HStack {
                Image("")
                Text("Verify via Instagram")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 48)
            }

            Button {
              viewStore.send(.setVerificationType(.twitter))
            } label: {
              HStack {
                Image("")
                Text("Verify via Twitter")
              }
              .frame(maxWidth: .infinity)
              .frame(height: 48)
            }
          }
          .font(.body.weight(.medium))
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(.white)
          .foregroundColor(.black)

          Button {
            dismiss()
          } label: {
            Text("Change Username")
              .font(.body.weight(.medium))
              .frame(maxWidth: .infinity)
              .frame(height: 48)
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.secondaryBackgroundGray)
          .foregroundColor(.white)
        }
      } onNext: {
      }
      .sheet(
        item: viewStore.binding(
          get: \.verificationType,
          send: UsernameVerificationStepAction.setVerificationType
        )
      ) { verificationType in
        VStack {
          Text(verificationType.description)
            .font(.largeTitle)
          Text("this is where the user will be going through the verification flow")
            .padding()
            .font(.caption)

          Button {
            viewStore.send(.verifiedSuccessfully)
          } label: {
            Text("Yayy succeed")
          }
          .buttonStyle(.bordered)
        }
      }
    }
  }
}

extension UsernameVerificationStepState.VerificationType: CustomStringConvertible {
  public var description: String {
    switch self {
    case .instagram:
      return "Instagram"
    case .twitter:
      return "Twitter"
    }
  }
}

// MARK: - Previews

struct UsernameVerificationStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UsernameVerificationStepView(
        store: Store(
          initialState: .init(username: "easymoneysniper"),
          reducer: usernameVerificationStepReducer,
          environment: .noop
        )
      )
    }
  }
}
