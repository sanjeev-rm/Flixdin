//
//  MobileVerificationView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct MobileVerificationView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToCreateUsernameView) {
                CreateUsernameView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension MobileVerificationView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            otpFieldAndResendOtpButton
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter OTP")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("To confirm your account, please enter the OTP that we have sent your mobile")
                .font(.system(size: 15))
        }
    }
    
    private var otpFieldAndResendOtpButton: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Enter OTP", text: $signUpViewModel.otp)
                .textContentType(.oneTimeCode)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.numberPad)
                .padding(16)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 3)
                        .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
                )
            
            HStack {
                Spacer()
                Button {
                    // Resend OTP
                } label: {
                    Text("Re-send OTP")
                        .font(.system(size: 15))
                }
            }
        }
    }
    
    private var nextButton: some View {
        Button {
            // Navigate to NameView
            // MARK: verify OTP
            signUpViewModel.navigateToCreateUsernameView = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(signUpViewModel.otp.isEmpty ||
                  signUpViewModel.otp.count != 6 ||
                  signUpViewModel.otp.contains(where: {!$0.isNumber}))
    }
}

struct MobileVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MobileVerificationView()
                .environmentObject(SignUpViewModel())
        }
    }
}
