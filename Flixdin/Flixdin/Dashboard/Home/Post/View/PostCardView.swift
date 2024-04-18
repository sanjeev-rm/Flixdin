//
//  PostCardView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 03/03/24.
//

import SwiftUI

struct PostCardView: View {
    
    @Binding var post: Post
    @State var owner: User?
    @State var postImage: Image?
    @State var gettingOwner: Bool = false
    @State var backgroundColor: Color = Color(flixColor: .backgroundSecondary)
    
    @State var showMoreCaption: Bool = false
    @State var showDeleteConfirmationDialogue: Bool = false
    @State var isPostLiked: Bool = false
    @State var showLikeAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            ownerInfoView
            
            image
            
            actionsAndDescriptionView
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(backgroundColor)
        .cornerRadius(16)
        .onAppear {
            gettingOwner = true
            ProfileAPIService().getUser(userId: post.ownerid) { result in
                DispatchQueue.main.async {
                    self.gettingOwner = false
                    switch result {
                    case .success(let user):
                        self.owner = User(responseBody: user)
                    case .failure(let failure):
                        print("DEBUG: Post couldn't get owner - \(failure.localizedDescription)")
                    }
                }
            }
            isPostLiked = PostViewModel.hasUserLiked(post: post)
        }
        .confirmationDialog("Action", isPresented: $showDeleteConfirmationDialogue) {
            Button(role: .destructive) {
                PostViewModel.deletePost(postId: post.postid)
            } label: {
                Text("Delete post")
            }
            
        }message: {
            Text("Are you sure?")
        }
    }
}

extension PostCardView {
    
    private var ownerInfoView: some View {
        HStack {
            NavigationLink {
                OtherUserProfileView(user: owner ?? User())
            } label: {
                ProfilePictureView(imageUrl: URL(string: owner?.profilePic ?? ""), borderColor: .clear, borderWidth: 0, imageWidth: 40, imageHeight: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(owner?.fullName ?? "Username")
                        .font(.headline)
                        .foregroundColor(.primary)
                    HStack(spacing: 8) {
                        Text(owner?.domain ?? "Domain")
                        Circle()
                            .frame(width: 3)
                        Text(post.location)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if PostViewModel.isCurrentUserOwner(postOwnerId: post.ownerid) {
                Menu {
                    VStack {
                        Text("Actions")
                        Divider()
                        Button(role: .destructive) {
                            // show delete confirmation dialogue
                            showDeleteConfirmationDialogue = true
                        } label: {
                            Text("Delete")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.accentColor)
                        .padding(8)
                }
            }
        }
        .padding(.horizontal, 8)
        .redacted(reason: gettingOwner ? .placeholder : [])
    }
    
    private var image: some View {
        ZStack {
            if let postImage = postImage {
                postImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                FlixdinImageView(urlString: post.image, contentImage: .constant(nil))
            }
            
            if showLikeAnimation {
                HeartBounceView()
            }
        }
        .onTapGesture(count: 2) {
            PostViewModel.doActionOnPost(action: .like, postId: post.postid) { liked in
                if liked {
                    isPostLiked = true
                    showLikeAnimation = false
                    showLikeAnimation = true
                }
            }
        }
    }
    
    private var actionsAndDescriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                LikeAndShareView(
                    isLiked: $isPostLiked,
                    like: {
                        PostViewModel.doActionOnPost(action: .like, postId: post.postid) { _ in
                            showLikeAnimation = false
                            showLikeAnimation = true
                        }
                    },
                    dislike: {
                        PostViewModel.doActionOnPost(action: .dislike, postId: post.postid) { _ in }
                    }
                )
                
                Spacer()
                
                SaveButton(
                    saved:PostViewModel.hasUserSaved(post: post),
                    save: { PostViewModel.doActionOnPost(action: .save, postId: post.postid) { _ in } },
                    unSave: { print("DEBUG: post un-saved [not implemented in backend]") }
                )
            }
            
            if post.caption.count <= 75 {
                Text(post.caption)
                    .multilineTextAlignment(.leading)
                    .font(.footnote)
            } else {
                dynamicDescriptionView(caption: post.caption, showMore: showMoreCaption)
            }
            
            let index = post.time_of_post.index(post.time_of_post.startIndex, offsetBy: 9)
            Text(post.time_of_post[...index])
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
    }
}

extension PostCardView {
    
    
    
    func dynamicDescriptionView(caption: String, showMore: Bool) -> some View {
        VStack(alignment: .leading) {
            let strIndex = caption.index(caption.startIndex, offsetBy: 75)
            let str = showMore ? caption : (caption[..<strIndex] + "...")
            Text(str)
                .multilineTextAlignment(.leading)
            
            Button {
                withAnimation(.easeIn) {
                    showMoreCaption.toggle()
                }
            } label: {
                Text(showMore ? "less" : "more")
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
        }
        .font(.footnote)
    }
}

#Preview {
    ScrollView {
        PostCardView(post: .constant(SAMPLE_POST))
    }
    .padding(.horizontal)
}
