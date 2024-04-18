//
//  UserPostInGridView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct UserPostInGridView: View {
    
    @State var post: Post
    @State var postImage: Image?
    
    var body: some View {
        NavigationLink {
            ExpandedPostCardView(post: $post, postImage: $postImage)
        } label: {
            FlixdinImageView(urlString: post.image, contentImage: $postImage)
        }
    }
}

#Preview {
    NavigationStack {
        UserPostInGridView(post: SAMPLE_POST)
    }
}
