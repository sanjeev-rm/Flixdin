//
//  NameView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct NameView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToCreatePasswordView) {
                CreatePasswordView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension NameView {
    
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            title

            nameField

            nextButton

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    private var title: some View {
        Text("What's your name?")
            .font(.system(size: 24, weight: .bold, design: .default))
    }
    
    private var nameField: some View {
        TextField("Name", text: $signUpViewModel.name)
            .textContentType(.name)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .keyboardType(.default)
            .padding(16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 3)
                    .foregroundColor(.init(flixColor: .textFieldBorderPrimary))
            )
    }
    
    private var nextButton: some View {
        FlixdinButton(labelText: "Next") {
            // MARK: Navigate to CreatePasswordView
            signUpViewModel.navigateToCreatePasswordView = true
        }
        .disabled(signUpViewModel.name.isEmpty)
//        Button {
//            // MARK: Navigate to CreatePasswordView
//            signUpViewModel.navigateToCreatePasswordView = true
//        } label: {
//            Text("Next")
//                .font(.system(size: 22))
//                .foregroundColor(.init(flixColor: .darkOlive))
//                .frame(height: 40)
//                .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
//        .disabled(signUpViewModel.name.isEmpty)
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NameView()
                .environmentObject(SignUpViewModel())
        }
    }
}
