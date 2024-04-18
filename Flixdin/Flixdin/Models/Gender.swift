//
//  Gender.swift
//  Flixdin
//
//  Created by Sanjeev RM on 27/10/23.
//

import Foundation

enum Gender: String, CaseIterable {
    
    case male = "Male"
    case female = "Female"
    case other = "Other"
    case preferNotToSay = "Prefer Not To Say"
    
    static func getGenderFromString(string: String?) -> Gender {
        for gender in Gender.allCases {
            if let genderString = string,
               genderString == gender.rawValue {
                return gender
            }
        }
        
        print("Invalid String")
        return .preferNotToSay
    }
}
