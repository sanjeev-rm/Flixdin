//
//  CreateUsernameView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 06/07/23.
//

import SwiftUI

struct CreateUsernameView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToBirthdayView) {
                BirthdayView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension CreateUsernameView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            title

            userNameField

            nextButton

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var title: some View {
        Text("Create a username")
            .font(.system(size: 24, weight: .bold, design: .default))
    }
    
    private var userNameField: some View {
        ZStack(alignment: .trailing) {
            TextField("Enter username", text: $signUpViewModel.username)
                .textContentType(.name)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.default)
                .padding(16)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
                )
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 27, weight: .semibold))
                .foregroundColor(signUpViewModel.isUsernameAvailable ? Color(uiColor: .systemGreen) : .gray.opacity(0.5))
                .background(Color(flixColor: .backgroundPrimary))
                .padding(.trailing, 8)
        }
    }
    
    private var nextButton: some View {
        // MARK: Disable the button until entered username is available
        FlixdinButton(labelText: "Next") {
            // MARK: Navigate to TermsAndConditionsView
            signUpViewModel.navigateToBirthdayView = true
        }
        .disabled(isNextButtonDisabled())
//        Button {
//            // MARK: Navigate to TermsAndConditionsView
//            signUpViewModel.navigateToBirthdayView = true
//        } label: {
//            Text("Next")
//                .font(.system(size: 22))
//                .foregroundColor(.init(flixColor: .darkOlive))
//                .frame(height: 40)
//                .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
//        .disabled(isNextButtonDisabled())
    }
}

extension CreateUsernameView {
    
    func isNextButtonDisabled() -> Bool {
        // Currently only verifying if it's empty or not
        // In future we need to verify if it's available or not, everytime the user chages the name it sends to server to check if the username is available
        // Only allow next if available
        return signUpViewModel.username.isEmpty
    }
}

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateUsernameView()
                .environmentObject(SignUpViewModel())
        }
    }
}
