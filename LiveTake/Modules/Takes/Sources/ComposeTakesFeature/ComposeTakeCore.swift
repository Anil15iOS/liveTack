import ComposableArchitecture
import Foundation
import UIKit.UIApplication
import UIKit.UIResponder
import SwiftUI

public struct ComposeTakeState: Equatable {
  @BindableState var userProfileImage: Image
  @BindableState var leftPollItem: PollItem
  @BindableState var rightPollItem: PollItem
  @BindableState var takePhoto: Image?
  @BindableState var selectedLeague: League?
  @BindableState var focusedField: Field?

  enum Field {
    case left
    case right
  }

  public let defaultLeftPollItem: PollItem
  public let defaultRightPollItem: PollItem

  private static let leftPollPrompts: [String] = ["YEEEE BOIIII", "ON POINT", "💯", "YESSIRR"]
  private static let rightPollPrompts: [String] = ["NAHHH BRA", "YOU TRIPPIN", "👎", "NO DICE"]

  public init(
    userProfileImage: Image = Image(systemName: "xmark"),
    takePhoto: Image? = nil,
    selectedLeague: League? = nil
  ) {
    self.userProfileImage = userProfileImage
    self.selectedLeague = selectedLeague

    // Randomize Prompts
    let leftPollPrompt = Self.leftPollPrompts[Int.random(in: 0..<Self.leftPollPrompts.count)]
    let rightPollPrompt = Self.rightPollPrompts[Int.random(in: 0..<Self.rightPollPrompts.count)]
    self.defaultLeftPollItem = PollItem(text: leftPollPrompt, color: .green)
    self.defaultRightPollItem = PollItem(text: rightPollPrompt, color: .red)
    self.leftPollItem = defaultLeftPollItem
    self.rightPollItem = defaultRightPollItem
  }
}

public struct PollItem: Equatable {
  var text: String
  var color: Color
}

public enum ComposeTakeAction: BindableAction, Equatable {
  case didAppear
  case previous
  case next
  case binding(BindingAction<ComposeTakeState>)
}

public struct ComposeTakeEnvironment {
  public init() {
  }
}

public let composeTakeReducer = Reducer<
  ComposeTakeState, ComposeTakeAction, ComposeTakeEnvironment
> { state, action, _ in
  switch action {
  case .didAppear:
    return .none
  case .previous:
    return .none
  case .next:
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    return .none
  case .binding(\.$leftPollItem):
    if state.leftPollItem.text.isEmpty {
      state.leftPollItem = state.defaultLeftPollItem
    }
    return .none
  case .binding(\.$rightPollItem):
    if state.rightPollItem.text.isEmpty {
      state.rightPollItem = state.defaultRightPollItem
    }
    return .none
  case .binding:
    return .none
  }
}
.binding()
