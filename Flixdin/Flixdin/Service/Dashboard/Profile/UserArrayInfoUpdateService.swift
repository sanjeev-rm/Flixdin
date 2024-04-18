//
//  UserArrayInfoUpdate.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation

extension ProfileAPIService {
    
    struct AddOtherSkillsRequestBody: Codable {
        var id: String
        var otherskills: [String]
    }
    
    struct AddFollowerRequestBody: Codable {
        var id: String
        var follower: [String]
    }
    
    struct AddFollowingRequestBody: Codable {
        var id: String
        var following: [String]
    }
    
    struct AddConnectionCallsRequestBody: Codable {
        var id: String
        var connectioncalls: [String]
    }
    
    struct AddSavedConnectionCallsRequestBody: Codable {
        var id: String
        var savedconnectioncalls: [String]
    }
    
    struct AddAppliedConnectionCallsRequestBody: Codable {
        var id: String
        var appliedconnectioncalls: [String]
    }
    
    struct AddSavedPostsRequestBody: Codable {
        var id: String
        var savedposts: [String]
    }
    
    final func addArrayInfoTo(userId: String, infoType: ProfileAPIService.ProfileAddToArrayInfo, newValues: [String], completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        guard let url = URL(string: infoType.urlString) else {
            completion(.failure(.custom(message: "Invalid URL - Add to User's \(infoType.rawValue)")))
            return
        }
        
        let body: Codable
        switch infoType {
        case .otherSkills: body = AddOtherSkillsRequestBody(id: userId, otherskills: newValues)
        case .follower: body = AddFollowerRequestBody(id: userId, follower: newValues)
        case .following: body = AddFollowingRequestBody(id: userId, following: newValues)
        case .connectionCalls: body = AddConnectionCallsRequestBody(id: userId, connectioncalls: newValues)
        case .savedConnectionCalls: body = AddSavedConnectionCallsRequestBody(id: userId, savedconnectioncalls: newValues)
        case .appliedConnectionCalls: body = AddAppliedConnectionCallsRequestBody(id: userId, appliedconnectioncalls: newValues)
        case .savedPosts: body = AddSavedPostsRequestBody(id: userId, savedposts: newValues)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.custom(message: "Internet Issue - Add to User's \(infoType.rawValue)")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to Add to User's \(infoType.rawValue)")))
                    return
                }
                
                completion(.success("Added to User's \(infoType.rawValue)"))
            }.resume()
        }
    }
    
    // MARK: - NO need for these now, maybe in the future
//
//    final func addOtherSkills(userId: String, otherSkills: [Domain], completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
//
//        addArrayInfoTo(userId: userId, infoType: .otherSkills, newValues: otherSkills.map({$0.title}), completion: completion)
//    }
//
//    final func addFollowers(userId: String, followers: [String], completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
//        addArrayInfoTo(userId: userId, infoType: .follower, newValues: followers, completion: completion)
//    }
}
