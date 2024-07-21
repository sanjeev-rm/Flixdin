//
//  ChatsListView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 21/07/24.
//

import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var socketManager: SocketIOManager
    @Environment(\.isSearching) var isSearching
    var body: some View {
        if isSearching {
            searchResultsView
        } else {
            chatsList
        }
    }
}

extension ChatsListView {
    private var searchResultsView: some View {
        ZStack {
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
                        Divider().padding(.leading)
                    }
                }
            }
        }
    }
    
    private var chatsList: some View {
        VStack {
            ForEach(chatViewModel.chatList){ chat in
                messagesListRow(chatResponse: chat)
                Divider()
                    .padding(.leading)
            }
        }
    }
    
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
    
    // Get all the users and display them here in the vstack
    private func messagesListRow(chatResponse: ChatResponse) -> some View {
        VStack {
            HStack {
                NavigationLink {
                    DirectMessagesView(socketIOManager: socketManager, chatViewModel: chatViewModel, receiverUserId: chatResponse.receiver_id)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 16) {
                        ProfilePictureView(imageUrl: URL(string: chatResponse.receiver_profilepic), borderColor: .clear, borderWidth: 0, imageWidth: 52, imageHeight: 52)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("\(chatResponse.receiver_name)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("\(chatResponse.latest_message_content)").font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                    
                    if Int(chatResponse.unread_count) != 0 {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.accent)
                            .dynamicTypeSize(.small)
                    }
    //                Button {
    //                    // Opens the camera and sends the message.
    //                } label: {
    //                    Image(systemName: "camera.fill")
    //                        .foregroundColor(.secondary)
    //                        .frame(width: 50, height: 50)
    //                }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }

            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    
}

#Preview {
    ChatsListView()
}
