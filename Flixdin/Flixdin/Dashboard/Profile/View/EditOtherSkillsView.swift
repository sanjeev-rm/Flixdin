//
//  EditOtherSkillsView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

struct EditOtherSkillsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var selectedButtons: [String] = []
    
    private var domain = Domains()
    
    var body: some View {
        
        baseView
    }
}

extension EditOtherSkillsView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .center, spacing: 32) {
            VStack {
                titleAndSubtitle
                
                VStack {
                    Divider()
                    
                    mainDomainTextAndOtherSkillsPicker
                    
                    Divider()
                }
            }
            
//            doneButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .navigationTitle("Other Skills")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// The title and subtitle of the page
    private var titleAndSubtitle: some View {
        Text("Select skills other than your main domain")
            .font(.footnote)
            .foregroundColor(Color(flixColor: .olive))
    }
    
    /// The main domain text and other skills picker
    private var mainDomainTextAndOtherSkillsPicker: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Main Domain")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                Text(profileViewModel.domain.title)
                    .font(.system(size: 17))
            }
            
            HStack {
                Text("Skill 1")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                skillDomainPicker(selection: $profileViewModel.otherSkill1, takenSkills: [profileViewModel.otherSkill2])
            }
            
            HStack {
                Text("Skill 2")
                    .font(.system(size: 17, weight: .thin))
                Spacer()
                skillDomainPicker(selection: $profileViewModel.otherSkill2, takenSkills: [profileViewModel.otherSkill1])
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
                   domain == profileViewModel.domain ||
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
    
    /// The done button
    private var doneButton: some View {
        Button {
            // Dismiss View
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Done")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct EditOtherSkillsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditOtherSkillsView()
                .environmentObject(ProfileViewModel())
        }
    }
}
