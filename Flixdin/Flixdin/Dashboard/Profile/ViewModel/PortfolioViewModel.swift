//
//  PortfolioViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 06/07/23.
//

import Foundation

class PortfolioViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var domain: String = ""
    @Published var urlString: [String] = ["", "", ""]
    @Published var work: [URL] = []
    @Published var workDescriptionString: [String] = ["", "", ""]
    @Published var certificates: [String] = []
    @Published var workDescription: [String] = []
    @Published var filmography: String = ""
    @Published var filmMakingChallenges: String = ""
    @Published var tempCertificates: String = ""
}
