//
//  ActionOnOtherUserService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 10/03/24.
//

import Foundation

extension ProfileAPIService {
    
    static var FOLLOW_USER_URL = "https://api.flixdin.com/follow"
    static var UNFOLLOW_USER_URL = "https://api.flixdin.com/unfollow"
    
    struct ActionOnRequestBody: Codable {
        var currentUser: String
        var otherUser: String
    }
    
    enum ActionOnUser: String {
        case follow = "Follow"
        case unfollow = "Unfollow"
        
        var urlString: String {
            switch self {
            case .follow: return ProfileAPIService.FOLLOW_USER_URL
            case .unfollow: return ProfileAPIService.UNFOLLOW_USER_URL
            }
        }
    }
    
    static func doActionOn(user: String, byUser: String, action: ActionOnUser, completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        guard let url = URL(string: action.urlString) else {
            completion(.failure(.custom(message: "Invalid URL - \(action.rawValue) user")))
            return
        }
        
        let body = ActionOnRequestBody(currentUser: byUser, otherUser: user)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard data != nil, error == nil else {
                    completion(.failure(.custom(message: "No Internet - \(action.rawValue) user")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to \(action.rawValue) user")))
                    return
                }
                
                completion(.success("User successfuly \(action.rawValue)" + "ed"))
            }.resume()
        }
    }
}
