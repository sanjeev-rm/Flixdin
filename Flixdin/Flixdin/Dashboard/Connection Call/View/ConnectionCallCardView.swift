//
//  ConnectionCallCardView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//  Updated by SANJEEV R M on 28/01/24.
//

import SwiftUI

struct ConnectionCallCardView: View {
    
    @State var connectionCall: ConnectionCall
    @State var owner: User = User()
    @State var showDescription: Bool = false
    @State var showDeleteConfirmationDialogue: Bool = false
    @State var showApplicants: Bool = false
    @State var isConnectionCallLiked: Bool = false
    
    var body: some View {
                    
            VStack (spacing: 16){
                
                UsernameRowView
                
                Divider()
                
                DomainSelectionView
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showDescription.toggle()
                        }
                    }
                
                if showDescription {
                    descriptionView
                }
                
                LikeAndApplyView
                
                dateView
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(flixColor: .backgroundSecondary))
            )
            .confirmationDialog("Action", isPresented: $showDeleteConfirmationDialogue) {
                Button(role: .destructive) {
                    ConnectionCallViewModel.deleteConnectionCall(postId: connectionCall.postid)
                } label: {
                    Text("Delete connection call")
                }
            }message: {
                Text("Are you sure?")
            }
            .onAppear {
                self.showDescription = false
                isConnectionCallLiked = ConnectionCallViewModel.hasUserLiked(connectionCall: connectionCall)
            }
            .sheet(isPresented: $showApplicants, content: {
                UsersListView(list: connectionCall.applicants, title: "Applicants", showDismissButton: true)
                    .presentationDetents([.large])
            })
    }
}

extension ConnectionCallCardView {
    
    //MARK: -  Username Field View
    
    private var UsernameRowView: some View {
        
        HStack  {
            
            NavigationLink {
                OtherUserProfileView(user: owner)
            } label: {
                
                Group {
                    ProfilePictureView(imageUrl: URL(string: connectionCall.profilepic), borderColor: .clear, borderWidth: 0, imageWidth: 40, imageHeight: 40)
                    
                    VStack ( alignment: .leading ) {
                        Text(owner.fullName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(owner.domain.isEmpty ? "owner domain" : owner.domain)
                            .frame(alignment: .topLeading)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            if ConnectionCallViewModel.isOwner(ownerId: connectionCall.ownerid) {
                Menu {
                    VStack {
                        Text("Actions")
                        Divider()
                        Button {
                            // show applicants list
                            showApplicants = true
                        } label: {
                            Text("Applicants")
                        }
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
        .onAppear {
            ProfileAPIService().getUser(userId: connectionCall.ownerid, completion: { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.owner = User(responseBody: user)
                    }
                case .failure(let failure):
                    print("DEBUG: \(failure.localizedDescription)")
                }
            })
        }
    }
    
    //MARK: -  Domain Selection View
    
    private var DomainSelectionView: some View {
        
        VStack (alignment: .leading, spacing: 8) {
            
            HStack {
                Text("Need")
                    .font(.system(size: 16, weight: .regular))

                Text(connectionCall.domain)
                  .font(.system(size: 16, weight: .regular))
                  .padding(6)
                  .padding(.horizontal, 8)
                  .background(
                    Rectangle()
                        .foregroundColor(Color(flixColor: .backgroundTernary))
                        .cornerRadius(8)
                  )
                
                Text("Connection")
                    .font(.system(size: 16, weight: .regular))
                
            }
            
            VStack (alignment: .leading, spacing: 3){
                
                HStack {
                    Image(systemName: "mappin")
                        .foregroundColor(Color(flixColor: .lightOlive))
                    Text(connectionCall.location)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .regular))
                        .padding(8)
                        .background(
                        Rectangle()
                            .foregroundColor(Color(flixColor: .backgroundTernary))
                            .cornerRadius(8)
                        )
                }
                
                HStack {
                    
                    Spacer()
                    
                    HStack {
                        Text("No. of Applicants :")
                        Text("\(connectionCall.applicants.count)")
                            .font(.caption.monospaced())
                    }
                    .font(.caption)
                    .fontWeight(.light)
                }
            }
        }
    }
    
    // MARK: - Description View
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Job Description")
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Text(connectionCall.caption)
                .multilineTextAlignment(.leading)
            Divider()
        }
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //MARK: - Like and Apply View
    
    private var LikeAndApplyView: some View {
        
        HStack {
            
            HStack(spacing: 16) {
                LikeAndShareView(
                    isLiked: $isConnectionCallLiked,
                    like: {
                        ConnectionCallViewModel.likeConnectionCall(postId: connectionCall.postid) { updatedListOfLikes in
                            connectionCall.likes = updatedListOfLikes
                        }
                    },
                    dislike: {
                        ConnectionCallViewModel.dislikeConnectionCall(postId: connectionCall.postid) {
                            updatedListOfLikes in
                            connectionCall.likes = updatedListOfLikes
                        }
                    }
                )
                
                Button {
                    withAnimation(.easeInOut) {
                        showDescription.toggle()
                    }
                } label: {
//                    Image(systemName: "info.circle")
                    Text(showDescription ? "less" : "more")
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
//                    Image(systemName: showDescription ? "chevron.up" : "chevron.down")
                }
            }
            
            Spacer()
            
            HStack (spacing: 16) {
                
                ConnectionCallApplyButton(
                    applied: ConnectionCallViewModel.hasUserAppliedTo(connectionCall: connectionCall),
                    applyAction: {
                        ConnectionCallViewModel.applyToConnectionCall(postId: connectionCall.postid) { updatedListOfApplicants in
                            connectionCall.applicants = updatedListOfApplicants
                        }
                    },
                    removeApplicationAction: {
                        ConnectionCallViewModel.removeApplicantOfConnectionCall(postId: connectionCall.postid) { updatedListOfApplicants in
                            connectionCall.applicants = updatedListOfApplicants
                        }
                    }
                )

                
                SaveButton(
                    saved: ConnectionCallViewModel.hasUserSaved(connectionCall: connectionCall),
                    save: {
                        print("DEBUG: Connection call saved [Not implemented, backend]")
                    }, unSave: {
                        print("DEBUG: Connection call unsaved [Not implemented, backend]")
                    }
                )
            }
        }
    }
    
    private var dateView: some View {
        VStack {
            let index = connectionCall.time_of_post.index(connectionCall.time_of_post.startIndex, offsetBy: 9)
            Text(connectionCall.time_of_post[...index])
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ConnectionCallCardView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionCallCardView(connectionCall: CONNECTION_CALL_SAMPLES[0])
    }
}
