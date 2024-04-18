//
//  AddPostView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/08/23.
//

import SwiftUI
import YPImagePicker

struct AddPostView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var addPostVM: AddPostViewModel = AddPostViewModel()
    
    @FocusState var isKeyboardActive: Bool
        
    var body: some View {
        NavigationStack {
            VStack {
                titleAndCancelButton
                
                if addPostVM.postPosted {
                    PostedView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.easeOut) {
                                    self.dismiss()
                                }
                            }
                        }
                } else {
                    newPostAndAddButton
                }
            }
            .background(Color(flixColor: .backgroundPrimary))
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isKeyboardActive = false
                    }
                }
            }
            .fullScreenCover(isPresented: $addPostVM.showMediaPicker, content: {
                MediaPicker(images: $addPostVM.images, thumbnail: $addPostVM.thumbnail)
            })
            .onAppear {
                UtilityFunction.getCurrentUser { user in
                    guard let user = user else { return }
                    DispatchQueue.main.async {
                        addPostVM.currentUser = user
                    }
                }
            }
            .sheet(isPresented: $addPostVM.showLocationSearcher, onDismiss: {
                if addPostVM.locationPlace.place != Place().place {
                    addPostVM.location = addPostVM.locationPlace.place.name!
                }
            }, content: {
                SearchPlaceView(selectedPlace: $addPostVM.locationPlace)
            })
        }
    }
}



extension AddPostView {
    
    private var titleAndCancelButton: some View {
        VStack(spacing: 18) {
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(Color.accentColor)
            HStack {
                Text("New Post")
                    .font(.title2)
                    .foregroundColor(Color.accentColor)
                Spacer()
                Button {
                    // Dismiss view
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .dynamicTypeSize(.xxxLarge)
                }
            }
            .padding(.horizontal, 16)
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(Color.accentColor)
        }
    }
    
    private var postDetailsView: some View {
        VStack(alignment: .leading) {
            postAndCaptionView
            Divider()
//            tagPeopleView
//                .padding(.horizontal)
//                .padding(.vertical, 8)
//            Divider()
            addLocationView
                .padding(.horizontal)
                .padding(.vertical, 8)
            Divider()
        }
    }
    
    private var postAndCaptionView: some View {
        HStack {
            
            ProfilePictureView(imageUrl: URL(string: addPostVM.currentUser.profilePic ?? ""),
                               borderColor: Color(.clear),
                               borderWidth: 0,
                               imageWidth: 50, imageHeight: 50)
            
            TextField("Write a caption..", text: $addPostVM.caption, axis: .vertical)
                .frame(height: 80)
                .scrollDismissesKeyboard(.immediately)
                .focused($isKeyboardActive)
            
            Button {
                //Open YPImagePicker
                addPostVM.showMediaPicker = true
            } label: {
                if let thumbnail = addPostVM.thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .shadow(radius: 8)
                } else {
                    Image(systemName: "square.stack.fill")
                        .resizable()
                        .frame(width: 60, height: 80)
                        .foregroundColor(Color(uiColor: .systemGray).opacity(0.6))
                }
            }
        }
        .padding()
    }
    
    private var tagPeopleView: some View {
        TextField("Tag People", text: $addPostVM.tagPeopleQuery)
            .focused($isKeyboardActive)
    }
    
    private var addLocationView: some View {
        Button {
            addPostVM.showLocationSearcher = true
        } label: {
            Text(addPostVM.location.isEmpty ? "Add Location" : addPostVM.location)
        }
    }
    
    private var addPostButton: some View {
        Button {
            print("DEBUG: Make new Post")
            addPostVM.createNewPost { success in
                if success {
                    print("DEBUG: Success, Posted")
                } else {
                    print("DEBUG: Error, Couldn't post")
                }
            }
        } label: {
            HStack {
                Spacer()
                ZStack {
                    if addPostVM.showCreatingProgress {
                        ProgressView()
                            .dynamicTypeSize(.xxxLarge)
                    } else {
                        Text("Post")
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(flixColor: .darkOlive))
                Spacer()
            }
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .disabled(!addPostVM.isAllAvailable())
    }
    
    private var newPostAndAddButton: some View {
        VStack {
            postDetailsView
            
            Spacer()
            
            addPostButton
                .padding(.vertical, 8)
        }
    }
}

struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
            .environmentObject(AddPostViewModel())
    }
}
