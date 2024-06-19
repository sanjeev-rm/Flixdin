//
//  ForgotPasswordEmailView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct ForgotPasswordEmailView: View {
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @ObservedObject var forgotPasswordViewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()
    
    var body: some View {
        baseView
    }
}



extension ForgotPasswordEmailView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            emailField
            
            receiveEmailButton
            
            loginButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .sheet(isPresented: $forgotPasswordViewModel.showAlert) {
            AlertSheetView(imageSystemName: "exclamationmark.triangle.fill", alertMessage: "Unable to send email. \(forgotPasswordViewModel.errorMessage)", showAlert: $forgotPasswordViewModel.showAlert)
                .presentationDetents([.fraction(1/3)])
        }
    }
    
    /// The title and subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Forgot your password?")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("You will receive a link on your registered email-id for you to reset your password")
                .font(.system(size: 15))
        }
    }
    
    /// The email field
    private var emailField: some View {
        TextField("Email", text: $forgotPasswordViewModel.email)
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
    
    /// The receive OTP button
    private var receiveEmailButton: some View {
        FlixdinButton(labelText: "Receive Email", showProgress: forgotPasswordViewModel.showProgress) {
            Task {
                forgotPasswordViewModel.showProgress = true
                do {
                    try await forgotPasswordViewModel.resetPassword(email: forgotPasswordViewModel.email)
                    loginViewModel.presentForgotPasswordEmailSentAlert()
                    authenticationViewModel.showForgotPasswordView = false
                    forgotPasswordViewModel.showProgress = false
                } catch {
                    print("DEBUG: " + error.localizedDescription)
                    forgotPasswordViewModel.showProgress = false
                    forgotPasswordViewModel.showAlert = true
                    forgotPasswordViewModel.errorMessage = error.localizedDescription
                }
            }
        }
        .disabled(isReceiveEmailButtonDisabled())
//        Button {
//            Task {
//                forgotPasswordViewModel.showProgress = true
//                do {
//                    try await forgotPasswordViewModel.resetPassword(email: forgotPasswordViewModel.email)
//                    loginViewModel.presentForgotPasswordEmailSentAlert()
//                    authenticationViewModel.showForgotPasswordView = false
//                    forgotPasswordViewModel.showProgress = false
//                } catch {
//                    print("DEBUG: " + error.localizedDescription)
//                    forgotPasswordViewModel.showProgress = false
//                    forgotPasswordViewModel.showAlert = true
//                    forgotPasswordViewModel.errorMessage = error.localizedDescription
//                }
//            }
//        } label: {
//            ZStack {
//                if forgotPasswordViewModel.showProgress {
//                    ProgressView()
//                } else {
//                    Text("Receive Email")
//                }
//            }
//            .font(.system(size: 22))
//            .foregroundColor(.init(flixColor: .darkOlive))
//            .frame(height: 40)
//            .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
//        .disabled(isReceiveEmailButtonDisabled())
    }
    
    /// The login button
    private var loginButton: some View {
        Button {
            // Dismiss the fogot password view
            authenticationViewModel.showForgotPasswordView = false
        } label: {
            HStack {
                Spacer()
                Text("Remembered the password?")
                    .foregroundColor(.primary)
                Text("Login")
                    .foregroundColor(Color(flixColor: .olive))
                Spacer()
            }
            .font(.system(size: 15))
        }
    }
}

extension ForgotPasswordEmailView {
    
    func isReceiveEmailButtonDisabled() -> Bool {
        // Need to use regex to verify if it's a valid emailID
        return forgotPasswordViewModel.email.isEmpty
    }
}

struct ForgotPasswordEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordEmailView()
                .environmentObject(ForgotPasswordViewModel())
                .environmentObject(LoginViewModel())
        }
    }
}
