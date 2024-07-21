//
//  AllMessagesView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import SwiftUI

struct AllMessagesView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State var isTyping: Bool = false
    @State var lastMessage: String = ""
    @State var unreadMessagesCount: Int = 1
    @State var userSearchQuery: String = ""

    @StateObject var socketManager = SocketIOManager()
    @StateObject var chatViewModel = ChatViewModel()
    
    @Environment(\.dismissSearch) var dismissSearch

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(spacing: 16) {

                        Divider()
                        
                        ChatsListView()
                            .environmentObject(chatViewModel)
                            .environmentObject(socketManager)
                    }
                }
            }
            .searchable(text: $chatViewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .automatic))
            .foregroundColor(.accent)
            .navigationBarItems(leading: backButtonAndTitle)
            .onSubmit(of: .search) {
                Task {
                    await chatViewModel.getSearchedUser()
                }
            }
            .onAppear(perform: {
                socketManager.connect()
                Task {
                    await chatViewModel.getChatList()
                }

            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
        }
    }
}

extension AllMessagesView {
    // MARK: - Back Button and Title

    private var backButtonAndTitle: some View {
        HStack(spacing: 16) {
            Button {
                // Dismiss the message view and go back to the home view
                socketManager.disconnect()
                homeViewModel.showMessages = false
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(flixColor: .lightOlive))
            }

            Text("Messages")
                .font(.system(.title, weight: .bold))
                .foregroundColor(Color(flixColor: .lightOlive))
        }
    }

    // MARK: - Searched User Row

    private func searchedUserRow(user: SearchedUserResponse) -> some View {
        HStack {
            
            ProfilePictureView(imageUrl: URL(string: user.profilepic ?? ""), borderColor: .clear, borderWidth: 0, imageWidth: 52, imageHeight: 52)

            VStack(alignment: .leading, spacing: 0) {
                Text(user.fullname)
                    .font(.headline)
                    .foregroundColor(.primary)

                    .fontWeight(.medium)
                Text("@\(user.username)")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct AllMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMessagesView()
    }
}
