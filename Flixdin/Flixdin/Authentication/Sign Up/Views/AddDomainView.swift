//
//  AddDomainView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct AddDomainView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    /// The variable that decides wether the signUpViewModel.errorMessage is shown or not
    @State var showAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToProductionHouse) {
                ProductionHouseView()
                    .environmentObject(signUpViewModel)
            }
            .navigationDestination(isPresented: $signUpViewModel.navigateToOtherSkillsFromAddDomain) {
                OtherSkillsView()
                    .environmentObject(signUpViewModel)
            }
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension AddDomainView {
    
    /// The base View
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleAndSubtitle
            
            VStack {
                Divider()
                
                mainDomainText
                
                Divider()
            }
            
            domainPicker
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and Subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add Domain")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            VStack(alignment: .leading, spacing: 3) {
                Text("Domain describes your main profession.")
                    .font(.system(size: 15))
                Text("You can only select one domain.")
                    .font(.system(size: 15))
            }
        }
    }
    
    /// The main domain text
    private var mainDomainText: some View {
        HStack {
            Text("Main Domain")
                .font(.system(size: 17, weight: .thin))
            Spacer()
            Text(signUpViewModel.primaryDomain.title)
                .font(.system(size: 17))
                .foregroundColor(Color(flixColor: .olive))
        }
    }
    
    /// The domain picker
    private var domainPicker: some View {
        Picker("Add Domain", selection: $signUpViewModel.primaryDomain) {
            ForEach(Domain.allCases.dropFirst(1), id: \.self) { domain in
                Text(domain.title)
            }
        }
        .pickerStyle(.wheel)
    }
    
    /// The next button
    private var nextButton: some View {
        FlixdinButton(labelText: "Next", showProgress: signUpViewModel.showUpdatingDomainProgress) {
            signUpViewModel.updateUserDomain { success in
                if success {
                    DispatchQueue.main.async {
                        // Navigate to ProductionHouseInfo or OtherSkillsView
                        switch signUpViewModel.primaryDomain {
                        case .productionHouse:
                            // If selected domain is Production House then navigates to ProductionHouseView
                            signUpViewModel.navigateToProductionHouse = true
                        default:
                            // If any other domain is selected then navigates to OtherSkillsView directly
                            signUpViewModel.navigateToOtherSkillsFromAddDomain = true
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            }
        }
        .disabled(signUpViewModel.primaryDomain == .none)
//        Button {
//            signUpViewModel.updateUserDomain { success in
//                if success {
//                    DispatchQueue.main.async {
//                        // Navigate to ProductionHouseInfo or OtherSkillsView
//                        switch signUpViewModel.primaryDomain {
//                        case .productionHouse:
//                            // If selected domain is Production House then navigates to ProductionHouseView
//                            signUpViewModel.navigateToProductionHouse = true
//                        default:
//                            // If any other domain is selected then navigates to OtherSkillsView directly
//                            signUpViewModel.navigateToOtherSkillsFromAddDomain = true
//                        }
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        showAlert = true
//                    }
//                }
//            }
//        } label: {
//            ZStack {
//                if signUpViewModel.showUpdatingDomainProgress {
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
//        .disabled(signUpViewModel.primaryDomain == .none)
    }
}

struct AddDomainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddDomainView()
                .environmentObject(SignUpViewModel())
        }
    }
}
