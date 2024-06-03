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

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(spacing: 16) {

                        Divider()

                        if userSearchQuery.isEmpty {
                            ForEach(chatViewModel.chatList){ chat in
                                messagesListRow(chatResponse: chat)
                                
                            }
                        } else {
                            searchResultsView()
                        }
                    }
                }
            }

            .searchable(text: $userSearchQuery, placement: .navigationBarDrawer(displayMode: .automatic))
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

    @ViewBuilder
    private func searchResultsView() -> some View {
        if chatViewModel.searchedUser.isEmpty {
            Text("No users found.")
                .foregroundColor(.gray)
        } else {
            VStack(alignment: .leading) {
                ForEach(chatViewModel.searchedUser) { user in

                    NavigationLink {
                        DirectMessagesView(socketIOManager: socketManager, chatViewModel: chatViewModel, receiverUserId: user.id)
                            .navigationBarBackButtonHidden()
                    } label: {
                        searchedUserRow(user: user)
                    }
                }
            }
        }
    }

    // MARK: - SearchBar

    private var searchBarView: some View {
        SearchFieldView(backgroundColor: Color(flixColor: .backgroundSecondary), searchQuery: $userSearchQuery)
            .padding([.horizontal, .bottom])
            .cornerRadius(8)
            .opacity(0.8)
//        TextField("", text: $userSearchQuery)
    }

    // MARK: Searched User Row

    private func searchedUserRow(user: SearchedUserResponse) -> some View {
        HStack {
            AsyncImage(url: URL(string: user.profilepic ?? "")) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(user.fullname)
                    .foregroundColor(.black)

                    .fontWeight(.medium)
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - MessagesListView

    // Get all the users and display them here in the vstack
    private func messagesListRow(chatResponse: ChatResponse) -> some View {
        VStack {
            HStack {
                NavigationLink {
                    DirectMessagesView(socketIOManager: socketManager, chatViewModel: chatViewModel, receiverUserId: chatResponse.receiver_id)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 16) {
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(.init(flixColor: .lightOlive))
                            .frame(height: 50)
                            .overlay(
                                AsyncImage(url: URL(string: chatResponse.receiver_profilepic)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            )

                        VStack(alignment: .leading) {
                            Text("\(chatResponse.receiver_name)")
                                .foregroundColor(.primary)
                                .font(.system(size: 16, weight: .semibold))
                            
                            Text("\(chatResponse.latest_message_content)")
                                .font(.system(size: 12, weight: .light))
                            
//                            if Int(chatResponse.unread_count) != 0 {
//                                Text("\(chatResponse.unread_count) unread messages")
//                                    .foregroundColor(.primary)
//                                    .font(.system(size: 12))
//                                    .bold()
//                            } else {
//                                Text("\(chatResponse.latest_message_content)")
//                                    .font(.system(size: 12, weight: .light))
//                            }
                        }
                    }

                    Spacer()
                }

//                Spacer()

                if unreadMessagesCount != 0 {
                    Image(systemName: "circle.fill")
                        .foregroundColor(Color(flixColor: .backgroundTernary))
                        .frame(width: 10, height: 10)
                }
                Button {
                    // Opens the camera and sends the message.
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

struct AllMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMessagesView()
    }
}
