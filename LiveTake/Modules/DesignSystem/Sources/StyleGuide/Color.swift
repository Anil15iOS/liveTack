import SwiftUI

// TODO: Later probably move to Swiftgen

extension Color {
  public enum LiveTake {
    // black
    public static let blackish = Color.hex(0x1A1A1A)
    // gray
    public static let darkBackground = Color.hex(0x1C1C1C)
    public static let navbarBackground = Color.hex(0x1D1D1D)
    public static let secondaryBackgroundGray = Color.hex(0x232323)
    public static let backButtonColor = Color.hex(0x555555)
    public static let subtleTextColor = Color.hex(0x6B6B6B)
    public static let primaryBackgroundColor = Color.hex(0x151515)
    public static let topBarButtonTint = Color.hex(0x272727)
    public static let filtersBackground = Color.hex(0x3C3C3C)
    public static let labelGray = Color.hex(0x8A8A8A)
    public static let nextButtonDisabledBackground = Color.hex(0x2F2F2F)
    public static let unselectedTab = Color.hex(0x434343)
    public static let separator = Color.hex(0x5A5A5A)
    public static let followingButtonBackground = Color.hex(0x2E2E2E)
    public static let takesTabBackground = Color.hex(0x262626)

    // blue
    public static let blueLabel = Color.hex(0x3697E9)
    public static let createButtonTint = Color.hex(0x1C84C6)

    // green
    public static let greenCheckmark = Color.hex(0x7BFCAD)
  }
}

extension Color {
  public static func hex(_ hex: UInt, opacity: Double = 1.0) -> Self {
    Self.init(
      .sRGB,
      red: Double((hex & 0xff0000) >> 16) / 255,
      green: Double((hex & 0x00ff00) >> 8) / 255,
      blue: Double(hex & 0x0000ff) / 255,
      opacity: opacity
    )
  }
}
