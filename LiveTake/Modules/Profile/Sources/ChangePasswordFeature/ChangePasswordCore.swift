//
//  ChangePasswordCore.swift
//  
//
//  Created by Laura Guo on 3/6/22.
//

import ComposableArchitecture

// TODO: Implement save only if new password is valid and all fields  have valid inputs
public struct ChangePasswordState: Equatable {
  @BindableState var currentPassword: String = ""
  @BindableState var newPassword: String = ""

  public init() { }
}

public enum ChangePasswordAction: BindableAction, Equatable {
  case binding(BindingAction<ChangePasswordState>)
  case onAppear
}

public struct ChangePasswordEnvironment {
  public init() { }
}

extension ChangePasswordEnvironment {
  static let noop = Self()
}

public let changePasswordReducer = Reducer<
  ChangePasswordState, ChangePasswordAction, ChangePasswordEnvironment
> { _, action, _ in
  switch action {
  case .binding:
    return .none
  case .onAppear:
    return .none
  }
}
.binding()
