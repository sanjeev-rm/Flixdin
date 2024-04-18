//
//  FlicksView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 26/08/23.
//

import SwiftUI
import AVKit

struct FlicksView: View {
    
    @State var currentFlick = ""
    
    @State var flicks = MediaFileJSON.map { item in
        let urlString = Bundle.main.path(forResource: item.url, ofType: "mp4") ?? ""
        let player = AVPlayer(url: URL(fileURLWithPath: urlString))
        return Flick(player: player, mediaFile: item)
    }
    
    @State var showAddFlickView: Bool = false
    
    var body: some View {
        
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                TabView(selection: $currentFlick) {
                    ForEach($flicks) { $flick in
                        FlickPlayer(flick: $flick)
                            .frame(width: size.width)
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all, edges: .top)
                    }
                }
                .rotationEffect(.init(degrees: 90))
                .frame(width: size.height)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(width: size.width)
                
                HStack() {
                    Text("Flicks")
                        .font(.title.bold())
                    Spacer()
                    Button {
                        showAddFlickView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .shadow(radius: 8)
                    .padding(4)
                    .background(.regularMaterial)
                    .cornerRadius(4)
                    .foregroundColor(.accentColor)
                }
                .foregroundColor(.white)
                .padding(.top, 52)
                .padding([.horizontal], 24)
                .padding(.bottom)
                .background(.ultraThinMaterial)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.ignoresSafeArea())
        .fullScreenCover(isPresented: $showAddFlickView, onDismiss: {}, content: {
            AddFlicksView(showAddFlicksView: $showAddFlickView)
        })
    }
}

struct FlicksView_Previews: PreviewProvider {
    static var previews: some View {
        FlicksView()
    }
}
