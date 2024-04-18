//
//  UserPostsGridView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 03/03/24.
//

import SwiftUI

struct UserPostsGridView: View {
    
    @Binding var posts: [Post]
    
    var widthAndHeight: CGFloat = UIScreen.main.bounds.width / 3 - 8
    
    var body: some View {
        ScrollView {
            if posts.isEmpty {
                Text("No Posts")
                    .foregroundStyle(.secondary)
                    .font(.headline)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthAndHeight, maximum: widthAndHeight))]) {
                    ForEach(posts, id: \.postid) { post in
                        UserPostInGridView(post: post)
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
        UserPostsGridView(posts: .constant([SAMPLE_POST]))
    }
}
