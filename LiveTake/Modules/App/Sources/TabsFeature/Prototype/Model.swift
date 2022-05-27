//
// Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

struct Filter: Identifiable, Hashable {
  let id = UUID()
  let label: String
  var isEnabled: Bool

  var isFollowOnly: Bool {
    label == "FOLLOWING ONLY"
  }
}

extension Filter {
  static let all = [
    Filter(label: "NBA", isEnabled: true),
    Filter(label: "NFL", isEnabled: true),
    Filter(label: "UFC", isEnabled: true),
    Filter(label: "NHL", isEnabled: true),
    Filter(label: "FOLLOWING ONLY", isEnabled: false)
  ]
}

enum CellItem: Identifiable {
  case liveTake(LiveTake)
  case take(Take)

  var id: UUID {
    switch self {
    case let .liveTake(liveTake):
      return liveTake.id
    case let .take(take):
      return take.id
    }
  }
}

let emojis = [
  Emoji(icon: "🧠", votes: 658),
  Emoji(icon: "😤", votes: 142),
  Emoji(icon: "🤔", votes: 83),
  Emoji(icon: "🔥", votes: 72),
  Emoji(icon: "🗣", votes: 23)
]

enum LeagueType: String {
  case nba = "NBA"
  case ufc = "UFC"
  case nfl = "NFL"
  case nhl = "NHL"

  var icon: String {
    switch self {
    case .nba:
      return "ic-nba"
    case .ufc:
      return "ic-ufc"
    case .nfl:
      return "ic-nfl"
    case .nhl:
      return "ic-nhl"
    }
  }
}

enum StreamingType {
  case audio
  case video

  var icon: String {
    switch self {
    case .audio:
      return "ic-audio-room"
    case .video:
      return "ic-video-room"
    }
  }
}

struct Emoji: Identifiable {
  var id: String { icon }
  let icon: String
  let votes: Int
}

struct User {
  let name: String
  let isTalking: Bool
  let isVerified: Bool
  let isGoated: Bool

  init(name: String, isTalking: Bool = false, isVerified: Bool = false, isGoated: Bool = false) {
    self.name = name
    self.isTalking = isTalking
    self.isVerified = isVerified
    self.isGoated = isGoated
  }
}

struct Poll {
  let name: String
  let color: UInt
}

struct Take: Identifiable {
  let id = UUID()

  let daysAgo: String
  let leagueType: LeagueType

  let image: String?
  let user: User

  let title: String

  let leftPoll: Poll
  let rightPoll: Poll
}

struct LiveTake: Identifiable {
  let id = UUID()

  let daysAgo: String?
  let time: String
  let leagueType: LeagueType
  let streamingType: StreamingType
  let title: String

  let image: String?
  let secondImage: String?

  let leftUser: User
  let rightUser: User

  let leftPoll: Poll
  let rightPoll: Poll

  let bottomNumber: String

  var isLive: Bool {
    daysAgo == nil
  }
}
