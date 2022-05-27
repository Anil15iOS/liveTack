import AuthContainerFeature
import ComposableArchitecture
import UIKit.UIImage

public struct ProfileInfoEntryStepState: Equatable {
  @BindableState var birthdayDate: Date
  @BindableState var email: String
  @BindableState var focusedField: Field?
  @BindableState var fullName: String
  @BindableState var isPhotoPickerPresented: Bool
  @BindableState var pickedPhotos: [UIImage]
  @BindableState var nextButtonState: NextButtonState

  public init(
    birthdayDate: Date = .now,
    email: String = "",
    focusedField: Field? = nil,
    fullName: String = "",
    isPhotoPickerPresented: Bool = false,
    pickedPhotos: [UIImage] = [],
    nextButtonState: NextButtonState = .enabled
  ) {
    self.birthdayDate = birthdayDate
    self.email = email
    self.focusedField = focusedField
    self.fullName = fullName
    self.isPhotoPickerPresented = isPhotoPickerPresented
    self.pickedPhotos = pickedPhotos
    self.nextButtonState = nextButtonState
  }
}

extension ProfileInfoEntryStepState {
  public enum Field: Hashable {
    case fullName
    case email
    case birthday
  }
}
// MARK: - Action

public enum ProfileInfoEntryStepAction: BindableAction, Equatable {
  case binding(BindingAction<ProfileInfoEntryStepState>)
  case onAppear
  case next(fullName: String, email: String, date: Date?)
  case nextButtonTapped
  case showPhotoPicker
}

public struct ProfileInfoEntryStepEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension ProfileInfoEntryStepEnvironment {
  public static let noop = Self(
    mainQueue: .immediate
  )
}

// MARK: - Reducer

public let profileInfoEntryStepReducer: Reducer<
  ProfileInfoEntryStepState,
  ProfileInfoEntryStepAction,
  ProfileInfoEntryStepEnvironment
> = .init { state, action, _ in
  switch action {
  case .binding:
    return .none
  case .onAppear:
    return .none
  case .next:
    return .none
  case .nextButtonTapped:
    return Effect(value: .next(fullName: state.fullName, email: state.email, date: state.birthdayDate))

  case .showPhotoPicker:
    state.isPhotoPickerPresented = true
    return .none
  }
}
.binding()
