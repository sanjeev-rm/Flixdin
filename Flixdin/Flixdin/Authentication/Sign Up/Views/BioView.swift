//
//  BioView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 27/10/23.
//

import SwiftUI

struct BioView: View {
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    /// The variable that decides wether the signUpViewModel.errorMessage is shown or not
    @State var showAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToAddDomain) {
                AddDomainView()
                    .environmentObject(signUpViewModel)
            }
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension BioView {
    
    /// The base View
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleAndSubtitle
            
            descriptionTextField
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and Subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add Description")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Describe yourself.")
                    .font(.system(size: 15))
                Text("This will be presented in your profile page.")
                    .font(.system(size: 15))
            }
        }
    }
    
    /// The bio textfield
    private var descriptionTextField: some View {
        TextField("Description", text: $signUpViewModel.bio, axis: .vertical)
            .multilineTextAlignment(.leading)
            .padding(16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
            )
    }
    
    /// The next button
    private var nextButton: some View {
        FlixdinButton(labelText: "Next", showProgress: signUpViewModel.showUpdatingBioProgress) {
            signUpViewModel.updateUserBio { success in
                if success {
                    DispatchQueue.main.async {
                        // Navigate to AddDomainView
                        signUpViewModel.navigateToAddDomain = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            }
        }
//        Button {
//            signUpViewModel.updateUserBio { success in
//                if success {
//                    DispatchQueue.main.async {
//                        // Navigate to AddDomainView
//                        signUpViewModel.navigateToAddDomain = true
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        showAlert = true
//                    }
//                }
//            }
//        } label: {
//            ZStack {
//                if signUpViewModel.showUpdatingBioProgress {
//                    ProgressView()
//                } else {
//                    Text("Next")
//                }
//            }
//            .font(.system(size: 22))
//            .foregroundColor(.init(flixColor: .darkOlive))
//            .frame(height: 40)
//            .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    BioView()
        .environmentObject(SignUpViewModel())
}
