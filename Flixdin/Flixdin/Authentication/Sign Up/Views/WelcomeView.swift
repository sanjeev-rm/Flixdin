//
//  WelcomeView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            
            Spacer()
            
            VStack {
                Text("Welcome")
                Text("to")
                Text("flixdin")
            }
            .font(.system(size: 44, weight: .bold, design: .default))
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(flixColor: .lightOlive))
                .font(.system(size: 200))
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    authenticationViewModel.temporaryIsLoggedIn = true
                    authenticationViewModel.showSignUpView = false
                    if signUpViewModel.saveLoginInfo {
                        authenticationViewModel.isLoggedIn = true
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(SignUpViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}
