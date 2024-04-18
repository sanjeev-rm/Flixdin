//
//  FlickPlayer.swift
//  Flixdin
//
//  Created by Sanjeev RM on 28/08/23.
//

import SwiftUI
import AVKit

struct FlickPlayer: View {
    
    @Binding var flick: Flick
    
    @State var showMore: Bool = false
    @State var isLiked: Bool = false
    @State var isPaused: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if let player = flick.player {
                
                CustomVideoPlayer(player: player)
                    .onTapGesture {
                        playerPausePlay(player: player)
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
    }
}



extension FlickPlayer {
    
    private var userInfoAndDescription: some View {
        VStack(alignment: .leading) {
            profileUsernameFollowButton
            
            if showMore {
                
                ScrollView(.vertical, showsIndicators: false) {
                    Text(flick.mediaFile.title + flick.mediaFile.description)
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
                    HStack {
                        Text(flick.mediaFile.title)
                            .foregroundColor(.white)
                            .font(.callout)
                            .fontWeight(.semibold)
                        
                        Text("more")
                            .font(.callout.bold())
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
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
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            Button {
                // Toggle respective values
                withAnimation {
                    isLiked.toggle()
                }
            } label: {
                VStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .dynamicTypeSize(.accessibility1)
                        .foregroundColor(isLiked ? Color(.systemRed) : .white)
                    Text("10")
                        .font(.callout)
                        .foregroundColor(.white)
                }
            }
            flickActionButton(imageSystemName: "message", text: "3")
            flickActionButton(imageSystemName: "paperplane")
                .padding(.bottom, 8)
            flickActionButton(imageSystemName: "ellipsis")
                .rotationEffect(.degrees(90))
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
    
    private func flickActionButton(imageSystemName: String, text: String? = nil) -> some View {
        Button {
            // Toggle respective values
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
