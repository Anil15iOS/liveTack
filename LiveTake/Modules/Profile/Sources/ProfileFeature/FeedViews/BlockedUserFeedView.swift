//
//  BlockedUserFeedView.swift
//  
//
//  Created by Laura Guo on 3/6/22.
//

import ComposableArchitecture
import Foundation
import StyleGuide
import SwiftUI
import UIKit

public struct BlockedUserFeedCore: Equatable {
}

public let blockedUserReducer = Reducer<
  BlockedUserState, BlockedUserAction, BlockedUserEnvironment
> { _, action, _ in
  switch action {
  case .binding:
    return .none
  case .onAppear:
    return .none
  }
}
.binding()


public struct BlockedUserState: Equatable {
  @BindableState var blockedUserUsername: String = "easymoneysniper"

  init() {
  }
}

public enum BlockedUserAction: BindableAction, Equatable {
  case binding(BindingAction<BlockedUserState>)
  case onAppear
}

public struct BlockedUserEnvironment { }

extension BlockedUserEnvironment {
  static let noop = Self()
}

struct BlockedUserFeedView: View {
  let store: Store<BlockedUserState, BlockedUserAction>

  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Text("@\(viewStore.blockedUserUsername) is blocked.")
            .bold()
            .foregroundColor(.white)
            .font(.caption)
            .padding(.bottom)

          Button {
            // TODO: Implement unblock
          } label: {
            Text("Unblock")
              .font(.body.weight(.medium))
              .frame(maxWidth: .infinity)
              .frame(height: 48)
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.secondaryBackgroundGray)
          .foregroundColor(.white)
          .frame(alignment: .bottom)
          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.LiveTake.primaryBackgroundColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
      }
    }
  }
}

// MARK: - Previews
struct BlockedUser_Previews: PreviewProvider {
  static var previews: some View {
    BlockedUserFeedView(
      store: Store(
        initialState: .init(),
        reducer: blockedUserReducer,
        environment: .noop
      )
    )
  }
}
