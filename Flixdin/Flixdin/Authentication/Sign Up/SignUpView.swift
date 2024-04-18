//
//  SignUpView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI
import UIKit

struct SignUpView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @StateObject var signUpViewModel: SignUpViewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            NavigationStack {
                EmailView()
                    .environmentObject(signUpViewModel)
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            if !signUpViewModel.userAcceptedTermsAndConditions {
                alreadyHaveAnAccountButton
                    .padding()
            }
        }
        .background(Color(flixColor: .backgroundPrimary))
    }
}



extension SignUpView {
    private var alreadyHaveAnAccountButton: some View {
        Button {
            // Dismiss this SignUp View
            authenticationViewModel.showSignUpView = false
        } label: {
            Text("Already have an account?")
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthenticationViewModel())
    }
}



extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
