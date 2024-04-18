//
//  CreatePasswordView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    @State var showPassword: Bool = false
    @State var showReEnterPassword: Bool = false
    
    @FocusState var focusField: FocusField?
    
    enum FocusField {
        case password
        case reEnterPassword
    }
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToMobileView) {
                MobileView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension CreatePasswordView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            passwordFields

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
            Text("Create a password")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Create a password of at least 8 characters to secure your account.")
                .font(.system(size: 15))
        }
    }
    
    /// The password fields
    private var passwordFields: some View {
        VStack(alignment: .leading, spacing: 16) {
            securePasswordField("Enter password", text: $signUpViewModel.password, showPassword: $showPassword, focused: .password, nextFocus: .reEnterPassword, submitLabel: .next)
            securePasswordField("Re-enter password", text: $signUpViewModel.confirmPassword, showPassword: $showReEnterPassword, focused: .reEnterPassword, submitLabel: .done)
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
            ZStack {
                if showPassword.wrappedValue {
                    TextField(title, text: text)
                } else {
                    SecureField(title, text: text)
                }
            }
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
    
    /// The next button
    private var nextButton: some View {
        Button {
            // MARK: Navigate to BirthdayView
            signUpViewModel.user = User(mailID: signUpViewModel.email, password: signUpViewModel.confirmPassword)
            signUpViewModel.navigateToMobileView = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isNextButtonDisabled())
    }
}

extension CreatePasswordView {
    
    func isNextButtonDisabled() -> Bool {
        return signUpViewModel.password.count < 8 || signUpViewModel.confirmPassword.count < 8 || signUpViewModel.password != signUpViewModel.confirmPassword
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePasswordView()
                .environmentObject(SignUpViewModel())
        }
    }
}
