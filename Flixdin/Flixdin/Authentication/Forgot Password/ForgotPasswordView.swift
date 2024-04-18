//
//  ForgotPasswordView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @ObservedObject var forgotPasswordViewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
    
    var body: some View {
        NavigationStack {
            ForgotPasswordEmailView()
                .environmentObject(forgotPasswordViewModel)
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(AuthenticationViewModel())
    }
}
