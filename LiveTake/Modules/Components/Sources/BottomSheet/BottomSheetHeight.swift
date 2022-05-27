//
//  BottomSheetView.swift
//  
//
//  Created by Laura Guo on 2/10/22.
//

import SwiftUI

// This enum defines the heights that a bottom sheet can have.

public enum BottomSheetHeight {
  /// The total available height.
  case available

  /// A percentage of the total available height (0-1).
  case percentage(CGFloat)

  /// A fixed number of points.
  case points(CGFloat)
}
