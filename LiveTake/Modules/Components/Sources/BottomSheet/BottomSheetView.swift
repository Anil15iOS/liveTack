//
//  BottomSheetView.swift
//
//
//  Created by Laura Guo on 1/22/22.
//

import Foundation
import SwiftUI

public enum BottomSheetViewMode {
  case expanded
  case collapsed

  mutating func next() {
    switch self {
    case .expanded:
      self = .collapsed
    case .collapsed:
      self = .expanded
    }
  }
}

public struct BottomSheetView<Content: View>: View {
  @Binding private var viewMode: BottomSheetViewMode

  private let content: Content
  private let maxHeight: BottomSheetHeight
  private let minHeight: BottomSheetHeight
  private let style: BottomSheetStyle

  @GestureState private var translation: CGFloat = 0

  public init(
    viewMode: Binding<BottomSheetViewMode>,
    maxHeight: BottomSheetHeight = .available,
    minHeight: BottomSheetHeight,
    style: BottomSheetStyle = .standard,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    self.maxHeight = maxHeight
    self.minHeight = minHeight
    self.style = style
    self._viewMode = viewMode
  }

  public var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        handle(in: geo)
        contentView(in: geo)
      }
      .frame(width: geo.size.width, height: maxHeight.height(in: geo), alignment: .top)
      .background(style.color)
      .cornerRadius(style.cornerRadius)
      .frame(height: geo.size.height + geo.safeAreaInsets.bottom, alignment: .bottom)
      .offset(y: max(offset(for: geo) + translation, 0))
      .animation(.interactiveSpring(), value: translation)
      .animation(.interactiveSpring(), value: viewMode)
    }
  }
}

// MARK: - Subviews

extension BottomSheetView {
  func contentView(in geometry: GeometryProxy) -> some View {
    content.padding(.bottom, geometry.safeAreaInsets.bottom)
  }

  func handle(in geometry: GeometryProxy) -> some View {
    BottomSheetHandleBar(style: style.handleStyle)
      .onTapGesture { viewMode.next() }
      .gesture(
        DragGesture()
          .updating($translation) { value, state, _ in
            state = value.translation.height
          }
          .onEnded { value in
            let translationHeight = abs(value.translation.height)
            let snapDistance = maxHeight.height(in: geometry) * style.snapRatio
            let shouldApply = translationHeight > snapDistance
            guard shouldApply else { return }
            viewMode = value.translation.height < 0 ? .expanded : .collapsed
          }
      )
  }
}

// MARK: - Helpers

extension BottomSheetHeight {
  func height(in geometry: GeometryProxy) -> CGFloat {
    let fullHeight = geometry.size.height + geometry.safeAreaInsets.bottom
    switch self {
    case .available:
      return fullHeight
    case .percentage(let ratio):
      return fullHeight * ratio
    case .points(let points):
      return points
    }
  }
}

extension BottomSheetView {
  func offset(for geometry: GeometryProxy) -> CGFloat {
    switch viewMode {
    case .expanded:
      return 0
    case .collapsed:
      return self.maxHeight.height(in: geometry) - self.minHeight.height(in: geometry)
    }
  }
}

// MARK: - Previews

struct BottomSheetView_Previews: PreviewProvider {
  struct Preview: View {
    @State private var viewMode: BottomSheetViewMode = .collapsed
    var body: some View {
      NavigationView {
        ZStack(alignment: .top) {
          VStack {
            Text("Content that's behind")
          }

          BottomSheetView(
            viewMode: $viewMode,
            maxHeight: .available,
            minHeight: .percentage(0.65)
          ) {
            List {
              ForEach(1...20, id: \.self) { index in
                Text("Item \(index)")
              }
            }
          }
          .navigationTitle("Navigation Title")
          .navigationBarTitleDisplayMode(.inline)
        }
      }
    }
  }

  static var previews: some View {
    Preview()
  }
}
