//
//  ShareContentView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 08/08/23.
//

import SwiftUI

struct ShareContentView: View {
    var body: some View {
        VStack {
            searchField
            
            addToClick
            
            SendToView
            
            otherSocialMediaView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(flixColor: .backgroundSecondary)
        )
    }
    
}

extension ShareContentView {
    
    //MARK: - Search Field.
    
    private var searchField: some View {
//        SearchFieldView(backgroundColor: Color(.white))
//            .padding()
        Text("Search Field")
    }
    
    //MARK: - Add to Clicks.
    
    private var addToClick: some View {
        Button {
            // Add the Post / Connection Call to the Clicks.
        } label: {
            
            HStack (spacing: 16) {
                
                ProfilePictureView(imageUrl: URL(string: "https://picsum.photos/262/250")!, borderColor: Color(flixColor: .lightOlive), borderWidth: 2, imageWidth: 35, imageHeight: 35)
                
                VStack (alignment: .leading , spacing: 4){
                    Text("Add to your Click")
                        .foregroundColor(.primary)
                    
                    Divider()
                }

                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    //MARK: - FriendsList.
    
    private var SendToView : some View {
        // Get the data from the Firebase and display them here
        ScrollView {
            
            VStack (alignment: .leading, spacing: 16) {
                
                Text("Suggested")
                
                Divider()
                
                ForEach(1...10, id: \.self) { i in
                    HStack {
                        ProfilePictureView(imageUrl: URL(string: "https://picsum.photos/262/250")!, borderColor: Color(flixColor: .lightOlive), borderWidth: 2, imageWidth: 35, imageHeight: 35)
                        
                        VStack (alignment: .leading){
                            Text("Username")
                            Text("Domain")
                                .font(.system(.caption))
                        }
                        
                        Spacer()
                        
                        Button {
                            // Send to them.
                        } label: {
                            Text("Send")
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(
                                    Color(flixColor: .backgroundTernary)
                                        .cornerRadius(8)
                                )
                        }

                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Other Social Media
    
    private var otherSocialMediaView: some View {
        VStack {
            Rectangle()
                .fill(Color(flixColor: .lightOlive))
                .frame(height: 2)
                .padding(.bottom)
            
            HStack (spacing: 32){
                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Button {
                    // Share To
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ShareContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShareContentView()
    }
}
