import ComposableArchitecture
import StyleGuide
import SwiftUI
import UIKit

public struct ReportUserView: View {
  let store: Store<ReportUserState, ReportUserAction>

  @Environment(\.dismiss) private var dismiss

  public init(
    store: Store<ReportUserState, ReportUserAction>
  ) {
    self.store = store
    // TODO: Extract UIKit appearance to app init
    UITextView.appearance().backgroundColor = .clear
  }


  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Divider().foregroundColor(.gray)

        VStack(spacing: 32) {
          VStack {
            // TODO: Get actual user picture
            Image(systemName: viewStore.reportedUser.image)
              .resizable()
              .frame(width: 32, height: 32)

            Text(viewStore.reportedUser.username)
              .foregroundColor(.white)
              .font(.caption)
          }

          // Report User Description
          VStack(alignment: .leading) {
            Text("Please describe the issue you are experiencing with this user.")
              .foregroundColor(.white)
              .font(.body)

            // TODO: Implement Report Message Text Field

            TextEditor(text: viewStore.binding(\.$reportMessage))
            // TODO: Look up what the right line limit is.
              .lineLimit(3)
              .tint(.white)
              .frame(height: 96)
              .foregroundColor(.white)
              .font(.body.weight(.light))
              .padding(4)
              .background(Color.LiveTake.secondaryBackgroundGray)
              .cornerRadius(4)
          }

          Spacer()

          Button {
            // TODO: Implement submit report message
          } label: {
            Text("Submit Report")
              .font(.body.weight(.medium))
              .frame(maxWidth: .infinity)
              .frame(height: 48)
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.secondaryBackgroundGray)
          .foregroundColor(.white)
          .frame(alignment: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
      }
      .background(Color.LiveTake.primaryBackgroundColor)
      .preferredColorScheme(.dark)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItemGroup(placement: .primaryAction) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .foregroundColor(.white)
              .frame(width: 24, height: 24)
          }
        }
        ToolbarItemGroup(placement: .principal) {
          Text("Report User")
            .foregroundColor(.white)
            .font(.body.weight(.semibold))
        }
      }
    }
  }
}

// MARK: - Previews

struct ReportUserView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ReportUserView(
        store: Store(
          initialState: .init(),
          reducer: reportUserReducer,
          environment: .noop
        )
      )
    }
  }
}
