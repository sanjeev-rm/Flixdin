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
            VStack (alignment: .leading) {
                
                backButtonAndTitle
                
                searchBarView
                
                ScrollView {
                    VStack(spacing: 16) {
                        
//                        onlineUsersView

//                        messageTypeView
                        
                        Divider()
                        
                        messagesListRow()
                    }
                }
            }
            .onAppear(perform: {
                Task{
                    await chatViewModel.getChats()
                }
                socketManager.connect()
            })
            .onDisappear(perform: {
                socketManager.disconnect()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
        }
    }
}

extension AllMessagesView {
    
    //MARK: - Back Button and Title
    
    private var backButtonAndTitle: some View {
        
        HStack(spacing: 16) {
            
            Button{
                // Dismiss the message view and go back to the home view
                homeViewModel.showMessages = false
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color(flixColor: .lightOlive))
            }
            
            Text("Messages")
                .font(.system(.title, weight: .bold))
                .foregroundColor(Color(flixColor: .lightOlive))
        }
        .padding(.horizontal)
    }
    
    //MARK: - SearchBar
    
    private var searchBarView: some View {
        SearchFieldView(backgroundColor: Color(flixColor: .backgroundSecondary), searchQuery: $userSearchQuery)
            .padding([.horizontal, .bottom])
            .cornerRadius(8)
            .opacity(0.8)
//        TextField("", text: $userSearchQuery)
    }
    
    //MARK: - MessagesListView
    // Get all the users and display them here in the vstack
    private func messagesListRow() -> some View {
        VStack{
            HStack {
                NavigationLink {
                    DirectMessagesView()
                        .navigationBarBackButtonHidden()
                } label : {
                    HStack(spacing: 16) {
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(.init(flixColor: .lightOlive))
                            .frame(height: 50)
                            .overlay (
                                GeometryReader { proxy in
                                    AsyncImage(url: URL(string: "https://picsum.photos/50/50")!)
                                        .frame(width: proxy.size.width, height: proxy.size.height)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                            }
                          )
                        
                        VStack (alignment: .leading){
                            Text("John Doe")
                                .foregroundColor(.primary)
                                .font(.system(size: 16, weight: .semibold))
                            if unreadMessagesCount != 0 {
                                Text("\(unreadMessagesCount) unread messages")
                                    .foregroundColor(.primary)
                                    .font(.system(size: 12))
                                    .bold()
                            } else {
                                Text(isTyping ? "Typing...": "\(lastMessage)")
                                    .font(.system(size: 12, weight: .light))
                            }
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
    
    //MARK: - Online Users
    
    private var onlineUsersView : some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack (spacing: 16){
                
                // Get the data from the database and count the persons that are online and show them here.
                ForEach(1...10, id: \.self) { i in
                    ZStack (alignment: .topTrailing){
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(lineWidth: 2)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(flixColor: .lightOlive))
                        )
                        
                        AsyncImage(url: URL(string: "https://picsum.photos/50/50")!)
                            .scaledToFit()
                            .cornerRadius(50)
                            .aspectRatio(contentMode: .fill)
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 15, height: 15)
                            
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 10, height: 10)
                        }
                        .offset(x:6, y:0)
                    }
                }
            }
            .padding(.vertical, 4)
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
        }
    }
    
    //MARK: - Message Type View.
    
    private var messageTypeView: some View {
        HStack {
            Spacer()
            
            Button {
                // Primary Tab
            } label: {
                Text("Primary")
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Color(flixColor: .backgroundSecondary))
                    )
            }
            
            Spacer()
            
            Button {
                // General Tab
            } label: {
                Text("General")
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Color(flixColor: .backgroundSecondary))
                    )
            }
            
            Spacer()

            Button {
                // Requests Tab
            } label: {
                Text("Requests")
                    .foregroundColor(.primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Rectangle()
                            .cornerRadius(8)
                            .foregroundColor(Color(flixColor: .backgroundSecondary))
                    )
            }
            
            Spacer()
        }
    }
    

}
struct AllMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMessagesView()
    }
}
