import ComposableArchitecture
import SwiftUI
import StyleGuide
import UIKit.UIApplication
import UIKit.UIResponder

// TODO: Extract into it's own component
public enum NextButtonState: Equatable {
  case disabled
  case loading
  case enabled

  var isEnabled: Bool { self == .enabled }
}

public struct AuthStepView<Content>: View where Content: View {
  let title: String?
  let scrollable: Bool
  let hideNext: Bool

  let content: () -> Content
  let onNext: () -> Void

  @Binding private var nextButtonState: NextButtonState

  @Environment(\.dismiss) private var dismiss

  public init(
    title: String? = nil,
    scrollable: Bool = false,
    hideNext: Bool = false,
    nextButtonState: Binding<NextButtonState> = .constant(.disabled),
    @ViewBuilder content: @escaping () -> Content,
    onNext: @escaping () -> Void
  ) {
    self.title = title
    self.scrollable = scrollable
    self.hideNext = hideNext
    self.content = content
    self.onNext = onNext
    self._nextButtonState = nextButtonState

    // clear nav bar
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().tintColor = .clear
    UINavigationBar.appearance().backgroundColor = .clear
  }

  public var body: some View {
    Group {
      if scrollable {
        ScrollView {
          VStack(content: content)
            .background(Color.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      } else {
        VStack(content: content)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      }
    }
    .disabled(nextButtonState == .loading)
    .padding(.horizontal)
    .background(Color.LiveTake.darkBackground.ignoresSafeArea())
    .navigationBarBackButtonHidden(true)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          UIApplication.shared.endEditing()
          dismiss()
        } label: {
          Image(systemName: "chevron.backward")
        }
        .tint(.LiveTake.backButtonColor)
      }

      ToolbarItem(placement: .principal) {
        if let title = title {
          Text(title)
            .foregroundColor(.white)
        }
      }
    }
    .overlay(alignment: .bottomTrailing) {
      if hideNext == false {
        Button(action: onNext) {
          Group {
            if nextButtonState == .loading {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .LiveTake.labelGray))
            } else {
              Image(systemName: "chevron.right")
                .font(.title3.weight(.bold))
                .foregroundColor(.black)
            }
          }
          .frame(width: 56, height: 56)
          .background(nextButtonState == .enabled ? .white : .LiveTake.nextButtonDisabledBackground)
        }
        .buttonStyle(.plain)
        .buttonBorderShape(.capsule)
        .disabled(nextButtonState != .enabled)
        .clipShape(Circle())
        .padding()
      }
    }
  }
}

struct AuthStepView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AuthStepView(nextButtonState: .constant(.enabled)) {
        Group {
          Text("Hello")
          Text("Hello")
          Text("Hello")
        }
        .foregroundColor(.white)
      } onNext: {
        print("You pressed next")
      }
    }
  }
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
