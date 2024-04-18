//
//  ExploreAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 13/03/24.
//

import Foundation

class ExploreAPIService {
    
    static var SEARCH_USER_URL = "https://api.flixdin.com/user-search"
    
    enum ExploreError: Error {
        case custom(message: String)
    }
    
    struct SearchUserRequestBody: Codable {
        var query: String
    }
    
    static func searchUser(query: String, completion: @escaping(Result<[ProfileAPIService.GetUserResponseBody], ExploreAPIService.ExploreError>) -> Void) {
        
        guard let url = URL(string: ExploreAPIService.SEARCH_USER_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Get search user result")))
            return
        }
        
        let body = SearchUserRequestBody(query: query)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Get search user results")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to get search user results")))
                    return
                }
                
                guard let getSearchUserResultsResponseBody = try? JSONDecoder().decode([ProfileAPIService.GetUserResponseBody].self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get search user results")))
                    return
                }
                
                completion(.success(getSearchUserResultsResponseBody))
            }.resume()
        }
    }
}
