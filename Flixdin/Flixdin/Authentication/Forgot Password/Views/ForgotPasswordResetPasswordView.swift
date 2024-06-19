//
//  ForgotPasswordResetPasswordView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct ForgotPasswordResetPasswordView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @EnvironmentObject var forgotPasswordViewModel: ForgotPasswordViewModel
    
    @State var showPassword: Bool = false
    @State var showConfirmPassword: Bool = false
    
    @FocusState var focusField: FocusField?
    
    enum FocusField {
        case password
        case confirmPassword
    }
    
    var body: some View {
        baseView
    }
}



extension ForgotPasswordResetPasswordView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            passwordFields

            resetPasswordButton

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Create a password")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Create a password of at least 8 characters to secure your account.")
                .font(.system(size: 15))
        }
    }
    
    /// The password fields
    private var passwordFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            securePasswordField("New password", text: $forgotPasswordViewModel.password, showPassword: $showPassword, focused: .password, nextFocus: .confirmPassword, submitLabel: .next)
            securePasswordField("Confirm password", text: $forgotPasswordViewModel.confirmPassword, showPassword: $showConfirmPassword, focused: .confirmPassword, submitLabel: .done)
        }
    }
    
    /// The secure password field
    /// - parameter title: the title of the field
    /// - parameter text: the string value that stores the field value
    /// - parameter showPassword: the boolean value to set whether the password is showing or not
    /// - parameter focused: the field this is being focused on
    /// - parameter nextFocus: the field that is to be focused when this is submitted
    /// - parameter submitLabel: the type of submit label in the keyboard for this field
    private func securePasswordField(_ title: String, text: Binding<String>, showPassword: Binding<Bool>, focused: FocusField, nextFocus: FocusField? = nil, submitLabel: SubmitLabel = .next) -> some View {
        ZStack(alignment: .trailing) {
            if showPassword.wrappedValue {
                TextField(title, text: text)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(16)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 3)
                            .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
                    )
                    .focused($focusField, equals: focused)
                    .submitLabel(submitLabel)
                    .onSubmit {
                        focusField = nextFocus
                    }
            } else {
                SecureField(title, text: text)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(16)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 3)
                            .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
                    )
                    .focused($focusField, equals: focused)
                    .submitLabel(submitLabel)
                    .onSubmit {
                        focusField = nextFocus
                    }
            }
            
            // The show password button
            Button {
                showPassword.wrappedValue.toggle()
            } label: {
                Image(systemName: showPassword.wrappedValue ? "eye" : "eye.slash")
                    .background(Color(flixColor: .backgroundPrimary))
                    .imageScale(.large)
                    .foregroundColor(.init(flixColor: .olive))
                    .padding(.trailing, 16)
            }
        }
    }
    
    /// The reset button
    private var resetPasswordButton: some View {
        FlixdinButton(labelText: "Reset") {
            // MARK: Send email and new passwords to backend
            // Dismiss Forgot password view
            authenticationViewModel.showForgotPasswordView = false
        }
//        Button {
//            // MARK: Send email and new passwords to backend
//            // Dismiss Forgot password view
//            authenticationViewModel.showForgotPasswordView = false
//        } label: {
//            Text("Reset")
//                .font(.system(size: 22))
//                .foregroundColor(.init(flixColor: .darkOlive))
//                .frame(height: 40)
//                .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
    }
}

struct ForgotPasswordResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordResetPasswordView()
                .environmentObject(ForgotPasswordViewModel())
        }
    }
}
