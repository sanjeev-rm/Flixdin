//
//  FollowButton.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct FollowButton: View {
    
    @Binding var otherUser: User
    @State var isCurrentUser: Bool = false
    @State var following: Bool = false
    
    var body: some View {
        Button {
            if following {
                ProfileViewModel.doAction(.unfollow, on: otherUser.id) { success in
                    if success { following = false }
                    updateUser()
                }
            } else {
                ProfileViewModel.doAction(.follow, on: otherUser.id) { success in
                    if success { following = true }
                    updateUser()
                }
            }
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 45)
                    .cornerRadius(8)
                    .foregroundColor(.clear)
                    .background(following ? Color(flixColor: .backgroundSecondary) : Color.accentColor)
                    .cornerRadius(8)
                Text(isCurrentUser ? "This is you" : (following ? "Unfollow" : "Follow"))
                    .font(.footnote.bold())
                    .foregroundColor(following ? .secondary : .white)
                    .padding(8)
            }
        }
        .disabled(isCurrentUser)
        .onAppear {
            guard let loggedInUserId = Storage.loggedInUserId else { return }
            
            // Check if current user is the other user
            if otherUser.id == loggedInUserId {
                isCurrentUser = true
            } else {
                // Check if the current user is following this other user
                following = otherUser.followers.contains { followerId in
                    followerId == loggedInUserId
                }
            }
        }
    }
}

extension FollowButton {
    
    private func updateUser() -> Void {
        ProfileAPIService().getUser(userId: otherUser.id) { result in
            switch result {
            case .success(let updatedUser):
                otherUser = User(responseBody: updatedUser)
            case .failure(_):
                print("DEBUG: Follow button")
            }
        }
    }
}

#Preview {
    FollowButton(otherUser: .constant(User()))
}
