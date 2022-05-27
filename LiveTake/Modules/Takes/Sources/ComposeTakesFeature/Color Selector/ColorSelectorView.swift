import StyleGuide
import SwiftUI

enum PollColor: UInt, CaseIterable, Identifiable {
  case green = 0x00FFAD
  case magenta = 0xFF369A
  case purple = 0xA06EFF
  case blue = 0x6AB5FF
  case yellow = 0xFFCF2F
  case white = 0xFFFFFF
  case salmon = 0xFF7B7B
  case violet = 0xF474FF

  var id: Self { self }

  var color: Color {
    Color.hex(self.rawValue)
  }
}

struct ColorSelectorView: View {
  @Binding var selected: PollColor?

  var body: some View {
    HStack(spacing: 12) {
      ForEach(PollColor.allCases) { pollColor in
        ColorButton(color: pollColor.color, isSelected: binding(for: pollColor))
      }
    }
  }

  private func binding(for pollColor: PollColor) -> Binding<Bool> {
    Binding(
      get: { self.selected == pollColor },
      set: { flag in
        if flag { self.selected = pollColor }
      }
    )
  }
}

// MARK: - Subviews

extension ColorSelectorView {
  struct ColorButton: View {
    let color: Color
    @Binding var isSelected: Bool

    var body: some View {
      Button {
        isSelected.toggle()
      } label: {
        Circle()
          .fill(color)
          .frame(width: 12, height: 12)
          .frame(width: 28, height: 28)
          .overlay(
            Circle()
              .stroke(
                isSelected ? .white : Color.hex(0x4E4E4E),
                lineWidth: 1
              )
          )
      }
      .buttonStyle(.plain)
    }
  }
}

// MARK: - Previews

struct ColorSelectorView_Previews: PreviewProvider {
  static var previews: some View {
    ColorSelectorView(selected: .constant(.blue))
      .padding()
      .background(Color.LiveTake.primaryBackgroundColor)
      .previewLayout(.sizeThatFits)
  }
}
