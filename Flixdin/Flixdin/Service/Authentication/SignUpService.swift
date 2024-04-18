//
//  SignUpService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation
import SwiftUI

extension AuthenticationAPIService {
    
    private struct CreateUserRequestBody: Codable {
        var id: String
        var fullname: String
        var username: String
        var mobileNo: String
        var mailID: String
        var birthday: String
        var domain: String = ""
        var otherskills: [String] = []
        var followers: [String] = []
        var following: [String] = []
        var connectioncall: [String] = []
        var savedposts: [String] = []
        var savedconnectioncalls: [String] = []
        var appliedconnectioncalls: [String] = []
        var savedReels: [String] = []
        var profilePic: String = ""
    }
    
    /// Create User function in Backend
    /// - Parameter user: The User with all the details that needs to be created
    /// - Parameter completion: Operation to be done after calling the create user function, either in the case of success or failure
    final func createUser(user: User, completion: @escaping (Result<String, AuthenticationAPIService.AuthError>) -> Void) {
        
        guard let url = URL(string: CREATE_USER_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Create User")))
            return
        }
        
        let body = CreateUserRequestBody(id: user.id, fullname: user.fullName, username: user.username, mobileNo: user.mobileNo, mailID: user.mailID, birthday: user.birthday)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.custom(message: "No Internet - Create User")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    guard let httpUrlResponse = response as? HTTPURLResponse else {
                        completion(.failure(.custom(message: "Unidentified Error - Create User")))
                        return
                    }
                    switch httpUrlResponse.statusCode {
                    case 400: completion(.failure(.userAlreadyExists))
                    default: completion(.failure(.custom(message: "Unidentified Error - Create User")))
                    }
                    return
                }
                
                completion(.success("Created User"))
            }.resume()
        }
    }
    
    /// Upload the User Profile Picture in the background.
    /// - Parameter image: The UIImage of the user.
    /// - Parameter completion: Operation to be done after calling the uploadProfilePicture function, either in teh case of success or failure.
    final func uploadProfilePicture(userImage: UIImage?, completion: @escaping (Result<String, AuthenticationAPIService.AuthError>) -> Void) {
        guard let url = URL(string: POST_USER_PROFILE_PIC) else {
            completion(.failure(.custom(message: "Invalid URL - Upload Profile Picture.")))
            return
        }
        
        guard let userImage = userImage else {
            completion(.failure(.custom(message: "Image Not Found.")))
            return
        }
        
        // Convert the UIImage to Data
        if let imageData = userImage.jpegData(compressionQuality: 1.0) {
            let request = MultipartFormDataRequest(url: url)
            
            // Add "id" as a field with the user's ID
            if let userId = Storage.loggedInUserId {
                request.addTextField(named: "id", value: "\(userId)")
            } else {
                completion(.failure(.custom(message: "Unable to get user ID - Upload Profile Pic")))
                return
            }
            
            // Add the image data with the appropriate MIME type
            request.addDataField(named: "file", data: imageData, mimeType: "image/jpeg")
            
            DispatchQueue.global(qos: .background).async {
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(.custom(message: "Network Error - Upload Profile Picture: \(error.localizedDescription)")))
                        return
                    }
                    
                    guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                        completion(.failure(.custom(message: "Server Error - Profile Picture")))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.custom(message: "Data not received - Profile Picture")))
                        return
                    }
                    print("Image Uploaded Successfully")
                    print("Returned Data - \(data)")
                    completion(.success("Image Uploaded"))
                    
                }.resume()
            }
        } else {
            completion(.failure(.custom(message: "Failed to convert UIImage to Data")))
        }
    }
}
