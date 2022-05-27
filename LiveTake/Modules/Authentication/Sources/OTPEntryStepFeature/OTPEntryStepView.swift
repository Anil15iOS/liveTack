import AuthContainerFeature
import ComposableArchitecture
import StyleGuide
import SwiftUI
import Utility

public struct OTPEntryStepView: View {
  let store: Store<OTPEntryStepState, OTPEntryStepAction>

  @FocusState private var focusedField: OTPEntryStepState.Field?
  @Environment(\.dismiss) private var dismiss

  public init(
    store: Store<OTPEntryStepState, OTPEntryStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(nextButtonState: viewStore.binding(\.$nextButtonState)) {
        VStack(alignment: .leading, spacing: 32) {
          VStack(alignment: .leading, spacing: 16) {
            Text("Enter your verification code")
              .font(.title3)
              .foregroundColor(.white)

            HStack {
              Text("Sent to +1 \(viewStore.phoneNumber)")
                .font(.footnote)
                .foregroundColor(.LiveTake.subtleTextColor)

              Button {
                dismiss()
              } label: {
                Text("Change")
                  .font(.footnote)
                  .foregroundColor(.white)
              }
            }
          }

          VStack(spacing: 16) {
            HStack(spacing: 8) {
              Group {
                TextField("", value: viewStore.binding(\.$otpField1), format: .number)
                  .focused($focusedField, equals: .otpField1)
                  .frame(width: 36, height: 48)
                  .allowsHitTesting(viewStore.focusedField == .otpField1 || viewStore.otpField1 == nil)

                TextField("", value: viewStore.binding(\.$otpField2), format: .number)
                  .focused($focusedField, equals: .otpField2)
                  .frame(width: 36, height: 48)
                  .allowsHitTesting(viewStore.focusedField == .otpField2)

                TextField("", value: viewStore.binding(\.$otpField3), format: .number)
                  .focused($focusedField, equals: .otpField3)
                  .frame(width: 36, height: 48)
                  .allowsHitTesting(viewStore.focusedField == .otpField3)

                TextField("", value: viewStore.binding(\.$otpField4), format: .number)
                  .focused($focusedField, equals: .otpField4)
                  .frame(width: 36, height: 48)
                  .allowsHitTesting(viewStore.focusedField == .otpField4 || viewStore.otpField4 != nil)
              }
              .tint(.white)
              .multilineTextAlignment(.center)
              .foregroundColor(.black)
              .accentColor(.gray)
              .font(.body.weight(.light))
              .background(Color.white.cornerRadius(8))
              .keyboardType(.numberPad)
              .textContentType(.oneTimeCode)
              .synchronize(viewStore.binding(\.$focusedField), $focusedField)
            }

            Button("Resend") {
              viewStore.send(.resendButtonTapped)
            }
            .buttonStyle(.plain)
            .font(.footnote)
            .foregroundColor(.gray)
          }
          .frame(maxWidth: .infinity)
        }
        .padding(.top, 160)
      } onNext: {
        viewStore.send(.next)
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

// MARK: - Previews

struct OTPEntryStepView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NavigationView {
        OTPEntryStepView(
          store: Store(
            initialState: .init(phoneNumber: "(555) 555-5555"),
            reducer: otpEntryStepReducer,
            environment: .noop
          )
        )
      }

      NavigationView {
        OTPEntryStepView(
          store: Store(
            initialState: .init(phoneNumber: "(555) 555-5555"),
            reducer: otpEntryStepReducer,
            environment: .noop
          )
        )
      }
    }
  }
}
