//
//  ComposeTakeView.swift
//  
//
//  Created by Laura Guo on 4/3/22.
//

import ComposableArchitecture
import ComposablePresentation
import StyleGuide
import SwiftUI

public struct ComposeTakeView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<ComposeTakeState, ComposeTakeAction>
  @FocusState private var focusedField: ComposeTakeState.Field?

  public init(store: Store<ComposeTakeState, ComposeTakeAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        HStack {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .frame(width: 28, height: 28)
              .foregroundColor(Color.LiveTake.topBarButtonTint)
          }
          .buttonStyle(.plain)

          Spacer()
          Button {
          } label: {
            Text("Drop")
              .font(.body.weight(.semibold))
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.createButtonTint)
        }
        .padding([.bottom, .horizontal])
        .background(Color.LiveTake.navbarBackground.edgesIgnoringSafeArea(.top))
        VStack(spacing: 16) {
          if let selectedLeague = viewStore.selectedLeague {
            // Only show selected league if there is one
            HStack {
              Spacer()
              TagView(league: selectedLeague, selected: viewStore.binding(\.$selectedLeague).animation())
                .id(selectedLeague)
                .transition(.slide)
            }
          } else {
            HStack(spacing: 16) {
              // Show all leagues if none is currently selected
              ForEach(League.allCases) { league in
                TagView(league: league, selected: viewStore.binding(\.$selectedLeague).animation())
                  .id(league)
                  .transition(.slide)
              }
            }
          }

          HStack {
            Circle()
              .stroke()
              .frame(width: 36, height: 36)
            TextField("", text: .constant(""), prompt: Text("What’s your take?"))
              .textCase(.uppercase)
              .autocapitalization(.allCharacters)
              .font(.custom("DIN Condensed Bold", size: 21))
          }
          .padding(.vertical)

          PollEditorView(leftPollItem: viewStore.binding(\.$leftPollItem), rightPollItem: viewStore.binding(\.$rightPollItem))

          Button {
          } label: {
            Label("Add Photo", systemImage: "photo")
              .foregroundColor(Color.hex(0xFCFC7B))
              .padding(.horizontal)
          }
          .buttonStyle(.borderedProminent)
          .buttonBorderShape(.capsule)
          .tint(Color.LiveTake.topBarButtonTint)

          Spacer()
        }
        .animation(.default, value: viewStore.selectedLeague)
        .padding()
      }
      .background(Color.LiveTake.primaryBackgroundColor)
      .preferredColorScheme(.dark)
    }
  }
}

// MARK: - Previews

struct ComposeTakeView_Previews: PreviewProvider {
  static var previews: some View {
    ComposeTakeView(
      store: Store(
        initialState: .init(selectedLeague: .nfl),
        reducer: composeTakeReducer,
        environment: .init()
      )
    )
  }
}
