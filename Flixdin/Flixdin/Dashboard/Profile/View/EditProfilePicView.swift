//
//  EditProfilePicView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 30/10/23.
//

import SwiftUI

struct EditProfilePicView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
//    @State var profilePic: Image = Image(systemName: "person.crop.circle.fill")
    
    @State var profilePic: UIImage = UIImage()
    
    @State var imageSourceType: UIImagePickerController.SourceType?
    
    @State private var showImagePicker: Bool = false
    
//    @State var profilePicUpdated: Bool = false
    
//    func loadProfilePic() {
//        UIImage.getUIImageFromURL(urlString: profileViewModel.profilePicUrl) { loadedImage in
//            DispatchQueue.main.async {
//                if let image = loadedImage {
//                    self.profilePic = image
//                } else {
//                    self.profilePic = UIImage(systemName: "person.crop.circle.fill")!
//                }
//            }
//        }
//    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AsyncImage(url: URL(string: profileViewModel.profilePicUrl)) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color(.secondarySystemFill))
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(.secondarySystemFill))
                    .clipShape(Circle())
                }
                .listRowBackground(Color(.clear))
                
                Section {
                    Button {
                        imageSourceType = nil
                        showImagePicker = true
                    } label: {
                        Label("Choose Photo", systemImage: "photo")
                    }
                    .frame(height: 38)
                    
                    Button {
                        imageSourceType = .camera
                        showImagePicker = true
                    } label: {
                        Label("Take Photo", systemImage: "camera")
                    }
                    .frame(height: 38)
                    
                    Button(role: .destructive) {
                        // Also updated profile pic URL from the data base
                        profileViewModel.deleteProfilePicUrl { success in
                            if success {
//                                loadProfilePic()
                                print("DEBUG: Deleted profile pic url")
                            } else {
                                print("DEBUG: Unable to delete profile pic url")
                            }
                        }
                    } label: {
                        Label("Delete Photo", systemImage: "trash")
                            .foregroundColor(Color(.systemRed))
                    }
                    .frame(height: 38)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
            .navigationTitle("Edit Photo")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profilePic, sourceType: imageSourceType)
            }
            .onChange(of: profilePic, perform: { value in
                profileViewModel.updateProfilePic(uiImage: profilePic) { success in
                    if success {
                        print("DEBUG: Updated Profile Pic")
                    } else {
                        print("DEBUG: Unable to update profile pic")
                    }
                }
            })

        }
    }
}

#Preview {
    EditProfilePicView()
        .environmentObject(ProfileViewModel())
}
