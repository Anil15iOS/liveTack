//
//  ProfileFeedView.swift
//  
//
//  Created by Laura Guo on 3/4/22.
//

import Foundation
import StyleGuide
import SwiftUI

struct ProfileFeedView: View {
  public var body: some View {
    List(1...20, id: \.self) { _ in
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.LiveTake.secondaryBackgroundGray)
        .frame(height: 160)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
  }
}


struct ProfileFeedView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileFeedView()
  }
}
