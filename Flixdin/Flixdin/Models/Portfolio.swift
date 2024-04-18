//
//  Portfolio.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import Foundation

struct Portfolio {
    var name: String
    var domain: String
    var urlString: [String]
    var work: [URL]
    var workDescriptionString: [String]
    var certificates: [String]
    var workDescription: [String]
    var filmography: String
    var filmMakingChallenges: String
    var tempCertificates: String
}

let SAMPLE_PORTFOLIO = Portfolio(name: "Username", domain: "Domain", urlString: ["", "", ""], work: [], workDescriptionString: ["", "", ""], certificates: [], workDescription: [], filmography: "", filmMakingChallenges: "", tempCertificates: "")
