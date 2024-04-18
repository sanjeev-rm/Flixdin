//
//  GetUser.swift
//  Flixdin
//
//  Created by Sanjeev RM on 14/10/23.
//

import Foundation

extension ProfileAPIService {
    
    private struct GetUserRequestBody: Codable {
        var id: String
    }
    
    public struct GetUserResponseBody: Codable {
        var id: String
        var fullname: String
        var username: String
        var mobileno: String
        var mailid: String
        var birthday: String
        var domain: String
        var otherskills: [String]
        var followers: [String]
        var following: [String]
        var connectioncall: [String]
        var savedposts: [String]
        var savedconnectioncalls: [String]
        var appliedconnectioncalls: [String]
        var savedreels: [String]
        var profilepic: String
        var sex: String?
        var bio: String?
    }
    
    final func getUser(userId: String, completion: @escaping(Result<GetUserResponseBody, ProfileAPIService.ProfileError>) -> Void) {
        
        guard let url = URL(string: ProfileAPIService.GET_USER_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Get User")))
            return
        }
        
        let body = GetUserRequestBody(id: userId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Get User")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to get user")))
                    return
                }
                
                guard let getUserResponseBody = try? JSONDecoder().decode(GetUserResponseBody.self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get User")))
                    return
                }
                
                completion(.success(getUserResponseBody))
            }.resume()
        }
    }
}
