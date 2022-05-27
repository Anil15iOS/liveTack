//
//  BottomSheetHandleBar.swift
//  
//
//  Created by Laura Guo on 2/10/22.
//

import Foundation
import SwiftUI

// This is the entire handle section, including the handle and its padding, the divider line etc.

public struct BottomSheetHandleBar: View {
  public init(style: BottomSheetHandleStyle = .standard) {
    self.style = style
  }

  private let style: BottomSheetHandleStyle

  public var body: some View {
    VStack(spacing: 0) {
      BottomSheetHandle(style: style)
        .withHandlePadding(in: style)
      Divider().background(style.dividerColor)
    }.background(style.backgroundColor)
  }
}

private extension View {
  @ViewBuilder
  func withHandlePadding(in style: BottomSheetHandleStyle) -> some View {
    if let padding = style.padding {
      self.padding(padding)
    } else {
      self.padding()
    }
  }
}

struct BottomSheetHandleBar_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetHandleBar()
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
