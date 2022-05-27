import ComposableArchitecture
import StyleGuide
import SwiftUI
// import Utility

public struct PersonalInformationView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<PersonalInformationState, PersonalInformationAction>
  // @FocusState private var focusedField: PersonalInformation.Field?

  public init(store: Store<PersonalInformationState, PersonalInformationAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      List {
        Section {
          VStack(alignment: .leading, spacing: 8) {
            Text("Phone")
              .foregroundColor(.white)

            HStack {
              Text("+1")
                .foregroundColor(.white)
                .font(.body.weight(.light))

              // TODO: Implement PhoneNumberField
              TextField("", text: viewStore.binding(\.$phoneNumber))
            }
            .tint(.white)
            .frame(height: 48)
            .foregroundColor(.white)
            .font(.body.weight(.light))
            .padding(.horizontal, 8)
            .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
          }
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)

          VStack(alignment: .leading, spacing: 8) {
            Text("Birthday")
              .foregroundColor(.white)

            TextField(
              "",
              text: viewStore.binding(\.$birthday)
            )
            // TODO: Add focus state
            // .focused($focusedField, equals: .name)
            .tint(.white)
            .frame(height: 48)
            .foregroundColor(.white)
            .font(.body.weight(.light))
            .padding(.horizontal, 8)
            .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
          }
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
        } header: {
          Text("PRIVATE")
            .fontWeight(.medium)
        }
      }
      .listStyle(.plain)
    }
    .padding(.top)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.LiveTake.primaryBackgroundColor)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .navigationTitle("")
    .preferredColorScheme(.dark)
    .toolbar {
      ToolbarItemGroup(placement: .navigation) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.LiveTake.labelGray)
        }
      }
      ToolbarItemGroup(placement: .primaryAction) {
        Button {
        } label: {
          Text("Save")
            .foregroundColor(.gray)
        }
      }
      ToolbarItemGroup(placement: .principal) {
        Text("Personal Information")
          .foregroundColor(.white)
          .bold()
        //        }
      }
    }
  }
}

// MARK: - Previews

struct PersonalInformationView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      PersonalInformationView(
        store: Store(
          initialState: .init(),
          reducer: personalInformationReducer,
          environment: .noop
        )
      )
    }
  }
}
