//
//  AuthenticationView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import SwiftUI

struct AuthenticationView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            NavigationStack {
                
                LoginView()
            
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            authViewModel.isLoggedIn = authUser != nil
            authViewModel.temporaryIsLoggedIn = authUser != nil
        }
//        .fullScreenCover(isPresented: $authViewModel.showLoginView) {
//            NavigationStack {
//                LoginView()
//                    .environmentObject(authViewModel)
//            }
//        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(AuthenticationViewModel())
    }
}
