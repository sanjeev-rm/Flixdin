//
//  ExploreViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 13/03/24.
//

import Foundation

class ExploreViewModel {
    
    static func searchUser(query: String, completion: @escaping ([User]) -> Void) {
        
        ExploreAPIService.searchUser(query: query) { result in
            switch result {
            case .success(let userResults):
                let users: [User] = userResults.map { userResultBody in
                    User(responseBody: userResultBody)
                }
                completion(users)
            case .failure(let failure):
                switch failure {
                case .custom(let message):
                    print("DEBUG: \(message)")
                }
            }
        }
    }
}
