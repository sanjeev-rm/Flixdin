//
//  FlixCell.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 25/04/2024.
//

import AVKit
import SwiftUI

struct FlixCell: View {
    let flix: FlixResponse
    var player: AVPlayer?

    @State var showComments: Bool = false
    
    @StateObject var flixCellViewModel = FlixCellViewModel()
    
    @State var likeStatus: Bool = false

    init(flix: FlixResponse) {
        self.flix = flix

        if let url = URL(string: flix.flixurl) {
            player = AVPlayer(url: url)
        } else {
            print("error getting url")
            player = nil
        }
    }
    
//    @State var showMore: Bool = false

    var body: some View {
        ZStack {
            if let url = URL(string: flix.flixurl) {
                CustomFlixPlayer(player: player ?? AVPlayer(url: URL(string: "")!))
                    .ignoresSafeArea()
            } else {
                Rectangle()
                    .foregroundColor(.blue)
                    .overlay {
                        Text("Error getting video")
                    }
            }

            VStack {
                Spacer()

                HStack(alignment: .bottom) {
                    userDetails()

                    Spacer()

                    actions()
                }
            }
            .padding()
        }
        .onAppear(perform: {
            player?.play()
            
        })
        .sheet(isPresented: $showComments, content: {
            CommentsView()
        })
    }
}

extension FlixCell {
    // MARK: user details

    private func userDetails() -> some View {
        VStack(alignment: .leading) {
            profileUsernameFollowButton
            
            Text(flix.caption)
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.semibold)
        }
    }

    // MARK: actions

    private func actions() -> some View {
        
        VStack(spacing: 28) {
            
            Button(action: {
                
                if likeStatus{
                    Task{
                        await flixCellViewModel.dislikeFlix(flixid: flix.flixid)
                        likeStatus.toggle()
                    }
                } else{
                    Task{
                        await flixCellViewModel.likeFlix(flixid: flix.flixid)
                        likeStatus.toggle()
                    }
                }
                
               
            }, label: {
                VStack {
                    Image(systemName: "heart.fill")
                        .dynamicTypeSize(.accessibility1)
                        .foregroundColor(likeStatus ? Color.red : .white)
                    Text("\(flix.likes.count)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .bold()
                }
            })
            
            flickActionButton(imageSystemName: "message.fill", text: "\(flix.comments.count)") {
                showComments.toggle()
            }
            
            flickActionButton(imageSystemName: "bookmark.fill") {
                // save flick
            }
            
            flickActionButton(imageSystemName: "paperplane.fill") {
                // share flick
            }
        }
    }
}

extension FlixCell {
//    private var userInfoAndDescription: some View {
//        VStack(alignment: .leading) {
//            profileUsernameFollowButton
//            
//            if showMore {
//                
//                ScrollView(.vertical, showsIndicators: false) {
//                    Text(flix.caption)
//                        .foregroundColor(.white)
//                        .font(.callout)
//                }
//                .frame(height: 150)
//                
//            } else {
//                
//                Button {
//                    // Show more of the caption
//                    withAnimation {
//                        showMore.toggle()
//                    }
//                } label: {
//                    HStack {
//                        Text(flix.caption)
//                            .foregroundColor(.white)
//                            .font(.callout)
//                            .fontWeight(.semibold)
//                            .multilineTextAlignment(.leading)
//                        
//                        Text("more")
//                            .font(.callout.bold())
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .disabled(flix.caption.count < 20)
//            }
//        }
//    }
    
    private var profileUsernameFollowButton: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 44, height: 44)
                .foregroundColor(.gray)
                .background(
                    Color.white
                        .cornerRadius(32)
                )
            Text("Username")
                .font(.headline)
                .foregroundColor(.white)
            Button {
                // Follow the user
            } label: {
                Text("Follow")
                    .font(.caption.bold())
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func flickActionButton(imageSystemName: String, text: String? = nil, action: @escaping ()->Void ) -> some View {
        Button {
            // Toggle respective values
            action()
        } label: {
            VStack {
                Image(systemName: imageSystemName)
                    .dynamicTypeSize(.accessibility1)
                if let text = text {
                    Text(text)
                        .font(.callout)
                }
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    FlixCell(flix: FlixResponse(flixid: "", ownerid: "", domain: "", caption: "Hello there, today we are testing the samsung galaxy's zoom.", applicants: [""], location: "", likes: [""], flixurl: "https://minio.flixdin.com/test/flix/01231235435/playlist.m3u8", flixdate: "", comments: [""], banned: false, embedding: ""))
}
