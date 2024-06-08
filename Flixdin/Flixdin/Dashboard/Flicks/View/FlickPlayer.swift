//
//  FlickPlayer.swift
//  Flixdin
//
//  Created by Sanjeev RM on 28/08/23.
//

import SwiftUI
import AVKit

struct FlickPlayer: View {
    
    let flix: FlixResponse
    var player: AVPlayer?
    init(flix: FlixResponse) {
        self.flix = flix

        if let url = URL(string: flix.flixurl) {
            player = AVPlayer(url: url)
        } else {
            print("error getting url")
            player = nil
        }
    }
    
    @State var showMore: Bool = false
    @State var isPaused: Bool = false
    @State var likeStatus: Bool = false
    @State var showComments: Bool = false
    @StateObject var flixCellViewModel = FlixCellViewModel()
    
    @State var owner: User?
    @State var gettingOwner: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let player = player {
                if let url = URL(string: flix.flixurl) {
                    CustomFlixPlayer(player: player)
                        .ignoresSafeArea()
                        .onTapGesture {
                            playerPausePlay(player: player)
                        }
                } else {
                    Rectangle()
                        .foregroundColor(.blue)
                        .overlay {
                            Text("Error getting video")
                        }
                }
                
                if isPaused {
                    Image(systemName: "play.circle.fill")
                        .renderingMode(.original)
                        .foregroundColor(.black.opacity(0.7))
                        .dynamicTypeSize(.accessibility5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            playerPausePlay(player: player)
                        }
                }
                
                // Playing / Pausing video based on offset
                // During the scrolling, switching to other flicks
                
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    let size = proxy.size
                    
                    DispatchQueue.main.async {
                        if minY < (size.height / 2) && -minY < (size.height / 2) {
                            player.play()
                        } else {
                            player.pause()
                        }
                    }
                    
                    return Color.clear
                }
                
                Color.black.opacity(showMore ? 0.6 : 0)
                    .onTapGesture {
                        withAnimation {
                            showMore.toggle()
                        }
                    }
//                    .ignoresSafeArea()
                
                VStack {
                    HStack(alignment: .bottom) {
                        userInfoAndDescription
                        Spacer()
                        actionButtonsView
                    }
//                    musicInfoView
                }
                .padding(16)
            }
        }
        .onAppear {
            self.isPaused = false
        }
        .sheet(isPresented: $showComments, content: {
            CommentsView()
        })
    }
}



extension FlickPlayer {
    
    private var userInfoAndDescription: some View {
        VStack(alignment: .leading) {
            profileUsernameFollowButton
            
            if showMore {
                
                ScrollView(.vertical, showsIndicators: false) {
                    Text(flix.caption)
                        .foregroundColor(.white)
                        .font(.callout)
                }
                .frame(height: 150)
                
            } else {
                
                Button {
                    // Show more of the caption
                    withAnimation {
                        showMore.toggle()
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(flix.caption)
                            .foregroundColor(.white)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .frame(height: 16, alignment: .topLeading)
                        
                        Text("more")
                            .font(.callout.bold())
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var profileUsernameFollowButton: some View {
        HStack {
            
            NavigationLink {
                OtherUserProfileView(user: owner ?? User())
            } label: {
                ProfilePictureView(imageUrl: URL(string: owner?.profilePic ?? ""), borderColor: .accent, borderWidth: 3, imageWidth: 40, imageHeight: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(owner?.fullName ?? "Username")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            
//            Button {
//                // Follow the user
//            } label: {
//                Text("Follow")
//                    .font(.caption.bold())
//                    .foregroundColor(.white)
//                    .padding(8)
//                    .padding(.horizontal, 8)
//                    .background(.accent)
//                    .cornerRadius(4)
//            }
            
        }
        .redacted(reason: gettingOwner ? .placeholder : [])
        .onAppear {
            gettingOwner = true
            ProfileAPIService().getUser(userId: flix.ownerid) { result in
                DispatchQueue.main.async {
                    self.gettingOwner = false
                    switch result {
                    case .success(let user):
                        self.owner = User(responseBody: user)
                    case .failure(let failure):
                        print("DEBUG: Post couldn't get owner - \(failure.localizedDescription)")
                    }
                }
            }
            likeStatus = FlixCellViewModel.hasUserLiked(flix: flix)
        }
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
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
        .padding(.bottom, 27)
    }
    
    private var musicInfoView: some View {
        HStack {
            Label("A sky full of stars", systemImage: "music.note")
                .foregroundColor(.black)
                .font(.caption)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundColor(.white)
                )
            
            Spacer()
            
            Button {
                // Show music info
            } label: {
                Image(systemName: "music.note.list")
                    .dynamicTypeSize(.xxxLarge)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(
                        Color.cyan
                    )
                    .cornerRadius(8)
            }
        }
    }
    
    private func flickActionButton(imageSystemName: String, text: String? = nil, action: @escaping ()->Void) -> some View {
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
    
    private func playerPausePlay(player: AVPlayer) {
        if player.timeControlStatus == .playing {
            player.pause()
            withAnimation {
                isPaused = true
            }
        } else if player.timeControlStatus == .paused {
            player.play()
            withAnimation {
                isPaused = false
            }
        }
    }
}

#Preview {
    FlickPlayer(flix: FlixResponse(flixid: "", ownerid: "", domain: "", caption: "Hello there, today we are testing the samsung galaxy's zoom. We're even checking the stabilization.", applicants: [""], location: "", likes: [""], flixurl: "https://minio.flixdin.com/test/flix/01231235435/playlist.m3u8", flixdate: "", comments: [""], banned: false, embedding: ""))
}
