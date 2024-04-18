//
//  Layout1.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

var width = UIScreen.main.bounds.width - 30

struct LeftVerticalPicture: View {
    var body: some View {
        
        HStack {
            
            NavigationLink {
//                ExpandedPostCardView()
            } label: {
                AsyncImage(url: URL(string: "https://picsum.photos/262/250")!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (width - (width / 3)), height: 250, alignment: .center)
                    .cornerRadius(4)
            }
            
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
                    AsyncImage(url: URL(string: "https://picsum.photos/262/123"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (width / 3), height: 122.5, alignment: .center)
                        .cornerRadius(4)
                }
            }
        }
    }
}


struct Layout1_Previews: PreviewProvider {
    static var previews: some View {
        LeftVerticalPicture()
    }
}
