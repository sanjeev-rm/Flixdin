//
//  GenderView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 27/10/23.
//

import SwiftUI

struct GenderView: View {
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    /// The variable that decides wether the signUpViewModel.errorMessage is shown or not
    @State var showAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToBioView) {
                BioView()
                    .environmentObject(signUpViewModel)
            }
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension GenderView {
    
    /// The base View
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleAndSubtitle
            
            VStack {
                VStack {
                    Divider()
                    
                    mainDomainText
                    
                    Divider()
                }
                
                domainPicker
                
                nextButton
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and Subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Gender")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            VStack(alignment: .leading, spacing: 3) {
                Text("To which gender identity do you most identify?")
                    .font(.system(size: 15))
            }
        }
    }
    
    /// The main domain text
    private var mainDomainText: some View {
        HStack {
            Text("Selected")
                .font(.system(size: 17, weight: .thin))
            Spacer()
            Text(signUpViewModel.gender.rawValue)
                .font(.system(size: 17))
                .foregroundColor(Color(flixColor: .olive))
        }
    }
    
    /// The domain picker
    private var domainPicker: some View {
        Picker("Select Gender", selection: $signUpViewModel.gender) {
            ForEach(Gender.allCases, id: \.self) { gender in
                Text(gender.rawValue)
            }
        }
        .pickerStyle(.wheel)
    }
    
    /// The next button
    private var nextButton: some View {
        FlixdinButton(labelText: "Next", showProgress: signUpViewModel.showUpdatingGenderProgress) {
            signUpViewModel.updateUserGender { success in
                if success {
                    DispatchQueue.main.async {
                        // Navigate to BioView
                        signUpViewModel.navigateToBioView = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            }
        }
//        Button {
//            signUpViewModel.updateUserGender { success in
//                if success {
//                    DispatchQueue.main.async {
//                        // Navigate to BioView
//                        signUpViewModel.navigateToBioView = true
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        showAlert = true
//                    }
//                }
//            }
//        } label: {
//            ZStack {
//                if signUpViewModel.showUpdatingGenderProgress {
//                    ProgressView()
//                } else {
//                    Text("Next")
//                }
//            }
//            .font(.system(size: 22))
//            .foregroundColor(.init(flixColor: .darkOlive))
//            .frame(height: 40)
//            .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    GenderView()
        .environmentObject(SignUpViewModel())
}
