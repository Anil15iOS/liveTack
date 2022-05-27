import ComposableArchitecture
import Foundation

public struct NotificationSettingsState: Equatable {
  @BindableState var enableNotifications: Bool

  @BindableState var enableLivetakesChallengesAndStartTimes: Bool
  @BindableState var enableNewFollowers: Bool
  @BindableState var enableFollowing: Bool
  @BindableState var enableEarnedRings: Bool

  public init(
    enableNotifications: Bool = true,
    enableLivetakesChallengesAndStartTimes: Bool = true,
    enableNewFollowers: Bool = true,
    enableFollowing: Bool = true,
    enableEarnedRings: Bool = true
  ) {
    self.enableNotifications = enableNotifications
    self.enableLivetakesChallengesAndStartTimes = enableLivetakesChallengesAndStartTimes
    self.enableNewFollowers = enableNewFollowers
    self.enableFollowing = enableFollowing
    self.enableEarnedRings = enableEarnedRings
  }
}

public enum NotificationSettingsAction: BindableAction, Equatable {
  case binding(BindingAction<NotificationSettingsState>)
  case didAppear
}

public struct NotificationSettingsEnvironment {
  public var mainQueue: AnySchedulerOf<DispatchQueue>

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
}

extension NotificationSettingsEnvironment {
  static let noop = Self(
    mainQueue: .immediate
  )
}

public let notificationSettingsReducer = Reducer<
  NotificationSettingsState, NotificationSettingsAction, NotificationSettingsEnvironment
> { state, action, environment in
  switch action {
  case .binding(\.$enableNotifications):
    return .merge(
      Effect(value: .binding(.set(\.$enableLivetakesChallengesAndStartTimes, state.enableNotifications))),
      Effect(value: .binding(.set(\.$enableNewFollowers, state.enableNotifications))),
      Effect(value: .binding(.set(\.$enableFollowing, state.enableNotifications))),
      Effect(value: .binding(.set(\.$enableEarnedRings, state.enableNotifications)))
    )
    .receive(on: environment.mainQueue.animation())
    .eraseToEffect()
  case .binding:
    return .none
  case .didAppear:
    return .none
  }
}
.binding()
