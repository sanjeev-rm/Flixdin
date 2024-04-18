//
//  layout2.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct NoVerticalPicture: View {
    var body: some View {
        HStack {
            NavigationLink {
//                ExpandedPostCardView()
            } label: {
                AsyncImage(url: URL(string: "https://picsum.photos/121/123")!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (width / 3) - 2, height: 125, alignment: .center)
                    .cornerRadius(4)
            }
            
            NavigationLink {
//                ExpandedPostCardView()
            } label: {
                AsyncImage(url: URL(string: "https://picsum.photos/121/123")!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (width / 3) - 2, height: 125, alignment: .center)
                    .cornerRadius(4)
            }
            
            NavigationLink {
//                ExpandedPostCardView()
            } label: {
                AsyncImage(url: URL(string: "https://picsum.photos/121/123")!)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (width / 3) - 2, height: 125, alignment: .center)
                    .cornerRadius(4)
            }
        }
    }
}

struct layout2_Previews: PreviewProvider {
    static var previews: some View {
        NoVerticalPicture()
    }
}
