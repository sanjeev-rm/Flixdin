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
    
    var body: some View {
        
        ZStack {
            ScrollView {
                // Fetch the messages from the Server and display here using SendersMessage and ReceiversMessage
                VStack(spacing: 16) {
                    SendersMessageView()
                    
                    ReceiversMessageView()
                }
                .padding()
                .padding(.bottom, 44)
            }
            
            VStack {
//                UserView
                
                Spacer()
                
                typeMessageView
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                UserView
            }
        }
        
    }
}

extension DirectMessagesView {
    
    //MARK: - UserView -- Top Header
    
    private var UserView : some View {
        
        HStack {
//            Button {
//                
//            } label: {
//                Image(systemName: "arrow.left")
//            }
            
            AsyncImage(url: URL(string: "https://picsum.photos/40/40"))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("John Doe")
                    .font(.callout.bold())
                Text("Actor")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom, 8)
        
        
        
//        HStack {
//            
//            Button{
//                // Go Back to Main Message View Screen.
//                presentationMode.wrappedValue.dismiss()
//                
//            } label: {
//                Image(systemName: "arrow.left")
//                    .foregroundColor(Color(flixColor: .olive))
//            }
//            
//            AsyncImage(url: URL(string: "https://picsum.photos/50/50")!)
//                .frame(width: 40, height: 40)
//                .cornerRadius(50)
//                .aspectRatio(contentMode: .fill)
//            
//            VStack (alignment: .leading){
//                Text("UserName")
//                    .font(.system(.subheadline, weight: .semibold))
//                Text(viewModel.isTyping ? "Typing...": "")
//                    .font(.system(.caption, weight: .light))
//            }
//            
//            Spacer()
//            
////            Button {
////                // Video Call
////            } label: {
////                Image(systemName: "video.fill")
////                    .foregroundColor(.white)
////                    .padding(8)
////                    .background(
////                        Rectangle()
////                            .foregroundColor(.clear)
////                            .background(Color(flixColor: .lightOlive))
////                            .cornerRadius(8)
////                    )
////                
////            }
////            
////            Button {
////                // Audio Call
////            } label: {
////                Image(systemName: "phone.fill")
////                    .foregroundColor(.white)
////                    .padding(8)
////                    .background(
////                        Rectangle()
////                            .foregroundColor(.clear)
////                            .background(Color(flixColor: .lightOlive))
////                            .cornerRadius(8)
////                    )
////            }
//            
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 16)
//        .background(
//            Rectangle()
//                .ignoresSafeArea()
//                .foregroundColor(.clear)
//                .background(Color(flixColor: .backgroundSecondary))
//                .cornerRadius(8)
//        )
//        .padding(.horizontal)
    }
    
    //MARK: - Footer View
    
    private var typeMessageView: some View {
        
        HStack (spacing: 8){
            
            Button {
                // Shows Image Picker
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            TextField("Write a Message", text: $viewModel.message)
                .font(.system(.body))
            
            Divider()
            
            Button {
                // Records the Audio
            } label: {
                Image(systemName: "mic.fill")
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            Button {
                // Sends a Message and stores in the viewModel.
                senderViewModel.senderMessage.append(viewModel.message)
                viewModel.message = ""
                
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .dynamicTypeSize(.accessibility1)
            }
        }
        .padding(8)
        .background(Color(.secondarySystemGroupedBackground))
        .frame(height: 52)
        .cornerRadius(8)
        .padding(11)
        .background(.ultraThinMaterial)
//        .frame(height: 32)
    }
    
}



struct DirectMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DirectMessagesView()
        }
    }
}
