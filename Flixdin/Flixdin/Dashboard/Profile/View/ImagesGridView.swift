//
//  ImagesGridView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 16/10/23.
//

import SwiftUI

struct ImagesGridView: View {
    
    @State var imagesUrls: [String] = ["https://picsum.photos/300", "https://picsum.photos/176", "https://picsum.photos/102", "https://picsum.photos/103", "https://picsum.photos/104", "https://picsum.photos/105", "https://picsum.photos/106", "https://picsum.photos/107"]
    
    var widthAndHeight: CGFloat = UIScreen.main.bounds.width / 3 - 8
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: widthAndHeight, maximum: widthAndHeight))]) {
                ForEach(imagesUrls, id: \.self) { imageUrl in
                    NavigationLink {
//                        ExpandedPostCardView()
                    } label: {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: widthAndHeight, height: widthAndHeight)
                        } placeholder: {
                            Color(flixColor: .backgroundSecondary)
                                .frame(width: widthAndHeight, height: widthAndHeight)
                        }

                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
}

#Preview {
    NavigationStack {
        ImagesGridView()
    }
}
