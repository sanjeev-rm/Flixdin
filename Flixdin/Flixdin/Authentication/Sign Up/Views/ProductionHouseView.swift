//
//  ProductionHouseView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import SwiftUI

struct ProductionHouseView: View {
    
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    var body: some View {
        baseView
            .navigationDestination(isPresented: $signUpViewModel.navigateToSaveLoginInfoViewFromProductionHouse) {
                SaveLoginInfoView()
                    .environmentObject(signUpViewModel)
            }
    }
}



extension ProductionHouseView {
    
    /// The base view
    private var baseView: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            titleAndSubtitle
            
            nextButton
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
    
    /// The title and subtitle
    private var titleAndSubtitle: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Production House Info")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Text("Tell us about your production house")
                .font(.system(size: 15))
        }
    }
    
    /// The next button
    private var nextButton: some View {
        Button {
            // Navigate to OtherSkillsView
            signUpViewModel.navigateToSaveLoginInfoViewFromProductionHouse = true
        } label: {
            Text("Next")
                .font(.system(size: 22))
                .foregroundColor(.init(flixColor: .darkOlive))
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ProductionHouseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProductionHouseView()
                .environmentObject(SignUpViewModel())
        }
    }
}
