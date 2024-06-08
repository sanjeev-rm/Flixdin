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
    @State var receiver: User?
    @State var gettingReceiver: Bool = false

    @State private var messageText: String = ""

    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatViewModel.messages) { message in
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
        .navigationTitle(receiver?.fullName ?? "Chat")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.accent)
                }
            }
        }
        .background(Color.flixColorBackgroundPrimary)
        .redacted(reason: gettingReceiver ? .placeholder : [])
        .onAppear {
            gettingReceiver = true
            ProfileAPIService().getUser(userId: receiverUserId) { result in
                DispatchQueue.main.async {
                    self.gettingReceiver = false
                    switch result {
                    case .success(let user):
                        self.receiver = User(responseBody: user)
                    case .failure(let failure):
                        print("DEBUG: Direct message couldn't get receiver - \(failure.localizedDescription)")
                    }
                }
            }
        }
    }
    
    var messageInputField: some View {
        HStack(alignment: .top) {
            TextField("Type a message...", text: $messageText, axis: .vertical)
                .multilineTextAlignment(.leading)
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .dynamicTypeSize(.accessibility1)
                    .foregroundStyle(.accent)
            }
        }
        .padding()
        .background(.thinMaterial)
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
