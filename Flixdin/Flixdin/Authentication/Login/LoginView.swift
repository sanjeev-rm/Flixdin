//
//  LoginView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    @ObservedObject var loginViewModel: LoginViewModel = LoginViewModel()
    
    /// The field that is currently focused
    @FocusState private var focusField: FocusField?
    
    /// Different fields in the view
    private enum FocusField {
        case email
        case password
    }
    
    var body: some View {
        baseView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .fullScreenCover(isPresented: $authenticationViewModel.showSignUpView) {
                focusField = nil
            } content: {
                SignUpView()
            }
            .fullScreenCover(isPresented: $authenticationViewModel.showForgotPasswordView) {
                focusField = nil
            } content: {
                ForgotPasswordEmailView()
                    .environmentObject(loginViewModel)
            }
            .sheet(isPresented: $loginViewModel.showEmailSentAlert) {
                AlertSheetView(imageSystemName: "checkmark", imageForegroundColor: Color(.systemGreen), alertMessage: "An email has been sent to given mail-id, please reset your password there", showAlert: $loginViewModel.showEmailSentAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}





extension LoginView {
    
    private var baseView: some View {
        VStack {
            headlineText
                .padding(.top, 70)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack {
                        if loginViewModel.showErrorMessage {
                            Text(loginViewModel.errorMessage)
                                .font(.footnote.bold())
                                .foregroundColor(Color(.systemRed))
                        }
                        emailPasswordFields
                    }
                    loginSignupButtons
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(focusField == nil)
            .scrollDismissesKeyboard(.interactively)
        }
    }
    
    /// The headline text Flixdin
    private var headlineText: some View {
        Text("flixdin")
            .font(.system(size: 64, weight: .semibold, design: .default))
            .foregroundColor(Color(flixColor: .lightOlive))
    }
    
    /// The email & password text fields
    private var emailPasswordFields: some View {
        VStack(spacing:16) {
            TextField("Email", text: $loginViewModel.email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .padding(16)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.init(flixColor: .textFieldBorderSecondary))
                )
                .focused($focusField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusField = .password
                }
            
            VStack(spacing: 8) {
                securePasswordView
                
                HStack {
                    Spacer()
                    Button {
                        // show ForgotPasswordView
                        authenticationViewModel.showForgotPasswordView = true
                    } label: {
                        Text("Forgot password")
                            .foregroundColor(.init(flixColor: .olive))
                            .font(.system(size: 15))
                    }
                }
            }
        }
    }
    
    /// The Secure Password View
    private var securePasswordView: some View {
        ZStack(alignment: .trailing) {
            if loginViewModel.showPassword {
                TextField("Password", text: $loginViewModel.password)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(16)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 3)
                            .foregroundColor(.init(flixColor: .textFieldBorderSecondary))
                    )
                    .focused($focusField, equals: .password)
                    .submitLabel(.return)
                    .onSubmit {
                        focusField = nil
                    }
            } else {
                SecureField("Password", text: $loginViewModel.password)
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(16)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(lineWidth: 3)
                            .foregroundColor(.init(flixColor: .textFieldBorderSecondary))
                    )
                    .focused($focusField, equals: .password)
                    .submitLabel(.return)
                    .onSubmit {
                        focusField = nil
                    }
            }
            
            Button {
                loginViewModel.showPassword.toggle()
            } label: {
                Image(systemName: loginViewModel.showPassword ? "eye" : "eye.slash")
                    .background(Color(flixColor: .backgroundPrimary))
                    .imageScale(.large)
                    .foregroundColor(.init(flixColor: .olive))
                    .padding(.trailing, 16)
            }
        }
    }
    
    /// The login & signup buttons
    private var loginSignupButtons: some View {
        VStack(spacing: 16) {
            
            // Login Button
            FlixdinButton(labelText: "Login", showProgress: loginViewModel.showProgress) {
                loginViewModel.login { success in
                    if success {
                        authenticationViewModel.isLoggedIn = true
                    }
                }
            }
//            Button {
//                loginViewModel.login { success in
//                    if success {
//                        authenticationViewModel.isLoggedIn = true
//                    }
//                }
//            } label: {
//                ZStack {
//                    if loginViewModel.showProgress {
//                        ProgressView()
//                    } else {
//                        Text("Login")
//                    }
//                }
//                .font(.system(size: 22))
//                .foregroundColor(.init(flixColor: .darkOlive))
//                .frame(height: 40)
//                .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
            
            // The OR seperator
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 3)
                
                Text("OR")
                    .font(.system(size: 24, weight: .heavy))
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 3)
            }
            .foregroundStyle(.accent)
            .padding([.leading, .trailing], 44)
            
            // The SignUp button
            VStack(spacing: 8) {
                Text("New here?")
                    .foregroundColor(.init(flixColor: .olive))
                    .font(.system(size: 15))
                
                FlixdinButton(labelText: "Sign Up") {
                    authenticationViewModel.showSignUpView = true
                }
                
//                Button {
//                    // Show to SignUp View
//                    authenticationViewModel.showSignUpView = true
//                } label: {
//                    Text("Sign Up")
//                        .font(.system(size: 22))
//                        .foregroundColor(.init(flixColor: .darkOlive))
//                        .frame(height: 40)
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(.borderedProminent)
            }
        }
    }
}





struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
