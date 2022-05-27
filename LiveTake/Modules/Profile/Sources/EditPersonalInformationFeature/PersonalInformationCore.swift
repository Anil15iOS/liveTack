import ComposableArchitecture
import Foundation
import UIKit.UIApplication
import UIKit.UIResponder


public struct PersonalInformationState: Equatable {
  // TODO: Make birthday a date picker
  @BindableState var birthday: String
  @BindableState var birthdayDate: Date = .now
  @BindableState var phoneNumber: String
  @BindableState var isValidPhoneNumber = false
  @BindableState var name: String
  @BindableState var username: String

  // Focus
  // @BindableState var focusedField: Field?
  @BindableState var phoneNumberFieldIsFocused = false

  enum Field: String, Hashable {
    case phone
    case name
    case birthday
  }

  public init(
    username: String = "easymoneysniper",
    name: String = "Kenny Stewart",
    phoneNumber: String = "(310) 344-2378",
    birthday: String = "October 18, 1988"
  ) {
    self.username = username
    self.name = name
    self.phoneNumber = phoneNumber
    self.birthday = birthday
  }
}

public enum PersonalInformationAction: BindableAction, Equatable {
  case didAppear
  case previous
  case next
  case binding(BindingAction<PersonalInformationState>)
}

public struct PersonalInformationEnvironment {
  public init() {
  }
}

extension PersonalInformationEnvironment {
  static let noop = Self()
}

public let personalInformationReducer = Reducer<
  PersonalInformationState, PersonalInformationAction, PersonalInformationEnvironment
> { _, action, _ in
  switch action {
  case .didAppear:
    return .none
  case .previous:
    return .none
  case .next:
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    return .none
  case .binding:
    return .none
  }
}
.binding()
