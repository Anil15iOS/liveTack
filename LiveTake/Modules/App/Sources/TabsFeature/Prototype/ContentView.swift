import StyleGuide
import SwiftUI

struct ContentView: View {
  enum ViewMode {
    case takes
    case livetakes
  }

  @State var offset: CGFloat = .zero
  @State var lastOffset: CGFloat = .zero

  @Binding var showFilterAndButtons: Bool

  let cells: [CellItem]
  let viewMode: ViewMode

  init(viewMode: ViewMode, showFilterAndButtons: Binding<Bool>) {
    self.viewMode = viewMode
    self._showFilterAndButtons = showFilterAndButtons
    switch viewMode {
    case .takes:
      self.cells = takesCells.map(CellItem.take)
    case .livetakes:
      self.cells = liveTakeCells.map(CellItem.liveTake)
    }
  }


  var body: some View {
    ScrollView { scrollOffset in
      DispatchQueue.main.async {
        if scrollOffset < offset {
          if offset < 0 && -scrollOffset > (lastOffset + 50) {
            withAnimation(.easeInOut.speed(1.5)) {
              showFilterAndButtons = false
            }
            lastOffset = -offset
          }
        } else if scrollOffset > offset && -scrollOffset <= (lastOffset - 50) {
          withAnimation(.easeInOut.speed(1.5)) {
            showFilterAndButtons = true
          }
          lastOffset = -offset
        }

        offset = scrollOffset
      }
    } content: {
      LazyVStack(spacing: 16) {
        ForEach(cells) { cell in
          switch cell {
          case .liveTake(let livetake):
            LiveTakeCell(liveTake: livetake)
          case .take(let take):
            TakeCell(take: take)
          }
        }
      }
      .padding(.horizontal, 8)
    }
    .safeAreaInset(edge: .top) {
      FilterBar(show: $showFilterAndButtons)
        .background(viewMode == .livetakes ?  Color.white : Color.LiveTake.takesTabBackground)
    }
    .background(viewMode == .livetakes ?  Color.white : Color.LiveTake.takesTabBackground)
//    .safeAreaInset(edge: .bottom) {
//      BottomBar(show: $showFilterAndTab)
//    }
  }
}

struct FilterBar: View {
  @State private var isFollowingOnlyActive = false
  @State private var filters: [Filter] = Filter.all

  @Binding var show: Bool

  var body: some View {
    Group {
      ScrollViewReader { scrollview in
        ScrollView(.horizontal, showsIndicators: false) {
          if show {
            HStack(spacing: 4) {
              Image("ic-search", bundle: .module)
                .font(.title)
                .padding(4)
              ForEach(filters) { filter in
                Button {
                  if filter.isFollowOnly, let index = filters.firstIndex(where: { $0.isFollowOnly }) {
                    withAnimation(.easeInOut) {
                      isFollowingOnlyActive.toggle()
                      if isFollowingOnlyActive {
                        filters[index].isEnabled = true
                        filters.move(fromOffsets: IndexSet(integer: index), toOffset: filters.startIndex)
                      } else {
                        filters[index].isEnabled = false
                        filters.move(fromOffsets: IndexSet(integer: index), toOffset: filters.endIndex)
                      }
                      scrollview.scrollTo(filter.id, anchor: .top)
                    }
                  }
                } label: {
                  Text(filter.label)
                    .font(.LiveTake.body)
                    .foregroundColor(.white)
                    .padding(4)
                  Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(filter.isFollowOnly && !isFollowingOnlyActive ? Color.gray : Color.hex(0x707070))
                    .frame(width: 10, height: 10)
                }
                .tint(filter.isEnabled ? .LiveTake.filtersBackground : .LiveTake.filtersBackground.opacity(0.5))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .id(filter.id)
                .transition(.slide)
              }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            //            .transition(.move(edge: .top).combined(with: .opacity).animation(.easeInOut))
          }
        }
      }
    }
  }
}

struct BottomBar: View {
  @Binding var show: Bool
  var body: some View {
    VStack(spacing: 16) {
      if show {
        HStack(spacing: 20) {
          Button {
          } label: {
            Text("Start LiveTake")
              .frame(maxWidth: .infinity)
            //                        .transition(.move(edge: .bottom).combined(with: .opacity))
          }
          .foregroundColor(.white)
          .tint(.LiveTake.topBarButtonTint)
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
          .frame(height: 48)
          .transition(.move(edge: .bottom).combined(with: .opacity))


          Button {
          } label: {
            Text("Challenges")
              .frame(maxWidth: .infinity)
            //                        .transition(.move(edge: .bottom).combined(with: .opacity))
          }
          .foregroundColor(.white)
          .tint(.LiveTake.topBarButtonTint)
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .controlSize(.large)
          .frame(height: 48)
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .frame(maxWidth: .infinity)
        //            .transition(.move(edge: .bottom).combined(with: .opacity).animation(.easeInOut))
      }

      HStack {
        // TODO: Make them buttons
        Spacer()
        Image("ic-tab-livetake-unselected", bundle: .module)
        Spacer()
        Image("ic-tab-take-selected", bundle: .module)
        Spacer()
        Image("brettokamoto", bundle: .module)
          .resizable()
          .frame(width: 30, height: 30)
          .foregroundColor(.white)
          .padding(3)
          .background(Color.LiveTake.secondaryBackgroundGray)
          .clipShape(Circle())
        Spacer()
      }
    }
    .padding([.top, .horizontal])
    .background(Color.LiveTake.primaryBackgroundColor.ignoresSafeArea(edges: .bottom))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewMode: .takes, showFilterAndButtons: .constant(true))
    ContentView(viewMode: .livetakes, showFilterAndButtons: .constant(true))
  }
}

struct Avatar: View {
  let user: User
  let isLiveTake: Bool

