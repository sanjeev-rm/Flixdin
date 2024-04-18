//
//  UserProfileUpdateService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 27/10/23.
//

import Foundation

extension ProfileAPIService {
    
    private struct UpdateUserProfileRequestBody: Codable {
        var id: String
        var username: String
        var fullname: String
        var domain: String
        var otherskills: String
        var sex: String
        var bio: String
    }
    
    /// Function to update profile of the user
    /// - Parameter userProfileUpdateRequestBody: is the model that is sent as JSON to the server to update the user profile
    final func updateUserProfileInfo(userId: String, username: String, fullname: String, domain: Domain, otherSkill1: Domain, otherSkill2: Domain, sex: Gender, bio: String, completion: @escaping(Result<String, ProfileAPIService.ProfileError>) -> Void) {
        
        print("DEBUG: CALLED")
        
        guard let url = URL(string: ProfileAPIService.UPDATE_USER_PROFILE_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Update User Profile")))
            return
        }
        
        let body = UpdateUserProfileRequestBody(id: userId, username: username, fullname: fullname, domain: domain.title, otherskills: "{\(otherSkill1.title), \(otherSkill2.title)}", sex: sex.rawValue, bio: bio)
        
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
                    completion(.failure(.custom(message: "Unable to update user's profile")))
                    return
                }
                
                completion(.success("Updated User's profile"))
            }.resume()
        }
    }
}
