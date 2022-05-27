import AuthContainerFeature
import ComposableArchitecture
import PhotoPicker
import SwiftUI
import Utility

public struct ProfileInfoEntryStepView: View {
  let store: Store<ProfileInfoEntryStepState, ProfileInfoEntryStepAction>

  @FocusState private var focusedField: ProfileInfoEntryStepState.Field?

  public init(
    store: Store<ProfileInfoEntryStepState, ProfileInfoEntryStepAction>
  ) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      AuthStepView(title: "Profile Info", nextButtonState: viewStore.binding(\.$nextButtonState)) {
        VStack(alignment: .leading, spacing: 16) {
          VStack {
            Button { viewStore.send(.showPhotoPicker) } label: {
              VStack {
                if let image = viewStore.pickedPhotos.first {
                  Image(uiImage: image)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay {
                      Circle()
                        .stroke(Color.gray, lineWidth: 1)
                    }
                } else {
                  Circle()
                    .fill(Color.LiveTake.secondaryBackgroundGray)
                  .frame(width: 80, height: 80)
                  .overlay {
                    Circle()
                      .stroke(Color.gray, lineWidth: 1)
                  }
                }
                Text("Add Photo")
                  .foregroundColor(.white)
                  .font(.footnote)
              }
            }
            .padding(.bottom, 24)
            .sheet(isPresented: viewStore.binding(\.$isPhotoPickerPresented)) {
              PhotoPicker(
                configuration: PhotoPicker.singlePhotoConfiguration,
                images: viewStore.binding(\.$pickedPhotos)
              )
            }

            VStack {
              Text("Name")
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

              TextField(
                "",
                text: viewStore.binding(\.$fullName)
              )
                .focused($focusedField, equals: .fullName)
                .keyboardType(.alphabet)
                .textContentType(.name)
                .textInputAutocapitalization(.words)
                .tint(.white)
                .foregroundColor(.white)
                .accentColor(.gray)
                .frame(height: 48)
                .font(.body.weight(.light))
                .padding(.horizontal, 8)
                .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
            }

            VStack {
              Text("Email")
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
              TextField(
                "",
                text: viewStore.binding(\.$email)
              )
                .focused($focusedField, equals: .email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .tint(.white)
                .foregroundColor(.white)
                .accentColor(.gray)
                .frame(height: 48)
                .font(.body.weight(.light))
                .padding(.horizontal, 8)
                .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
            }

            VStack {
              Text("Birthday")
                .font(.footnote)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

              // TODO: i'll make a custom date picker later
              DatePicker(
                "",
                selection: viewStore.binding(\.$birthdayDate),
                in: ...Date.now,
                displayedComponents: [.date]
              )
                .labelsHidden()
                .tint(.white)
                .foregroundColor(.white)
                .accentColor(.gray)
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.body.weight(.light))
                .padding(.horizontal, 8)
                .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
                .preferredColorScheme(.dark)
            }
          }
          .padding(.horizontal)
          .synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
        }
        .padding(.top, 48)
      } onNext: {
        viewStore.send(.nextButtonTapped)
      }
    }
  }
}

// MARK: - Previews

struct ProfileInfoEntryStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ProfileInfoEntryStepView(
        store: Store(
          initialState: .init(),
          reducer: profileInfoEntryStepReducer,
          environment: .noop
        )
      )
    }
  }
}
