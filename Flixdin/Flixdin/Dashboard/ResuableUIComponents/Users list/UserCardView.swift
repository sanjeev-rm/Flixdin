//
//  UsersListCardView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct UserCardView: View {
    
    @State var user: User
    @State var profilepicture: Image?
    
    var body: some View {
        NavigationLink {
            OtherUserProfileView(user: user)
        } label: {
            HStack(spacing: 16) {
                FlixdinImageView(urlString: user.profilePic ?? "", contentImage: $profilepicture)
                    .frame(width: 44)
                    .clipShape(
                        Circle()
                    )
                
                VStack(alignment: .leading) {
                    Text(user.fullName)
                        .font(.callout.bold())
                    Text(user.domain)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    UserCardView(user: User())
}
