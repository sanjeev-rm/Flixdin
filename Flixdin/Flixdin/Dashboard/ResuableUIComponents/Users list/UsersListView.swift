//
//  UsersListView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct UsersListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var list: [String]
    @State var users: [User] = []
    @State var showProgress: Bool = false
    
    var title: String?
    var showDismissButton: Bool = false
    
    var body: some View {
        NavigationStack {
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
            .onAppear {
                if !list.isEmpty {
//                    showProgress = true
                    self.users = []
                    for userId in list {
                        ProfileAPIService().getUser(userId: userId) { result in
                            DispatchQueue.main.async {
//                                self.showProgress = false
                                switch result {
                                case .success(let userResponseBody):
                                    self.users.append(User(responseBody: userResponseBody))
                                case .failure(let failure):
                                    print("DEBUG: Users list - \(failure)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showDismissButton {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    UsersListView(list: ["a", "a", "a", "a", "a"], title: "Likes", showDismissButton: true)
}
