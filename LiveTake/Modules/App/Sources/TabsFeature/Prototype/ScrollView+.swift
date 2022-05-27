//
// Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import SwiftUI

struct ScrollView<Content: View>: View {
  let axis: Axis.Set
  let showsIndicators: Bool
  let onOffsetChanged: (CGFloat) -> Void
  let content: Content

  init(
    _ axis: Axis.Set = .vertical,
    showsIndicators: Bool = true,
    onOffsetChanged: @escaping (CGFloat) -> Void = { _ in },
    @ViewBuilder content: () -> Content
  ) {
    self.axis = axis
    self.showsIndicators = showsIndicators
    self.onOffsetChanged = onOffsetChanged
    self.content = content()
  }

  var body: some View {
    SwiftUI.ScrollView(axis, showsIndicators: showsIndicators) {
      offsetReader
      content
    }
    .coordinateSpace(name: "scrollView")
    .onPreferenceChange(OffsetPreferenceKey.self, perform: onOffsetChanged)
  }

  var offsetReader: some View {
    GeometryReader { geometry in
      Color.clear.preference(
        key: OffsetPreferenceKey.self,
        value: geometry.frame(in: .named("scrollView")).minY
      )
    }.frame(height: 0)
  }
}

private struct OffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGFloat = .zero
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}
