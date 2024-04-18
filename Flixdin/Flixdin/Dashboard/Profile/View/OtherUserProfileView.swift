//
//  OtherUserProfileView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct OtherUserProfileView: View {
    
    @State var user: User = User()
    @State var selectedContentType: ContentType = .posts
    @State var posts: [Post] = []
    @State var showFollowers: Bool = false
    @State var showFollowing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                userInfoView
                    .padding()
                
                VStack {
                    contentTypeSelectionView
                    contentView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showFollowers, content: {
            UsersListView(list: user.followers, title: "Followers", showDismissButton: true)
                .presentationDetents([.large])
        })
        .sheet(isPresented: $showFollowing, content: {
            UsersListView(list: user.following, title: "Following", showDismissButton: true)
                .presentationDetents([.large])
        })
    }
}

extension OtherUserProfileView {
    
    // MARK: - Content Count Info
    
    enum ContentInfo: String, CaseIterable {
        case followersCount = "Followers"
        case followingCount = "Following"
        case postsCount = "Posts"
        case connectionCallCount = "CCalls"
        
        func count(user: User) -> Int {
            switch self {
            case .followersCount: return user.followers.count
            case .followingCount: return user.following.count
            case .postsCount: return 0
            case .connectionCallCount: return user.connectionCall.count
            }
        }
    }
    
    private var userInfoView: some View {
        VStack(spacing: 16) {
            ProfilePictureView(imageUrl: URL(string: user.profilePic ?? ""), borderColor: Color.accentColor, borderWidth: 3, imageWidth: 90, imageHeight: 90)
            
            basicInfoView
            
            VStack(spacing: 8) {
                contentInfoView
                followAndShareProfileButton
            }
        }
    }
    
    private var basicInfoView: some View {
        VStack(spacing: 4) {
            Text(user.fullName)
                .font(.title2.bold())
            Text(user.domain)
                .font(.callout.bold())
                .foregroundStyle(.secondary)
            Text(user.bio)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    private var contentInfoView: some View {
        HStack {
            ForEach(ContentInfo.allCases, id: \.self) { contentInfo in
                contentInfoCard(contentInfo: contentInfo)
                    .onTapGesture {
                        switch contentInfo {
                        case .followersCount: showFollowers = true
                        case .followingCount: showFollowing = true
                        default: print("")
                        }
                    }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(flixColor: .backgroundSecondary))
        }
    }
    
    private func contentInfoCard(contentInfo: ContentInfo) -> some View {
        VStack {
            Text("\(contentInfo == .postsCount ? posts.count :  contentInfo.count(user: user))")
                .font(.callout.bold())
            Text("\(contentInfo.rawValue)")
                .font(.caption.weight(.medium))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Action Buttons
    
    private var followAndShareProfileButton: some View {
        HStack {
            
            FollowButton(otherUser: $user)
            
            shareProfileButton
            
            otherSkillsButton
        }
    }
    
    private var shareProfileButton: some View {
        Button {
            print("DEBUG: share profile")
        } label: {
            ZStack {
                Rectangle()
                    .frame(height: 45)
                    .cornerRadius(8)
                    .foregroundColor(.clear)
                    .background(Color(flixColor: .backgroundSecondary))
                    .cornerRadius(8)
                Text("Share Profile")
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .padding(8)
            }
        }
    }
    
    private var otherSkillsButton: some View {
        Menu {
            VStack {
                Text("OTHER SKILLS")
                    .font(.headline)
                Divider()
                ForEach(user.otherSkills, id: \.self) { otherSkill in
                    Text(otherSkill)
                }
            }
        } label: {
            ZStack{
                Rectangle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.clear)
                    .background(Color(flixColor: .backgroundSecondary))
                    .cornerRadius(8)
                Image(systemName: "shareplay")
                    .foregroundStyle(.primary)
            }
        }
    }
}

// MARK: - Content

extension OtherUserProfileView {
    
    enum ContentType: CaseIterable {
        case posts
        case connectionCalls
        case portfolio
        case tagged
        
        var iconImage: Image {
            switch self {
            case .posts: return Image(flixImage: .grid)
            case .connectionCalls: return Image(flixImage: .connectionCall)
            case .portfolio: return Image(flixImage: .portfolio)
            case .tagged: return Image(flixImage: .tagged)
            }
        }
    }
    
    private var contentTypeSelectionView: some View {
        VStack {
            HStack {
                ForEach(ContentType.allCases, id: \.self) { contentType in
                    contentTypeButton(contentType: contentType)
                    if contentType != ContentType.allCases.last! {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(flixColor: .olive))
        }
    }
    
    private func contentTypeButton(contentType: ContentType) -> some View {
        
        let isSelected = (selectedContentType == contentType)
        
        return Button {
            selectedContentType = contentType
        } label: {
            contentType.iconImage
                .frame(width: 45, height: 45)
                .padding(.horizontal, 8)
                .background {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(isSelected ? Color(flixColor: .backgroundSecondary): .clear)
                        .cornerRadius(8)
                }
        }
    }
}

// MARK: - Content View

extension OtherUserProfileView {
    
    @ViewBuilder private var contentView: some View {
        switch selectedContentType {
        case .posts: postsContentView
        case .connectionCalls: connectionCallView
        case .portfolio: portfolioContentView
        case .tagged: taggedContentView
        }
    }
    
    // MARK: Posts Content View
    private var postsContentView: some View {
        UserPostsGridView(posts: $posts)
            .onAppear {
                ProfileViewModel.getUserPosts(userId: user.id) { posts in
                    self.posts = posts
                }
            }
    }
    
    //MARK: Connection Call View
    private var connectionCallView: some View {
        ProfileConnectionCallView(user: $user, showSegmentedControl: false)
    }
    
    //MARK: Portfolio Content View
    private var portfolioContentView: some View {
        PortfolioView(user: $user)
            .padding(.horizontal)
    }
    
    //MARK: Tagged Content View
    private var taggedContentView: some View {
        ImagesGridView()
    }
}

#Preview {
    OtherUserProfileView()
}
