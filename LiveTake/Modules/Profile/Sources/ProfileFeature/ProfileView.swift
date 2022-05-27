//
//  ProfileView.swift
//  LiveTake
//
//  Created by Laura Guo on 1/6/22.
//  Copyright © 2021 LiveTake. All rights reserved.
//

import BottomSheet
import ComposableArchitecture
import ComposablePresentation
import StyleGuide
import SwiftUI

public struct ProfileView: View {
  @State private var viewMode: BottomSheetViewMode = .collapsed

  let store: Store<ProfileState, ProfileAction>

  public init(store: Store<ProfileState, ProfileAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ZStack(alignment: .top) {
        VStack(spacing: 8) {
          HStack {
            UserAvatar()

            VStack(alignment: .trailing, spacing: 24) {
              HStack(spacing: 16) {
                Button {
                  // TODO: Add action
                } label: {
                  VStack {
                    Text(String(viewStore.followerCount))
                      .font(.system(size: 17))
                      .foregroundColor(.black)
                      .fontWeight(.bold)

                    Text("Followers")
                      .font(.system(size: 14))
                      .foregroundColor(.black)
                  }
                }

                Button {
                  // TODO: Add action
                } label: {
                  VStack {
                    Text(String(viewStore.followingCount))
                      .font(.system(size: 17))
                      .foregroundColor(.black)
                      .fontWeight(.bold)
                    Text("Following")
                      .font(.system(size: 14))
                      .foregroundColor(.black)
                  }
                }
              }
              .frame(maxWidth: .infinity, alignment: .center)

              Button {
              } label: {
                Text(viewStore.viewMode.buttonText)
                  .foregroundColor(.white)
                  .font(.system(size: 13))
                  .frame(width: 120, height: 24)
              }
              .buttonBorderShape(.capsule)
              .buttonStyle(.borderedProminent)
              .tint(.LiveTake.blackish)
            }
          }

          // swiftlint:disable line_length
          Text(
            "Look man. Plain and simple as it is. I watch as many games as I can and talk about what I see. Hot takes daily so please @ Me everytime. Let's go!"
          )
          // swiftlint:enable line_length
          .font(.system(size: 14))
          .foregroundColor(.black)

          RingSection()
        }
        .padding()

        BottomSheetView(
          viewMode: $viewMode,
          minHeight: .percentage(0.65),
          style: .livetake
        ) {
          switch viewStore.viewMode {
          case .loggedInUser:
            ProfileFeedView()
          case .otherUser(blocked: true):
            BlockedUserFeedView(
              store: store.scope(
                state: \.blockedUserState,
                action: ProfileAction.blockedUser
              )
            )
          case .otherUser(blocked: false):
            ProfileFeedView()
          }
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .background(.white)
    }
  }
}

// MARK: - Subviews

extension ProfileView {
  struct UserAvatar: View {
    var body: some View {
      VStack {
        Image("brettokamoto", bundle: .module)
          .resizable()
          .frame(width: 68, height: 68)
          .foregroundColor(.white)
          .clipShape(Circle())

        Text("easymoneysniper")
          .foregroundColor(.black)
          .fontWeight(.semibold)
          .font(.system(size: 14))

        Text("Kenny Stewart")
          .foregroundColor(.gray)
          .font(.system(size: 14))
      }
    }
  }

  struct RingSection: View {
    var body: some View {
      VStack(spacing: 8) {
        Text("RING COUNT")
          .font(.system(size: 13).weight(.heavy))
          .foregroundColor(.black)

        HStack {
          Image("ring-filled", bundle: .module)
          Image("ring-filled", bundle: .module)
          Image("ring-filled", bundle: .module)
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
    }
  }
}

extension BottomSheetStyle {
  static let livetake = BottomSheetStyle(
    color: .LiveTake.primaryBackgroundColor,
    cornerRadius: 0,
    modifier: BottomSheetStyle.standardModifier,
    snapRatio: 0.25,
    handleStyle: .standard
  )
}

// MARK: - Profile View Mode Configuration

extension ProfileState.ViewMode {
  var buttonText: String {
    switch self {
    case .otherUser(let isBlocked):
      return isBlocked ? "Unblock" : "Follow"
    case .loggedInUser:
      return "Challenges"
    }
  }
}

// MARK: - Previews

struct Profile_Previews: PreviewProvider {
  static func previewDisplayName(for viewMode: ProfileState.ViewMode) -> String {
    switch viewMode {
    case .loggedInUser:
      return "My own Profile"
    case .otherUser(let isBlocked):
      return isBlocked
      ? "Someone Else's Profile who's blocked"
      : "Someone Else's Profile"
    }
  }

  static var previews: some View {
    ForEach(ProfileState.ViewMode.allCases) { viewMode in
      NavigationView {
        ProfileView(
          store: Store(
            initialState: .init(viewMode: viewMode),
            reducer: profileReducer,
            environment: .noop
          )
        )
      }
      .previewDisplayName(previewDisplayName(for: viewMode))
    }
  }
}
