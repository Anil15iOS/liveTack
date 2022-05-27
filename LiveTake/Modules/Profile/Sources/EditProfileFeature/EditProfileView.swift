//
//  EditProfileView.swift
//  
//
//  Created by Laura Guo on 3/4/22.
//

import AboutFeature
import ComposableArchitecture
import ComposablePresentation
import EditPersonalInformationFeature
import StyleGuide
import SwiftUI
import TCAHelpers
import NotificationSettingsFeature
import PrivacySettingsFeature

public struct EditProfileView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var fieldLabelWidth: CGFloat?

  let store: Store<EditProfileState, EditProfileAction>

  public init(store: Store<EditProfileState, EditProfileAction>) {
    self.store = store
    // TODO: Extract UIKit appearance to app init
    UITextView.appearance().backgroundColor = .clear
    UITextView.appearance().textContainerInset = .zero
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 16) {
          Text("Edit Profile")
            .foregroundColor(.white)
            .font(.title2.weight(.semibold))
            .padding([.leading, .top])

          VStack {
            Circle()
              .strokeBorder(Color.LiveTake.separator, lineWidth: 2)
              .frame(width: 80, height: 80)
            Button {
              // TODO: Implement edit profile photo
            } label: {
              Text("Edit Photo")
                .font(.footnote)
            }
          }
          .padding(.horizontal)

          VStack {
            Divider().background(.gray)
            HStack {
              Text("Username")
                .foregroundColor(.white)
                .padding(.trailing)
                .equalWidth()
                .frame(width: fieldLabelWidth, alignment: .leading)

              TextField("", text: viewStore.binding(\.$username))
            }
            .frame(height: 48)
            .padding(.horizontal)

            Divider().background(.gray)
            HStack {
              Text("Name")
                .foregroundColor(.white)
                .equalWidth()
                .frame(width: fieldLabelWidth, alignment: .leading)
              TextField("", text: viewStore.binding(\.$name))
            }
            .frame(height: 48)
            .padding(.horizontal)
            Divider().background(.gray)

            HStack(alignment: .top) {
              Text("Bio")
                .foregroundColor(.white)
                .frame(alignment: .leading)
                .equalWidth()
                .frame(width: fieldLabelWidth, alignment: .leading)

              TextEditor(text: viewStore.binding(\.$bio))
                .lineSpacing(0.0)
                .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(minHeight: 48)
            Divider().background(.gray)
          }
          .onPreferenceChange(WidthPreferenceKey.self) { widths in
            if let width = widths.max() {
              self.fieldLabelWidth = width
            }
          }

          // MARK: Settings Section

          VStack(alignment: .leading) {
            Text("Settings")
              .font(.title2.weight(.semibold))
              .foregroundColor(.white)
              .padding()

            VStack(spacing: 0) {
              SettingsRow(
                title: "Personal Information",
                icon: "person.crop.circle",
                optionalStateStore: store.scope(
                  state: (\EditProfileState.route)
                    .appending(path: /EditProfileState.Route.personalInformation)
                    .extract(from:),
                  action: (/EditProfileAction.route).appending(path: /EditProfileAction.RouteAction.personalInformation)
                    .embed
                ),
                setActive: { viewStore.send($0 ? .navigate(to: .personalInformation) : .navigate(to: .none)) },
                destination: PersonalInformationView.init(store:)
              )

              SettingsRow(
                title: "Notifications",
                icon: "bell",
                optionalStateStore: store.scope(
                  state: (\EditProfileState.route)
                    .appending(path: /EditProfileState.Route.notificationSettings)
                    .extract(from:),
                  action: (/EditProfileAction.route)
                    .appending(path: /EditProfileAction.RouteAction.notificationSettings)
                    .embed
                ),
                setActive: { viewStore.send($0 ? .navigate(to: .notificationSettings) : .navigate(to: .none)) },
                destination: NotificationSettingsView.init(store:)
              )

              SettingsRow(
                title: "Privacy",
                icon: "lock",
                optionalStateStore: store.scope(
                  state: (\EditProfileState.route)
                    .appending(path: /EditProfileState.Route.privacySettings)
                    .extract(from:),
                  action: (/EditProfileAction.route).appending(path: /EditProfileAction.RouteAction.privacySettings)
                    .embed
                ),
                setActive: { viewStore.send($0 ? .navigate(to: .privacySettings) : .navigate(to: .none)) },
                destination: PrivacySettingsView.init(store:)
              )

              SettingsRow(
                title: "About",
                icon: "info.circle",
                optionalStateStore: store.scope(
                  state: (\EditProfileState.route)
                    .appending(path: /EditProfileState.Route.about)
                    .extract(from:),
                  action: (/EditProfileAction.route).appending(path: /EditProfileAction.RouteAction.about)
                    .embed
                ),
                setActive: { viewStore.send($0 ? .navigate(to: .about) : .navigate(to: .none)) },
                destination: AboutView.init(store:)
              )

              Button("Logout") {
                viewStore.send(.logoutButtonTapped)
              }
              .padding()
              .buttonStyle(.borderedProminent)
              .buttonBorderShape(.capsule)
              .tint(Color.LiveTake.secondaryBackgroundGray)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(Color.LiveTake.primaryBackgroundColor)
      .preferredColorScheme(.dark)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("")
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItemGroup(placement: .navigation) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
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
      }
    }
  }
}

// MARK: - Subviews

extension EditProfileView {
  struct SettingsRow<Content, State, Action>: View where Content: View {
    let title: String
    let icon: String
    let optionalStateStore: Store<State?, Action>
    let setActive: (Bool) -> Void
    let destination: (Store<State, Action>) -> Content

    var body: some View {
      HStack(alignment: .rowAlignment, spacing: 8) {
        Image(systemName: icon)
          .alignmentGuide(.rowAlignment, computeValue: { $0[VerticalAlignment.center] })
          .foregroundColor(.gray)
          .font(.system(size: 24))
          .padding(.horizontal)

        VStack(spacing: 0) {
          NavigationLinkWithStore(
            optionalStateStore,
            setActive: setActive,
            destination: destination) {
            HStack(alignment: .center) {
              Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .alignmentGuide(.rowAlignment, computeValue: { $0[VerticalAlignment.center] })
              Image(systemName: "chevron.right")
                .font(.system(size: 16))
            }
          }
          .buttonStyle(.plain)
          .frame(height: 56)
          .padding(.trailing)

          Divider().background(Color.LiveTake.separator)
        }
      }
    }
  }
}

// MARK: - Alignment Helpers

extension VerticalAlignment {
  private enum SettingsRowIconAlignment: AlignmentID {
    static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
      return dimensions[VerticalAlignment.center]
    }
  }
  static let rowAlignment = VerticalAlignment(SettingsRowIconAlignment.self)
}

struct WidthPreferenceKey: PreferenceKey {
  static var defaultValue: [CGFloat] = []
  static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
    value.append(contentsOf: nextValue())
  }
}

struct EqualWidth: ViewModifier {
  func body(content: Content) -> some View {
    content.overlay(
      GeometryReader { geo in
        Color.clear
          .preference(
            key: WidthPreferenceKey.self,
            value: [geo.size.width]
          )
      }
    )
  }
}

extension View {
  func equalWidth() -> some View {
    modifier(EqualWidth())
  }
}


// MARK: - Previews

struct EditProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      EditProfileView(
        store: Store(
          initialState: .init(),
          reducer: editProfileReducer,
          environment: .noop
        )
      )
    }
  }
}
