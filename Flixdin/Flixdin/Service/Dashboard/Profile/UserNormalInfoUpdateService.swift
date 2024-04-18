//
//  UserNormalInfoUpdateService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation

extension ProfileAPIService {
    
    private struct UpdateUserNormalInfoRequestBody: Codable {
        var id: String
        var field: String
        var data: String
    }
    
    /// Function to update normal info of user
    /// - Parameter userId: The id of the user that is being updated
    /// - Parameter field: The field name that is being updated
    /// - Parameter value: The new value that is being given to the field
    private final func updateUserNonArrayInfo(userId: String, field: String, value: String, completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        guard let url = URL(string: ProfileAPIService.UPDATE_USER_NONARRAY_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Update Normal User")))
            return
        }
        
        let body = UpdateUserNormalInfoRequestBody(id: userId, field: field, data: value)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.custom(message: "Internet Issue - update user's non-array info")))
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to update user's \(field)")))
                    return
                }
                
                completion(.success("Updated User's \(field)"))
            }.resume()
        }
    }
    
    /// Function to update user's full-name
    final func updateUserFullName(userId: String, newFullName: String, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userId, field: "fullname", value: newFullName, completion: completion)
    }
    
    /// Function to update user's username
    final func updateUserUsername(userId: String, newUsername: String, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userId, field: "username", value: newUsername, completion: completion)
    }
    
    /// Function to update user's birthday
    final func updateUserBirthday(userId: String, birthdate: Date, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userId, field: "birthday", value: birthdate.formatted(date: .numeric, time: .omitted), completion: completion)
    }
    
    /// Function to update user's domain
    final func updateUserDomain(userId: String, newDomain: Domain, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userId, field: "domain", value: newDomain.title, completion: completion)
    }
    
    /// Function to update user's gender
    final func updateUserGender(userid: String, newGender: Gender, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userid, field: "sex", value: newGender.rawValue, completion: completion)
    }
    
    /// Function to update user's bio
    final func updateUserBio(userid: String, newBio: String, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userid, field: "bio", value: newBio, completion: completion)
    }
    
    /// Function to update user's profile pic url
    final func updateUserProfilePicUrl(userid: String, newUrl: String, completion: @escaping (Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        updateUserNonArrayInfo(userId: userid, field: "profilepic", value: newUrl, completion: completion)
    }
}
