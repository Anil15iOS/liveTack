//
//  TagView.swift
//  
//
//  Created by Laura Guo on 4/3/22.
//

import AssetsLibrary
import Foundation
import StyleGuide
import SwiftUI

public struct TagView: View {
  private let league: League
  @Binding private var selected: League?

  private var isSelected: Bool {
    (selected == league)
  }

  private var textColor: Color {
    return isSelected ? .gray : .white
  }

  public init(league: League, selected: Binding<League?>) {
    self.league = league
    self._selected = selected
  }

  public var body: some View {
    Button {
      if isSelected {
        selected = nil
      } else {
        selected = league
      }
    } label: {
      HStack(spacing: 4) {
        if isSelected {
          Image(systemName: "xmark").foregroundColor(.gray)
        }
        league.tag.icon
        Text(
          league.tag.text
        )
        .foregroundColor(textColor)
      }
      .padding(8)
      .frame(maxWidth: 96)
      .background {
        RoundedRectangle(cornerRadius: 8).fill(Color.LiveTake.secondaryBackgroundGray)
      }
    }
  }
}

public struct Tag {
  let icon: Image
  let text: String
}

public enum League: CaseIterable, Identifiable {
  public var id: Self { self }

  case nba
  case nfl
  case ufc
  case nhl
}

// TODO: Import real images
public extension League {
  var tag: Tag {
    switch self {
    case .nba:
      return Tag(icon: livetakeImage(name: "basketball"), text: "NBA")
    case .nfl:
      return Tag(icon: livetakeImage(name: "football"), text: "NFL")
    case .nhl:
      return Tag(icon: livetakeImage(name: "hockey-puck"), text: "NHL")
    case .ufc:
      return Tag(icon: livetakeImage(name: "fist-yellow"), text: "UFC")
    }
  }
}

// Previews
struct Tag_Previews: PreviewProvider {
  static var previews: some View {
    TagView(
      league: .nfl,
      selected: .constant(nil)
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
