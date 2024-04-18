//
//  TermsAndConditionsView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 06/07/23.
//

import SwiftUI

struct TermsAndConditionsView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    /// The variable that decides wether the signUpViewModel.errorMessage is shown or not
    @State var showAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToAddProfilePictureView) {
                AddProfilePictureView()
                    .environmentObject(signUpViewModel)
            }
            .onAppear {
                signUpViewModel.userAcceptedTermsAndConditions = false
            }
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension TermsAndConditionsView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            iAgreeButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agree to flixdin terms and policies")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            VStack(alignment: .leading, spacing: 16) {
                Text("People who use our service may have already entered your number.")
                Text("By clicking on I agree, you agree to create an account and to Instagram. Learn More")
                Text("The Privacy Policy describes the ways we can use the information we collect when you create an account. For example, we use this information to provide, personalize and improve our products, including ads.")
            }
            .font(.system(size: 15))
        }
    }
    
    private var iAgreeButton: some View {
        VStack {
            Button {
                // MARK: Send to firebase and sign up
                signUpViewModel.signUp { success in
                    if success {
                        DispatchQueue.main.async {
                            signUpViewModel.userAcceptedTermsAndConditions = true
                            signUpViewModel.navigateToAddProfilePictureView = true
                        }
                    } else {
                        showAlert = true
                    }
                }
                
            } label: {
                ZStack {
                    if signUpViewModel.showSigningUpProgress {
                        ProgressView()
                    } else {
                        Text("Agree")
                    }
                }
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            VStack(spacing: 8) {
                Text("Agree and Sign up")
                Text("A Verification Mail will be sent to the registered email address. Verify to proceed.")
            }
            .multilineTextAlignment(.center)
            .font(.caption)
            .foregroundColor(Color(.secondaryLabel))
        }
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TermsAndConditionsView()
                .environmentObject(SignUpViewModel())
        }
    }
}
