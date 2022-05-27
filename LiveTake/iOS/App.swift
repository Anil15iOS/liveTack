import App
import AppEnvironmentLive
import ComposableArchitecture
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
  let store = Store(
    initialState: .init(),
    reducer: appReducer,
    environment: .live
  )

  lazy var viewStore = ViewStore(
    store.scope { _ in () },
    removeDuplicates: ==
  )

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    viewStore.send(.appDelegate(.didFinishLaunching))
    return true
  }
}

@main
struct LiveTakeApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      AppView(store: appDelegate.store)
    }
    .onChange(of: scenePhase) {
      appDelegate.viewStore.send(.didChangeScenePhase($0))
    }
  }
}
