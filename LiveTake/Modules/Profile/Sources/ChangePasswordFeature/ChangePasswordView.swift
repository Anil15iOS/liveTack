//
//  ChangePasswordView.swift
//  
//
//  Created by Laura Guo on 3/6/22.
//

import ComposableArchitecture
import StyleGuide
import SwiftUI

public struct ChangePasswordView: View {
  @Environment(\.dismiss) private var dismiss
  let store: Store<ChangePasswordState, ChangePasswordAction>

  public init(store: Store<ChangePasswordState, ChangePasswordAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView {
        LazyVStack(alignment: .leading, spacing: 36) {
          Divider().background(.gray)
          VStack(alignment: .leading, spacing: 36) {
            VStack(alignment: .leading) {
              Text("Enter Current Password")
                .foregroundColor(.white)
                .font(.body)

              SecureField("", text: viewStore.binding(\.$currentPassword))
                .tint(.white)
                .frame(height: 48)
                .foregroundColor(.white)
                .font(.body.weight(.light))
                .padding(.horizontal, 8)
                .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
            }

            VStack(alignment: .leading) {
              Text("Enter New Password")
                .foregroundColor(.white)
                .font(.body)

              SecureField("", text: viewStore.binding(\.$newPassword))
                .tint(.white)
                .frame(height: 48)
                .foregroundColor(.white)
                .font(.body.weight(.light))
                .padding(.horizontal)
                .background(Color.LiveTake.secondaryBackgroundGray.cornerRadius(8))
            }
          }
          .padding()
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
        ToolbarItemGroup(placement: .primaryAction) {
          Button {
          } label: {
            Text("Save")
              .foregroundColor(.gray)
          }
        }
        ToolbarItemGroup(placement: .principal) {
          Text("Change Password")
            .foregroundColor(.white)
            .bold()
            .fixedSize()
        }
      }
    }
  }
}

// MARK: - Previews

struct ChangePasswordView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ChangePasswordView(
        store: Store(
          initialState: .init(),
          reducer: changePasswordReducer,
          environment: .noop
        )
      )
    }
  }
}
