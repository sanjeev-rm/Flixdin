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

    init(flix: FlixResponse) {
        self.flix = flix

        if let url = URL(string: flix.flixurl) {
            player = AVPlayer(url: url)
        } else {
            print("error getting url")
            player = nil
        }
    }

    var body: some View {
        ZStack {
            if let url = URL(string: flix.flixurl) {
                CustomFlixPlayer(player: player ?? AVPlayer(url: URL(string: "")!))

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

#Preview {
    FlixCell(flix: FlixResponse(flixid: "", ownerid: "", domain: "", caption: "", applicants: [""], location: "", likes: [""], flixurl: "https://minio.flixdin.com/test/flix/01231235435/playlist.m3u8", flixdate: "", comments: [""], banned: false, embedding: ""))
}

extension FlixCell {
    // MARK: user details

    private func userDetails() -> some View {
        VStack(alignment: .leading) {
            Text("some.user")
                .fontWeight(.semibold)
            Text("some super long capiton")
        }
        .foregroundColor(.white)
        .font(.subheadline)
    }

    // MARK: actions

    private func actions() -> some View {
        VStack(spacing: 28) {
            Button(action: {
            }, label: {
                VStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                    Text("\(flix.likes.count)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }
            })

            Button(action: {
                showComments.toggle()

            }, label: {
                VStack {
                    Image(systemName: "ellipsis.bubble.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                    Text("\(flix.comments.count)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .bold()
                }

            })

            Button(action: {
            }, label: {
                Image(systemName: "bookmark.fill")
                    .resizable()
                    .frame(width: 22, height: 28)
                    .foregroundColor(.white)
            })

            Button(action: {
            }, label: {
                Image(systemName: "arrowshape.turn.up.right.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.white)
            })
        }
    }
}
