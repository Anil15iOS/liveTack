//
//  AboutView.swift
//  
//
//  Created by Laura Guo on 3/6/22.
//

import ComposableArchitecture
import StyleGuide
import SwiftUI

public struct AboutView: View {
  @Environment(\.dismiss) private var dismiss

  let store: Store<AboutState, AboutAction>

  public init(store: Store<AboutState, AboutAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVStack(alignment: .leading) {
          Divider().background(.gray)
          VStack(alignment: .leading) {
            HStack(alignment: .top) {
              // Chevron Vstack
              VStack {
                HStack {
                  Button {
                    // TODO: Go to Data Policy
                    viewStore.send(.dataPolicyRowTapped)
                  } label: {
                    Text("Data Policy")
                      .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                      .foregroundColor(.white)
                  }
                }
                .padding()
                Divider().background(.gray)
              }
            }
            HStack(alignment: .top) {
              // Chevron Vstack
              VStack {
                HStack {
                  Button {
                    // TODO: Go to Terms of Use
                    viewStore.send(.termsOfUseRowTapped)
                  } label: {
                    Text("Terms of Use")
                      .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                      .foregroundColor(.white)
                  }
                }
                .padding()
                Divider().background(.gray)
              }
            }
          }
        }
      }
      .padding(.top)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(Color.LiveTake.primaryBackgroundColor)
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("")
      .navigationBarBackButtonHidden(true)
      .preferredColorScheme(.dark)
      .toolbar {
        ToolbarItemGroup(placement: .navigation) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .foregroundColor(Color.LiveTake.labelGray)
          }
        }
        ToolbarItemGroup(placement: .principal) {
          Text("About")
            .foregroundColor(.white)
            .bold()
        }
      }
      .alert(
        store.scope(state: \.alert, action: AboutAction.alert),
        dismiss: .dismiss
      )
    }
  }
}

// MARK: - Previews

struct About_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AboutView(
        store: Store(
          initialState: .init(),
          reducer: .empty,
          environment: ()
        )
      )
    }
  }
}
