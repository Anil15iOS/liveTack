import StyleGuide
import SwiftUI

struct PollEditorView: View {
  @State var left: String = ""
  @State var right: String = ""
  @State var selectedPollColor: PollColor?
  @Binding var leftPollItem: PollItem
  @Binding var rightPollItem: PollItem

  public init(leftPollItem: Binding<PollItem>, rightPollItem: Binding<PollItem>) {
    self._leftPollItem = leftPollItem
    self._rightPollItem = rightPollItem
  }

  let height: CGFloat = 48
  var body: some View {
    VStack {
      HStack(spacing: 4) {
        TextField("", text: $leftPollItem.text)
          .foregroundColor(leftPollItem.color)
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .frame(maxWidth: .infinity)
          .frame(height: height)
          .background(Color.LiveTake.topBarButtonTint)
          .cornerRadius(height / 2, corners: [.topLeft, .bottomLeft])
          .textCase(.uppercase)
          .autocapitalization(.allCharacters)
          .font(.custom("DIN Condensed Bold", size: 17))

        TextField("", text: $rightPollItem.text)
          .foregroundColor(rightPollItem.color)
          .multilineTextAlignment(.center)
          .lineLimit(2)
          .frame(maxWidth: .infinity)
          .frame(height: height)
          .background(Color.LiveTake.topBarButtonTint)
          .cornerRadius(height / 2, corners: [.topRight, .bottomRight])
          .textCase(.uppercase)
          .autocapitalization(.allCharacters)
          .font(.custom("DIN Condensed Bold", size: 17))
      }
      ColorSelectorView(selected: $selectedPollColor)

      Button {
      } label: {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .frame(width: 28, height: 28)
          .foregroundColor(Color.hex(0x272727))
      }
      .buttonStyle(.plain)
    }
  }
}


// MARK: - Previews

struct PollEditorView_Previews: PreviewProvider {
  static var previews: some View {
    PollEditorView(leftPollItem: .constant(PollItem(text: "hi", color: .green)), rightPollItem: .constant(PollItem(text: "hello", color: .red)))
      .padding()
      .background(Color.LiveTake.primaryBackgroundColor)
      .previewLayout(.sizeThatFits)
  }
}

// TODO: - Move this out of here
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners

  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(
      roundedRect: rect,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: radius, height: radius)
    )
    return Path(path.cgPath)
  }
}

extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
  }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
