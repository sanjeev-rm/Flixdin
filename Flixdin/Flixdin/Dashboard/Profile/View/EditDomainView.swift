//
//  EditDomainView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

struct EditDomainView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack{
            
            headerDomainView
            
            domainSelectionView
            
//            doneButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .navigationTitle("Domain")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension EditDomainView {
    private var headerDomainView: some View {
        VStack (alignment: .center){
            Text("Domain describes your main profession")
                .frame(alignment: .leading)
                .font(.footnote)
            Divider()
            HStack {
                Text("Selcted")
                    .font(.body.weight(.thin))
                Spacer()
                Text(profileViewModel.domain.title)
                    .font(.body)
            }
            Divider()
        }
        .foregroundColor(Color(flixColor: .olive))
    }
    
    private var domainSelectionView: some View {
        Picker("Domain", selection: $profileViewModel.domain) {
            let domains = Domain.allCases.filter { domain in
                if domain == .none ||
                   domain == profileViewModel.otherSkill1 ||
                   domain == profileViewModel.otherSkill2 ||
                   domain == .productionHouse {
                    return false
                } else {
                    return true
                }
            }
            
            ForEach(domains, id: \.self) { domain in
                Text(domain.title)
            }
        }
        .pickerStyle(.wheel)

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

struct EditDomainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EditDomainView()
                .environmentObject(ProfileViewModel())
        }
    }
}
