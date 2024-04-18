//
//  OtherSkillsView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct OtherSkillsView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    @State var showAlert: Bool = false
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToSaveLoginInfoViewFromOtherSkills) {
                SaveLoginInfoView()
                    .environmentObject(signUpViewModel)
            }
            .sheet(isPresented: $showAlert) {
                AlertSheetView(imageSystemName: "exclamationmark.triangle", alertMessage: signUpViewModel.errorMessage, showAlert: $showAlert)
                    .presentationDetents([.fraction(1/3)])
            }
    }
}



extension OtherSkillsView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleAndSubtitle
            
            VStack {
                Divider()
                
                mainDomainTextAndOtherSkillsPicker
                
                Divider()
            }
            
            addButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and subtitle of the page
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Add Other Skills")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Add skills other than the main domain selected.")
                .font(.system(size: 15))
        }
    }
    
    /// The main domain text and other skills picker
    private var mainDomainTextAndOtherSkillsPicker: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Main Domain")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                Text(signUpViewModel.primaryDomain.title)
                    .font(.system(size: 17))
            }
            
            HStack {
                Text("Skill 1")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                skillDomainPicker(selection: $signUpViewModel.otherSkill1, takenSkills: [signUpViewModel.otherSkill2])
            }
            
            HStack {
                Text("Skill 2")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                skillDomainPicker(selection: $signUpViewModel.otherSkill2, takenSkills: [signUpViewModel.otherSkill1])
            }
        }
    }
    
    /// Function returns a skill picker
    /// - parameter selection: the current skill that is being selected using this picker
    /// - parameter takenSkills: the skills that has been already taken so that it's not included in the options to select from
    func skillDomainPicker(selection : Binding<Domain>, takenSkills: [Domain]) -> some View {
        Picker("Skill", selection: selection) {
            let domains = Domain.allCases.filter { domain in
                if domain == .none ||
                   domain == .productionHouse ||
                   domain == signUpViewModel.primaryDomain ||
                   takenSkills.contains(domain) {
                    return false
                }
                return true
            }
            
            ForEach(domains, id: \.self) { domain in
                Text(domain.title)
            }
        }
        .pickerStyle(.menu)
    }
    
    /// The add button
    private var addButton: some View {
        Button {
            // Navigate to WelcomeView
            // MARK: Send all collected info to backend
            signUpViewModel.addUserOtherSkills { success in
                if success {
                    DispatchQueue.main.async {
                        signUpViewModel.navigateToSaveLoginInfoViewFromOtherSkills = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            }
        } label: {
            ZStack {
                if signUpViewModel.showUpdatingOtherSkillsProgress {
                    ProgressView()
                } else {
                    Text("Add")
                }
            }
            .font(.system(size: 22))
            .foregroundColor(.init(flixColor: .darkOlive))
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(signUpViewModel.primaryDomain == .none)
    }
}

struct OtherSkillsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OtherSkillsView()
                .environmentObject(SignUpViewModel())
        }
    }
}
