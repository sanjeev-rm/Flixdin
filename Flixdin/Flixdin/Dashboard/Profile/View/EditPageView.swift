//
//  ProfilePageView.swift
//  FlixDinApp
//
//  Created by shikhar on 04/07/23.
//  Modified by KAARTHIKEYA K on 07/07/23
//  Modified by Sanjeev R M on 04/10/23
//

import SwiftUI

struct EditPageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State var showAlert: Bool = false
    
    @State var showEditProfilePicView: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    ProfilePicView
                    
                    if profileViewModel.domain == .productionHouse {
                        productionHouseLabel
                    }
                    
                    textfieldInputView(title: "Name", text: $profileViewModel.name)
                    
                    textfieldInputView(title: "Username", text: $profileViewModel.username)
                    
                    textfieldInputView(title: "Bio", text: $profileViewModel.description)
                    
                    if profileViewModel.domain != .productionHouse {
                        
                        GenderView
                        
                        EditDomainInsideProfileView
                        
                        EditSkillsInsideProfileView
                    }
                }
                
                EditPortfolioInsideProfileView
                    .padding(.top)
                
                Spacer()
                
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        // Dismiss View and don't Save.
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(profileViewModel.showUpdatingUserProfileProgress)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        profileViewModel.updateUserProfileInfo { success in
                            if success {
                                // Done and Save.
                                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                    profileViewModel.showUpdatingUserProfileProgress = false
                                }
                            } else {
                                showAlert = true
                            }
                        }
                    } label: {
                        if profileViewModel.showUpdatingUserProfileProgress {
                            ProgressView()
                        } else {
                            Text("Update")
                        }
                    }
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: profileViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/5)])
            }
            .fullScreenCover(isPresented: $showEditProfilePicView) {
                EditProfilePicView()
                    .environmentObject(profileViewModel)
                    .interactiveDismissDisabled()
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

extension EditPageView {
    
    private var ProfilePicView: some View {
        VStack(spacing: 16) {
            ProfilePictureView(imageUrl: URL(string: profileViewModel.profilePicUrl), borderColor: Color(flixColor: .lightOlive), borderWidth: 3, imageWidth: 80, imageHeight: 80)
            
            Button {
                //
                withAnimation(.easeInOut) {
                    showEditProfilePicView = true
                }
            } label: {
                Text("Edit profile pic")
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top)
    }
    
    private var GenderView: some View {
        
        HStack {
            Text("Gender")
                .font(.subheadline.weight(.semibold))
            
            Spacer()
            
            Picker("", selection: $profileViewModel.gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.vertical, 8)
    }
    
    private var EditDomainInsideProfileView: some View {
        
        NavigationLink{
            EditDomainView()
                .environmentObject(profileViewModel)
        } label: {
            navigationLinkLabel("Domain", selectedValue: profileViewModel.domain.title)
        }
    }
    
    private var EditPortfolioInsideProfileView: some View {
        
        NavigationLink{
            EditPortfolioView()
                .environmentObject(profileViewModel)
        } label: {
            navigationLinkLabel("Portfolio", topDivider: profileViewModel.domain == .productionHouse)
        }
    }
    
    private var EditSkillsInsideProfileView: some View {
        
        NavigationLink{
            EditOtherSkillsView()
                .navigationTitle("Other Skills")
                .navigationBarTitleDisplayMode(.inline)
                .environmentObject(profileViewModel)
        } label: {
            navigationLinkLabel("Other Skills", selectedValue: "\(profileViewModel.otherSkill1.title), \(profileViewModel.otherSkill2.title)")
        }
    }
    
    private var productionHouseLabel: some View {
        VStack {
            Divider()
            Text("Production House")
                .font(.headline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            Divider()
        }
    }
    
    private func navigationLinkLabel(_ title: String, selectedValue: String = "", topDivider: Bool = false, bottomDivider: Bool = true) -> some View {
        VStack(spacing: 11) {
            if topDivider {
                Divider()
            }
            HStack{
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(selectedValue)
                    .multilineTextAlignment(.trailing)
                
                Image(systemName: "chevron.right")
            }
            if bottomDivider {
                Divider()
            }
        }
    }
    
    private func textfieldInputView(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            
            TextField("",text: text, axis: .vertical)
                .font(.system(.callout, design: .monospaced))
                .padding(6)
                .background(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
                .foregroundColor(.secondary)
        }
    }
}

struct EditPageView_Previews: PreviewProvider {
    static var previews: some View {
        EditPageView()
            .environmentObject(ProfileViewModel())
    }
}
