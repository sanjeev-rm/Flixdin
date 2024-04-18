//
//  ProfileView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 06/07/23.
//

import SwiftUI


struct ProfileView: View {
    
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State var contentShown: Content = Content.posts
    @State var selectedContent : String = "posts"
    @State private var isSelectedContent: [Bool] = [true, false, false, false, false]
    private var contents: [String] = ["Followers", "Following", "Posts", "CCalls"]
    private var contentSelectors: [String] = ["posts", "connections", "portfolio", "tagged"]
    
    @State var showFollowers: Bool = false
    @State var showFollowing: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ProfileChangeView
                    .padding()
                
                
                scrollView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .confirmationDialog("Action", isPresented: $profileViewModel.showActionSheet) {
                Button(role: .destructive) {
                    profileViewModel.logout { success in
                        if success {
                            // This reasets the authenticationViewModel, which also makes the isLoggedIn variables to false
                            authViewModel.reset()
                        }
                    }
                } label: {
                    Text("Logout")
                }
                
            }message: {
                Text("Are you sure?")
            }
//            .redacted(reason: profileViewModel.showGettingUserProgress ? .placeholder: [])
            .disabled(profileViewModel.showGettingUserProgress)
            .task {
                profileViewModel.getAndUpdateUserProfileView()
            }
            .scrollDismissesKeyboard(.interactively)
            .sheet(isPresented: $showFollowers, content: {
                UsersListView(list: profileViewModel.user.followers, title: "Followers", showDismissButton: true)
                    .presentationDetents([.large])
            })
            .sheet(isPresented: $showFollowing, content: {
                UsersListView(list: profileViewModel.user.following, title: "Following", showDismissButton: true)
                    .presentationDetents([.large])
            })
        }
        
    }
    
    func selectButton(at index: Int) {
        isSelectedContent.indices.forEach { buttonIndex in
            isSelectedContent[buttonIndex] = buttonIndex == index
        }
    }
    
}

extension ProfileView {
    enum Content: String {
        case posts = "posts"
        case connections = "connections"
        case portfolio = "portfolio"
//        case saved = "saved"
        case tagged = "tagged"
    }
}

extension ProfileView {
    
    //MARK: - Profile Change View
    