  var body: some View {
    VStack(spacing: 4) {
      if isLiveTake {
        Image(user.name, bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 40, height: 40)
          .padding(8)
          .overlay(Circle().strokeBorder(user.isTalking ? Color.hex(0xCE083E): Color.gray, lineWidth: 2))
          .alignmentGuide(VerticalAlignment.centerVsAndImage) { dimensions in dimensions[VerticalAlignment.center] }
      } else {
        Image(user.name, bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 40, height: 40)
      }

      HStack(spacing: 4) {
        Text(user.name)
          .foregroundColor(.white)
          .font(.LiveTake.body)
        if user.isVerified {
          Image("ic-verified-badge", bundle: .module)
            .resizable()
            .frame(width: 20, height: 20)
        }
        if user.isGoated {
          Image("ic-goat-badge", bundle: .module)
            .resizable()
            .frame(width: 20, height: 20)
        }
      }

      if isLiveTake {
        QuoteDivider()
          .padding(.horizontal, 4)
      }
    }
  }
}

struct QuoteDivider: View {
  var body: some View {
    HStack {
      Rectangle().fill(.gray)
        .frame(height: 2)
      Image("ic-quotes", bundle: .module)
      Rectangle().fill(.gray)
        .frame(height: 2)
    }
  }
}

extension VerticalAlignment {
  struct CenterVsAndImage: AlignmentID {
    static func defaultValue(in dimensions: ViewDimensions) -> CGFloat {
      dimensions[VerticalAlignment.center]
    }
  }

  static let centerVsAndImage = VerticalAlignment(CenterVsAndImage.self)
}

struct PollButton: View {
  let leftPoll: Poll
  let rightPoll: Poll

  var body: some View {
    HStack(spacing: 0) {
      Button(leftPoll.name) { }
      .font(.custom("DIN Condensed Bold", size: 17))
      .padding(.horizontal)
      .lineLimit(2)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.LiveTake.topBarButtonTint)
      .foregroundColor(Color.hex(leftPoll.color))

      Rectangle()
        .foregroundColor(Color.LiveTake.labelGray)
        .frame(width: 2)

      Button(rightPoll.name) { }
      .font(.custom("DIN Condensed Bold", size: 17))
      .padding(.horizontal)
      .lineLimit(2)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.LiveTake.topBarButtonTint)
      .foregroundColor(Color.hex(rightPoll.color))
    }
    .frame(height: 52)
    .clipShape(Capsule())
  }
}
