//
//  ExpandedPostCardView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 02/08/23.
//

import SwiftUI

struct ExpandedPostCardView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var post: Post
    @Binding var postImage: Image?
    
    var body: some View {
        ScrollView {
            postCard
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(flixColor: .backgroundPrimary)
        )
    }
}

extension ExpandedPostCardView {
    private var postCard: some View {
        PostCardView(post: $post, postImage: postImage, backgroundColor: Color(flixColor: .backgroundPrimary))
    }
}

struct ExpandedPostCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExpandedPostCardView(post: .constant(SAMPLE_POST), postImage: .constant(Image("")))
        }
    }
}
