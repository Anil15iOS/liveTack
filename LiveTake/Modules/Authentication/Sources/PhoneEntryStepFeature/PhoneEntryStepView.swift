import AuthContainerFeature
import SwiftUI
import ComposableArchitecture
import ComposablePresentation
import PhoneNumberField
import Utility

public struct PhoneEntryStepView: View {
  let store: Store<PhoneEntryStepState, PhoneEntryStepAction>

  public init(
    store: Store<PhoneEntryStepState, PhoneEntryStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(nextButtonState: viewStore.binding(\.$nextButtonState)) {
        VStack(alignment: .leading, spacing: 24) {
          Text(viewStore.entryPoint.title)
            .font(.title3)
            .foregroundColor(.white)

          HStack {
            Text("+1")
              .foregroundColor(viewStore.isFocused ? .white : .white.opacity(0.5))
              .font(.body.weight(.light))

            PhoneNumberField(
              text: viewStore.binding( \.$phoneNumber),
              isValid: viewStore.binding(\.$isValid).animation(),
              isEditing: viewStore.binding(\.$isFocused)
            )
              .font(.preferredFont(forTextStyle: .body).light)
              .foregroundColor(Color.white)

            if viewStore.isValid {
              Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .aspectRatio(1, contentMode: .fit)
                .padding(.vertical, 12)
                .foregroundColor(.LiveTake.greenCheckmark)
            }
          }
          .tint(.white)
          .accentColor(.gray)
          .frame(height: 48)
          .padding(.horizontal)
          .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
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

extension PhoneEntryStepState.EntryPoint {
  var title: String {
    switch self {
    case .login:
      return "Enter number"
    case .signup:
      return "What's your number?"
    }
  }
}

// MARK: - Previews

// TODO: Fix Why the number field is crashing the preview

// public struct PhoneEntryStepView_Previews: PreviewProvider {
//  public static var previews: some View {
//    Group {
//      NavigationView {
//        PhoneEntryStepView(
//          store: .init(
//            initialState: .init(entryPoint: .login),
//            reducer: phoneEntryStepReducer,
//            environment: .noop
//          )
//        )
//      }
//
//      NavigationView {
//        PhoneEntryStepView(
//          store: .init(
//            initialState: .init(entryPoint: .signup),
//            reducer: phoneEntryStepReducer,
//            environment: .noop
//          )
//        )
//      }
//    }
//  }
// }
