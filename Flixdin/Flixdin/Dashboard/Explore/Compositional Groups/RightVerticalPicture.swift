//
//  layout3.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct RightVerticalPicture: View {
    var body: some View {
        HStack {
            VStack {
                NavigationLink {
//                    ExpandedPostCardView()
                } label: {
                    AsyncImage(url: URL(string: "https://picsum.photos/262/123")!)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (width / 3), height: 122.5, alignment: .center)
                        .cornerRadius(4)
                }
                
                NavigationLink {
//                    ExpandedPostCardView()
                } label: {
                    AsyncImage(url: URL(string: "https://picsum.photos/262/123")!)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (width / 3), height: 122.5, alignment: .center)
                        .cornerRadius(4)
                }
            }
            
            NavigationLink {
//                ExpandedPostCardView()
                //Text()
            } label: {
                AsyncImage(url: URL(string: "https://picsum.photos/262/250")!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (width - (width / 3)), height: 250, alignment: .center)
                    .cornerRadius(4)
            }
            
        }
    }
}

struct layout3_Previews: PreviewProvider {
    static var previews: some View {
        RightVerticalPicture()
    }
}
