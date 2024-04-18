//
//  ExploreUsersListView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 14/03/24.
//

import SwiftUI

struct ExploreUsersListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var users: [User]
    @State var showProgress: Bool = false
    
    var title: String?
    var showDismissButton: Bool = false
    
    var body: some View {
        List {
            ForEach(users, id: \.id) { user in
                UserCardView(user: user)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
}

#Preview {
    ExploreUsersListView(users: .constant([]))
}
