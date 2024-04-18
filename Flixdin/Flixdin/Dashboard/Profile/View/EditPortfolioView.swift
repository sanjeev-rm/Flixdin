//
//  EditPortfolioView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

struct EditPortfolioView: View {
    
    @ObservedObject var viewModel =  PortfolioViewModel()
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack{
                
                headerPortfolioView
                
                NameView
                
                YourDomainView
                
                YourWorkView
                
                YourFilmographyView
                
                UploadCertificateView
                
                FilmMakingChallengesView
                
                doneButtonView
            }
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))

    }
    
    func validateAndAddURL(urlString: String) {
        if let url = URL(string: urlString) {
            viewModel.work.append(url)
        } else {
            // Invalid URL, show an error or provide feedback to the user
        }
    }
}

extension EditPortfolioView {
    
    private var headerPortfolioView: some View {
        VStack (alignment: .leading){
            Text("Edit Portfolio")
                .frame(alignment: .leading)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.vertical, 10)
            
            Text("The Portfolio showcases your past and present projects.")
                .frame(alignment: .leading)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(flixColor: .olive))
            Divider()
                .foregroundColor(Color(flixColor: .olive))
                .frame(width: width - 30, height: 2)
        }
        .padding(.vertical, 10)
    }
    
    private var NameView: some View {
        Group {
            TextField("Name",text: $viewModel.name)
                .frame(width: width - 30)
                .padding(.horizontal, 10)
            Divider()
                .frame(width: width - 30)
                .padding(10)
        }
    }
    
    private var YourDomainView: some View {
        Group {
            TextField("Your Domain", text: $viewModel.domain)
                .frame(width: width - 30)
                .padding(.horizontal, 10)
            Divider()
                .frame(width: width - 30)
                .padding(10)
        }
    }
    
    private var YourWorkView: some View {
        VStack (alignment: .leading) {
            Text("Your Work")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .padding(10)
            
            ForEach(0...2, id: \.self) { i in
                VStack{
                    TextField("Add Link", text: $viewModel.urlString[i])
                        .frame(width: width - 30)
                        .padding(.horizontal, 10)
                        .onSubmit {
                            validateAndAddURL(urlString: viewModel.urlString[i])
                        }
                    Divider()
                        .frame(width: width - 30)
                        .padding(10)
                    TextField("Add Link Description", text: $viewModel.workDescriptionString[i])
                        .frame(width: width - 30)
                        .padding(.horizontal, 10)
                        .onSubmit {
                            viewModel.workDescription.append(viewModel.workDescriptionString[i])
                        }
                    Divider()
                        .frame(width: width - 30)
                        .padding(10)
                }
            }
        }
    }
    
    private var YourFilmographyView: some View {
        VStack (alignment: .leading) {
            Text("Your Filmography")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .padding(10)
            
            TextField("Your Filmography",text: $viewModel.filmography)
                .frame(width: width - 30)
                .padding(.horizontal, 10)
            Divider()
                .frame(width: width - 30)
                .padding(10)
        }
    }
    
    private var UploadCertificateView: some View {
        VStack (alignment: .leading) {
            Text("Upload Certificate")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .padding(10)
            
            TextField("Your Certificate",text: $viewModel.tempCertificates)
                .frame(width: width - 30)
                .padding(.horizontal, 10)
            Divider()
                .frame(width: width - 30)
                .padding(10)
        }
    }
    
    private var FilmMakingChallengesView: some View {
        VStack (alignment: .leading) {
            Text("Film making Challenges")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .padding(10)
            
            TextField("Add a Brief Description",text: $viewModel.filmMakingChallenges)
                .frame(width: width - 30)
                .padding(.horizontal, 10)
            Divider()
                .frame(width: width - 30)
                .padding(10)
        }
    }
    
    private var doneButtonView: some View {
        ProfileDoneView()
    }
}


struct EditPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        EditPortfolioView()
    }
}
