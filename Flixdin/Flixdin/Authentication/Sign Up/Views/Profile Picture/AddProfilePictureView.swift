//
//  AddProfilePictureView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 06/07/23.
//

import SwiftUI

struct AddProfilePictureView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    @State var showImageSourceOptions: Bool = false
    
    @State var imageSourceType: UIImagePickerController.SourceType?
    
    @State private var showImagePicker: Bool = false
    
    @State var showSignedUpAlert: Bool = true
    
    @State var showImageAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToGenderView) {
                GenderView()
                    .environmentObject(signUpViewModel)
            }
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $showSignedUpAlert) {
                AlertSheetView(imageSystemName: "checkmark", imageForegroundColor: Color(.systemGreen), alertMessage: "Successfully Signed Up, Just complete your profile and you're good to go!", showAlert: $showSignedUpAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension AddProfilePictureView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle

            profilePicture
            
            Spacer()

            addpictureAndSkipButtons
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .confirmationDialog("source", isPresented: $showImageSourceOptions, titleVisibility: .hidden) {
            
            Button("Choose a photo") {
                // Choose from gallery
                imageSourceType = nil
                showImagePicker = true
            }
            
            Button("Take a photo") {
                // Open camera and click photo
                imageSourceType = .camera
                showImagePicker = true
            }
        }
        .sheet(isPresented: $showImageAlert) {
            AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showImageAlert)
                .presentationDetents([.fraction(1/3)])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $signUpViewModel.profileImage, sourceType: imageSourceType)
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add a profile picture")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Add a profile picture so that your friends can see that it’s you!")
                .font(.system(size: 15))
        }
    }
    
    private var profilePicture: some View {
        HStack {
            Spacer()
            Image(uiImage: signUpViewModel.profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .onTapGesture {
                    showImageSourceOptions = true
                }
            Spacer()
        }
    }
    
    private var addpictureAndSkipButtons: some View {
        VStack(spacing: 16) {
            addPictureButton
            skipButton
        }
    }
    
    private var addPictureButton: some View {
        Button {
            // MARK: Choose picture
            showImageSourceOptions = true
        } label: {
            Text(signUpViewModel.profileImage == UIImage(flixImage: .defaultProfilePicture)! ? "Add picture" : "Change picture")
                .font(.system(size: 17))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .tint(.accent)
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
    }
    
    private var skipButton: some View {
        
        Button {
            // MARK: Do Nothing, Skip, Navigate to AddDomainView
            
            if signUpViewModel.profileImage != UIImage(flixImage: .defaultProfilePicture) {
                signUpViewModel.uploadPfp { success in
                    if success {
                        DispatchQueue.main.async {
                            signUpViewModel.navigateToGenderView = true
                        }
                    } else {
                        showImageAlert = true
                    }
                }
            } else {
                signUpViewModel.navigateToGenderView = true
            }
        } label: {
            Text(signUpViewModel.profileImage == UIImage(flixImage: .defaultProfilePicture)! ? "Skip" : "Next")
                .font(.system(size: 17))
                .foregroundColor(.primary.opacity(0.5))
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.primary.opacity(0.3))
                )
        }
    }
}

struct AddProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddProfilePictureView()
                .environmentObject(SignUpViewModel())
        }
    }
}
