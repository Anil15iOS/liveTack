import ComposableArchitecture
import StyleGuide
import SwiftUI

public struct NotificationSettingsView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<NotificationSettingsState, NotificationSettingsAction>

  public init(store: Store<NotificationSettingsState, NotificationSettingsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Toggle("Notifications On", isOn: viewStore.binding(\.$enableNotifications))
            .font(.body.weight(.semibold))
            .padding([.horizontal, .top])
            .padding(.trailing)

          Group {
            Toggle(
              "LiveTakes Challenges and Start Times",
              isOn: viewStore.binding(\.$enableLivetakesChallengesAndStartTimes).animation()
            )
            Toggle(
              "New Followers",
              isOn: viewStore.binding(\.$enableNewFollowers).animation()
            )
            Toggle(
              "People I'm Following In LiveTakes",
              isOn: viewStore.binding(\.$enableFollowing).animation()
            )
            Toggle(
              "Earned Rings",
              isOn: viewStore.binding(\.$enableEarnedRings).animation()
            )
          }
          .frame(minHeight: 64)
          .padding(.horizontal)
          .background(RoundedRectangle(cornerRadius: 16).fill(Color.LiveTake.secondaryBackgroundGray))
          .padding(.horizontal)
          .disabled(viewStore.enableNotifications == false)
        }
      }
      .background(Color.LiveTake.primaryBackgroundColor)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("")
      .navigationBarBackButtonHidden(true)
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
          Text("Notifications")
            .foregroundColor(.white)
            .bold()
        }
      }
    }
  }
}

// MARK: - Previews

struct NotificationSettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      NotificationSettingsView(
        store: Store(
          initialState: .init(),
          reducer: notificationSettingsReducer,
          environment: .noop
        )
      )
    }
  }
}
