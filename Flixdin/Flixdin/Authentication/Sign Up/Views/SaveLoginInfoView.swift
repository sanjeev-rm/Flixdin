//
//  SaveLoginInfoView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct SaveLoginInfoView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToWelcomeView) {
                WelcomeView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension SaveLoginInfoView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            saveButton
            
            notNowButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Save your login info?")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("We’ll save the login info, so you won’t need to enter it the next time you log in.")
                .font(.system(size: 15))
        }
    }
    
    private var saveButton: some View {
        Button {
            // Save login info to user defaults and navigate
            // Meaning keep user loggedin, persistent
            // MARK: Navigate to WelcomeView
//            if signUpViewModel.checkVerificationStatus() {
//                signUpViewModel.navigateToWelcomeView = true
//            } else {
//                print("Email not verified.")
//            }
            signUpViewModel.saveLoginInfo = true
            signUpViewModel.navigateToWelcomeView = true
        } label: {
            Text("Save")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accent)
    }
    
    private var notNowButton: some View {
        Button {
            signUpViewModel.saveLoginInfo = false
            signUpViewModel.navigateToWelcomeView = true
        } label: {
            Text("Not Now")
                .font(.system(size: 22))
                .foregroundColor(.primary.opacity(0.3))
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.primary.opacity(0.3))
                )
        }
    }
}

struct SaveLoginInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SaveLoginInfoView()
                .environmentObject(SignUpViewModel())
        }
    }
}
