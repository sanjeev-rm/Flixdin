//
//  PortfolioView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 06/07/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.openURL) var openURL
    
    @Binding var user: User
    @State var portfolio: Portfolio = SAMPLE_PORTFOLIO
    
    var body: some View {
        
        ScrollView (showsIndicators: false) {
            
            VStack (alignment: .leading, spacing: 32) {
                
                portfolioTitle
                
                NameAndDomainView
                
                MyWorkView
                
                MyFilmographyView
                
                CertificateView
                
                FilmMakingChallengesView
            }
            .padding(32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(flixColor: .backgroundSecondary).opacity(0.2))
        }
}

extension PortfolioView {
    
    private var portfolioTitle: some View {
        Text("Portfolio")
            .font(.title.bold())
            .foregroundColor(Color(flixColor: .olive))
    }
    
    private var NameAndDomainView: some View {
        
        VStack (alignment: .leading) {
            Text(portfolio.name)
                .font(.title3.bold())
                .foregroundColor(.primary.opacity(0.7))
            Text(portfolio.domain)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Divider()
        }
    }
    
    private var MyWorkView: some View {

        VStack (alignment: .leading){
            Text("My Work")
                .font(.headline)
                .foregroundColor(Color(flixColor: .olive))
            
            ForEach(portfolio.work, id: \.self) { workUrl in
                HStack {
                    Text("Link:")
                        .foregroundStyle(.secondary)
                    Button {
                        openURL(workUrl)
                    } label: {
                        Text("Click me")
                    }
                }
                .font(.subheadline)
                .padding(.leading)
            }
            Divider()
        }
    }
    
    private var MyFilmographyView: some View {
        
        VStack (alignment: .leading){
            Text("My Filmography")
                .font(.headline)
                .foregroundColor(Color(flixColor: .olive))
            
            Text(portfolio.filmography)
                .foregroundColor(.primary)
            
            Divider()
        }
    }
    
    private var CertificateView: some View {
        VStack(alignment: .leading) {
            Text("My Certificates")
                .font(.headline)
                .foregroundColor(Color(flixColor: .olive))
            
            Divider()
        }
    }
    
    private var FilmMakingChallengesView: some View {
        
        VStack (alignment: .leading){
            Text("Film Making Challenges")
                .font(.headline)
                .foregroundColor(Color(flixColor: .olive))
                .padding(.top, 10)
                .padding(.bottom, 5)
            Text(portfolio.filmMakingChallenges)
                .foregroundColor(.primary)
            
            Divider()
        }
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(user: .constant(User()))
            .environmentObject(ProfileViewModel())
    }
}
