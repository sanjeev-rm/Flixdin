//
//  MobileView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct MobileView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToMobileVerificationView) {
                MobileVerificationView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension MobileView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle

            mobileFieldWithFooter

            nextButton

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What is your mobile number?")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Enter the mobile number where you can be contacted. No one will see this on your profile.")
                .font(.system(size: 15))
        }
    }
    
    private var mobileFieldWithFooter: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Mobile number", text: $signUpViewModel.mobile)
                .textContentType(.telephoneNumber)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.phonePad)
                .padding(16)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
                )
            
            Text("You may receive SMS notifications from us for security and login purposes.")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
    
    private var nextButton: some View {
        Button {
            // MARK: Navigate to MobileVerificationView
            signUpViewModel.navigateToMobileVerificationView = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(signUpViewModel.mobile.count != 10)
    }
}

struct MobileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MobileView()
                .environmentObject(SignUpViewModel())
        }
    }
}
