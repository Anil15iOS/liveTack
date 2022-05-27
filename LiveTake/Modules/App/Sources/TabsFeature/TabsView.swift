import ComposableArchitecture
import ComposablePresentation
import ComposeTakesFeature
import MyProfileFeature
import StyleGuide
import SwiftUI

public struct TabsView: View {
  let store: Store<TabsState, TabsAction>

  @State var showFilterAndButtons = true

  public init(store: Store<TabsState, TabsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      TabView(selection: viewStore.binding(\.$selectedTab).animation()) {
        ForEach(Tab.allCases, id: \.self) { tab in
          Group {
            switch tab {
            case .liveTake:
              ContentView(viewMode: .livetakes, showFilterAndButtons: $showFilterAndButtons)
            case .takes:
              ContentView(viewMode: .takes, showFilterAndButtons: $showFilterAndButtons)
                .preferredColorScheme(.light)
            case .profile:
              NavigationView {
                MyProfileView(
                  store: store.scope(
                    state: \.profileState,
                    action: TabsAction.profile
                  )
                )
              }
            }
          }
          .tag(tab)
        }
      }
      .safeAreaInset(edge: .bottom) {
        VStack {
          if viewStore.selectedTab != .profile && showFilterAndButtons {
            BottomButtons(store: store)
              .transition(.move(edge: .bottom).combined(with: .opacity))
              .zIndex(0)
          }

          HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
              Button {
                viewStore.send(.binding(.set(\.$selectedTab, tab)))
              } label: {
                VStack {
                  Image(
                    viewStore.selectedTab == tab
                    ? tab.imageString.selected
                    : tab.imageString.unselected,
                    bundle: .module
                  )
                  .font(.largeTitle)
                  .foregroundColor(viewStore.selectedTab == tab ? .white : .LiveTake.unselectedTab )
                  .padding()
                }
              }
              .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
          }
        }
        .background(Color.LiveTake.primaryBackgroundColor)
        .animation(.default, value: viewStore.selectedTab)
        .zIndex(1)
      }
    }
  }
}

extension TabsView {
  struct BottomButtons: View {
    let store: Store<TabsState, TabsAction>

    var body: some View {
      WithViewStore(store) { viewStore in
        HStack {
          Button {
            viewStore.send(.primaryCTAButtonTapped)
          } label: {
            Text(viewStore.selectedTab == .liveTake ? "Start LiveTake" : "Drop Take")
              .bold()
              .frame(maxWidth: .infinity)
              .frame(height: 36)
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.createButtonTint)
          .fullScreenCover(
            store.scope(state: \.composeTake, action: TabsAction.composeTake),
            mapState: replayNonNil(),
            onDismiss: { viewStore.send(.dismissedComposeTake) },
            content: ComposeTakeView.init(store:)
          )

          if viewStore.selectedTab == .liveTake {
            Button {
            } label: {
              Text("Challenges")
                .bold()
                .frame(maxWidth: .infinity)
                .frame(height: 36)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .tint(Color.LiveTake.topBarButtonTint)
            .transition(.opacity)
            .zIndex(-1)
          }
        }
        .padding([.horizontal, .top])
        .animation(.easeInOut, value: viewStore.selectedTab)
      }
    }
  }
}

extension Tab {
  var imageString: (selected: String, unselected: String) {
    switch self {
    case .takes:
      return (selected: "ic-tab-take-selected", unselected: "ic-tab-take-unselected")
    case .liveTake:
      return (selected: "ic-tab-livetake-selected", unselected: "ic-tab-livetake-unselected")
    case .profile:
      return (selected: "ic-tab-profile", unselected: "ic-tab-profile")
    }
  }
}

struct TabsView_Previews: PreviewProvider {
  static var previews: some View {
    TabsView(
      store: .init(
        initialState: .init(),
        reducer: tabsReducer,
        environment: .noop
      )
    )
  }
}
