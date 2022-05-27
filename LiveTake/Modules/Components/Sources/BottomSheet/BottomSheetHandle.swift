//
//  BottomSheetHandle.swift
//  
//
//  Created by Laura Guo on 2/10/22.
//

import SwiftUI


// This is the thin, rounded handle that is added topmost in a `BottomSheet`. It has no built-in behavior.

public struct BottomSheetHandle: View {
  public init(style: BottomSheetHandleStyle = .standard) {
    self.style = style
  }

  private let style: BottomSheetHandleStyle

  public var body: some View {
    RoundedRectangle(cornerRadius: style.cornerRadius)
      .fill(style.handleColor)
      .frame(width: style.size.width, height: style.size.height)
  }
}

struct BottomSheetHandle_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetHandle()
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
