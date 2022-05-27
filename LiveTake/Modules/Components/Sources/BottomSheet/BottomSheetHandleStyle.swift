//
//  BottomSheetHandleStyle.swift
//  
//
//  Created by Laura Guo on 2/10/22.
//

import Foundation
import SwiftUI


// This struct can be used to style a `BottomSheetHandle`.
public struct BottomSheetHandleStyle {
  /// Create a bottom sheet handle instance.
  ///
  /// - Parameters:
  ///   - color: The color of the handle
  ///   - width: The width of the handle
  ///   - height: The height of the handle
  ///   - cornerRadius: The corner radius of the handle
  public init(
    handleColor: Color = Color.secondary,
    backgroundColor: Color = Color.primary.opacity(0.02),
    dividerColor: Color? = Color.primary.opacity(0.1),
    width: CGFloat = 60,
    height: CGFloat = 6,
    padding: EdgeInsets? = nil,
    cornerRadius: CGFloat = 16
  ) {
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.dividerColor = dividerColor
    self.handleColor = handleColor
    self.padding = padding
    self.size = CGSize(width: width, height: height)
  }

  /// The color of the handle background
  public var backgroundColor: Color

  /// The corner radius of the handle
  public var cornerRadius: CGFloat

  /// The color of the handle divider
  public var dividerColor: Color?

  /// The color of the handle
  public var handleColor: Color

  /// The padding to add around the handle
  public var padding: EdgeInsets?

  /// The size of the handle
  public var size: CGSize

  /// The standard bottom sheet handle style
  public static var standard: BottomSheetHandleStyle { BottomSheetHandleStyle() }
}
