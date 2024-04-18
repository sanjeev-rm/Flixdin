//
//  LikeCommentAndShareView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 08/08/23.
//  Modified by SANJEEV R M on 07/03/24.

import SwiftUI

struct LikeAndShareView: View {
    
    @Binding var isLiked: Bool
    
    var like: (() -> Void)
    var dislike: (() -> Void)
//    var commentAction: (() -> Void) = ({print("DEBUG: Comment tapped!")})
    var shareAction: (() -> Void) = ({print("DEBUG: Share tapped!")})
    
    var body: some View {
        HStack(spacing: 16) {
            likeButton
//            commentButton
            shareButton
        }
        .font(.title3)
    }
}

extension LikeAndShareView {
    
    private var likeButton: some View {
        Button {
            if isLiked {
                dislike()
            } else {
                like()
            }
            isLiked.toggle()
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .accentColor)
        }
    }
    
    private var commentButton: some View {
        Button {
//            commentAction()
        } label: {
            Image(systemName: "message")
        }
    }
    
    private var shareButton: some View {
        Button {
            shareAction()
        } label: {
            Image(systemName: "paperplane")
        }
    }
}

struct LikeCommentAndShareView_Previews: PreviewProvider {
    static var previews: some View {
//        LikeCommentAndShareView(isLiked: Binding.constant(false), isAnimate: Binding.constant(false), isShareButtonPressed: Binding.constant(false))
        LikeAndShareView(isLiked: .constant(false), like: ({print("DEBUG: Liked!")}), dislike: ({print("DEBUG: Disliked!")}))
    }
}
