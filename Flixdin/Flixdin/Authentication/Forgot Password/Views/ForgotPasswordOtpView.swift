//
//  ForgotPasswordOtpView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct ForgotPasswordOtpView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @EnvironmentObject var forgotPasswordViewModel: ForgotPasswordViewModel
    
    var body: some View {
        if #available(iOS 16.0, *) {
            baseView
                .navigationDestination(isPresented: $forgotPasswordViewModel.navigateToResetPassword) {
                    ForgotPasswordResetPasswordView()
                        .environmentObject(forgotPasswordViewModel)
                }
        } else {
            baseView
                .background(
                    Group {
                        NavigationLink(destination: ForgotPasswordResetPasswordView().environmentObject(forgotPasswordViewModel),
                                       isActive: $forgotPasswordViewModel.navigateToResetPassword) {
                            EmptyView()
                        }
                    }
                )
        }
    }
}



extension ForgotPasswordOtpView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            emailField
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter the received OTP")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("An OTP was sent to you on your registered email-id")
                .font(.system(size: 15))
        }
    }
    
    /// The email field
    private var emailField: some View {
        TextField("OTP", text: $forgotPasswordViewModel.email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
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
        Button {
            // Navigate to ResetPasswordVeiw
            // MARK: Send otp to backend for verification
            forgotPasswordViewModel.navigateToResetPassword = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ForgotPasswordOtpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordOtpView()
                .environmentObject(ForgotPasswordViewModel())
        }
    }
}
