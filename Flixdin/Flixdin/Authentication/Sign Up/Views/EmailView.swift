//
//  EmailView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct EmailView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToNameView) {
                NameView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension EmailView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            emailFieldWithFooter
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's your email?")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Enter the email where you can be contacted. No one will see this on your profile.")
                .font(.system(size: 15))
        }
    }
    
    private var emailFieldWithFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Email", text: $signUpViewModel.email)
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
            
            Text("You may receive email notifications from us for security and login purposes.")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
    
    private var nextButton: some View {
        Button {
            // Navigate to MobileView
            signUpViewModel.navigateToNameView = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(signUpViewModel.email.isEmpty)
    }
}

extension EmailView {
    
    func isNextButtonDisabled() -> Bool {
        // MARK: Need to verify if the email is valid too and check if it's not used too
        return signUpViewModel.email.isEmpty
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EmailView()
                .environmentObject(SignUpViewModel())
        }
    }
}