    private var ProfileChangeView: some View {
        
        HStack {
            if profileViewModel.showGettingUserProgress {
                ProgressView()
            } else {
                Button {
                    // Action Shows the other accounts.
                    profileViewModel.showActionSheet.toggle()
                } label: {
                    HStack {
                        Text(profileViewModel.user.username)
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(flixColor: .lightOlive))
                    }
                }
            }
            Spacer()
            
            Button {
                // Three Dots
                profileViewModel.showActionSheet.toggle()
            } label: {
                Image(systemName: "ellipsis")
            }
            
        }
    }
    
    // MARK: - Scroll view
    private var scrollView: some View {
        
        ScrollView (showsIndicators: false){
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    
                    if profileViewModel.domain == .productionHouse {
                        VStack {
                            Divider()
                            Text("Production House")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Divider()
                        }
                    }
                    
                    ImageView
                    
                    AboutYouView
                        .padding(.bottom, 8)
                    
                    ContentPostedView
                        .padding(.horizontal)
                    
                    EditAndShareView
                        .padding(.horizontal)
                }
                .disabled(profileViewModel.showGettingUserProgress)
                
                VStack(spacing: 8) {
                    
                    contentSectionView
                        .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(flixColor: .olive))
                    
                    ShowContentView
                }
            }
        }
        .refreshable {
            profileViewModel.getAndUpdateUserProfileView()
        }
    }
    
    //MARK: - Image View
    private var ImageView: some View {
        ProfilePictureView(imageUrl: URL(string: profileViewModel.profilePicUrl), borderColor: Color(flixColor: .lightOlive), borderWidth: 3, imageWidth: 90, imageHeight: 90)
            .padding(.top, 3)
    }
    
    //MARK: - About You View
    private var AboutYouView: some View {
        VStack {
            Text(profileViewModel.user.fullName)
                .font(.title2.weight(.semibold))
            if profileViewModel.domain != .productionHouse {
                Text(profileViewModel.domain.title)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            Text(profileViewModel.user.bio)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    //MARK: - Content Posted View
    private var ContentPostedView: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
            
            HStack {
                ForEach(self.contents, id: \.self) { content in
                    Spacer()
                    VStack (spacing: 4) {
                        switch content {
                        case "Posts":
                            Text(String(profileViewModel.userPosts.count))
                                .font(.callout.bold())
                        case "Followers":
                            Text(String(profileViewModel.user.followers.count))
                                .font(.callout.bold())
                                .onTapGesture {
                                    showFollowers = true
                                }
                        case "Following":
                            Text(String(profileViewModel.user.following.count))
                                .font(.callout.bold())
                                .onTapGesture {
                                    showFollowing = true
                                }
                        case "CCalls":
                            Text(String(profileViewModel.user.connectionCall.count))
                                .font(.callout.bold())
                        default:
                            Text("")
                        }
                        Text(content)
                            .font(.caption.weight(.medium))
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 11)
        }
    }
    
    //MARK: - Edit and Share View
    private var EditAndShareView: some View {
        HStack {
            NavigationLink {
                EditPageView()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(profileViewModel)
                
            } label: {
                ZStack {
                    Rectangle()
                        .frame(height: 45)
                        .cornerRadius(8)
                        .foregroundColor(.clear)
                        .background(Color(flixColor: .backgroundSecondary))
                        .cornerRadius(8)
                    Text("Edit Profile")
                        .font(.footnote)
                        .foregroundColor(.primary)
                        .padding(8)
                }
            }
            
            Button {
                // Action to Share Profile
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
            
            Menu {
                VStack {
                    Text("OTHER SKILLS")
                        .font(.headline)
                    Divider()
                    ForEach(profileViewModel.user.otherSkills, id: \.self) { otherSkill in
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
//                    Image(flixImage: .otherSkillsLogo)
//                        .foregroundColor(.white)
                    Image(systemName: "shareplay")
                        .foregroundStyle(.primary)
                }
            }

        }
    }
    
    //MARK: - Content Selection View
    private var contentSectionView: some View {
        
        HStack(spacing: 30) {
            
            ForEach(contentSelectors, id: \.self) { selector in
                
                switch selector {
                case "posts":
                    Button {
                        // Shows the Posts View Action
                        self.selectedContent = "posts"
                        self.selectButton(at: 0)
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(isSelectedContent[0] ? Color(flixColor: .backgroundSecondary): .clear)
                                .cornerRadius(8)
                            Image(flixImage: .grid)
                                .foregroundColor(Color(flixColor: .backgroundSecondary))
                                .frame(width: 45, height: 45)
                        }
                    }
                case "connections":
                    Button{
                        // Shows the Connection View Action
                        self.selectedContent = "connections"
                        self.selectButton(at: 1)
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(isSelectedContent[1] ? Color(flixColor: .backgroundSecondary): .clear)
                                .cornerRadius(8)
                            Image(flixImage: .connectionCall)
                                .foregroundColor(Color(flixColor: .backgroundSecondary))
                                .frame(width: 45, height: 45)
                        }
                    }
                case "portfolio":
                    Button{
                        // Shows the portfolio View Action
                        self.selectedContent = "portfolio"
                        self.selectButton(at: 2)
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(isSelectedContent[2] ? Color(flixColor: .backgroundSecondary): .clear)
                                .cornerRadius(8)
                            Image(flixImage: .portfolio)
                                .foregroundColor(Color(flixColor: .backgroundSecondary))
                                .frame(width: 45, height: 45)
                        }
                    }
                
                case "tagged":
                    Button{
                        // Shows the tagged View Action
                        self.selectedContent = "tagged"
                        self.selectButton(at: 4)
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(isSelectedContent[4] ? Color(flixColor: .backgroundSecondary): .clear)
                                .cornerRadius(8)
                            Image(flixImage: .tagged)
                                .foregroundColor(Color(flixColor: .backgroundSecondary))
                                .frame(width: 45, height: 45)
                        }
                    }
                default:
                    Button{
                        // Shows the Posts View Action
                        self.selectedContent = "posts"
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .background(Color(flixColor: .backgroundSecondary))
                                .cornerRadius(8)
                            Image(flixImage: .grid)
                                .foregroundColor(Color(flixColor: .backgroundSecondary))
                                .frame(width: 45, height: 45)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder private var ShowContentView: some View {
        ScrollView {
            switch selectedContent {
            case "posts" :
                postsContentView
            case "connections":
                ConnectionCallView
            case "portfolio":
                PortfolioContentView
            case "tagged":
                TaggedContentView
            default:
                postsContentView
            }
        }
        
    }
    
}

extension ProfileView {
    
    // MARK: - Posts Content View
    private var postsContentView: some View {
        UserPostsGridView(posts: $profileViewModel.userPosts)
            .onAppear {
                ProfileViewModel.getUserPosts(userId: profileViewModel.user.id) { posts in
                    profileViewModel.userPosts = posts
                }
            }
    }
    
    //MARK: - Connection Call View
    private var ConnectionCallView: some View {
        ProfileConnectionCallView(user: $profileViewModel.user)
    }
    
    //MARK: - Portfolio Content View
    private var PortfolioContentView: some View {
        PortfolioView(user: $profileViewModel.user)
            .environmentObject(profileViewModel)
            .padding(.horizontal)
    }
    
    //MARK: - Tagged Content View
    private var TaggedContentView: some View {
        ImagesGridView()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
