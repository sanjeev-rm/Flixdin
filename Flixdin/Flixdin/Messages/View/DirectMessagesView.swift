//
//  DirectMessagesView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import SwiftUI

struct DirectMessagesView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: MessageViewViewModel = MessageViewViewModel()
    @ObservedObject var senderViewModel = SenderMessageViewViewModel()
    
    @ObservedObject var socketIOManager: SocketIOManager
    @ObservedObject var chatViewModel: ChatViewModel
    
    
    let receiverUserId: String

    @State private var messageText: String = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatViewModel.messages, id: \.self) { message in
                    MessageView(message: message, senderId: chatViewModel.getSenderId())
                }
            }
            messageInputField
        }
        .onAppear {
            socketIOManager.joinRoom(senderId: chatViewModel.getSenderId(), receiverId: receiverUserId)
            
            chatViewModel.fetchMessages(senderId: chatViewModel.getSenderId(), receiverId: receiverUserId)
            
        }
        .onDisappear {
            socketIOManager.leaveRoom(senderId: chatViewModel.getSenderId(), receiverId: receiverUserId)
        }
        .navigationTitle("Chat")
        .navigationBarItems(leading: Button("Back") {
            dismiss()
        })
    }
    
    var messageInputField: some View {
        HStack {
            TextField("Type a message...", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
            }
        }
        .padding()
    }
    
    private func sendMessage() {
        socketIOManager.sendMessage(senderId: chatViewModel.getSenderId(), receiverId: receiverUserId, message: messageText)
        messageText = ""
    }
}

struct MessageView: View {
    let message: ChatMessage
    let senderId: String

    var body: some View {
        HStack {
            if message.sender_id == senderId {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
        }
        .padding()
    }
}



struct DirectMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
          DirectMessagesView(socketIOManager: SocketIOManager(), chatViewModel: ChatViewModel(), receiverUserId: "")
        }
    }
}


