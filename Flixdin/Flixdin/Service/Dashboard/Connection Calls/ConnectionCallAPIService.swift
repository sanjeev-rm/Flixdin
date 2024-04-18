//
//  ConnectionCallAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 24/01/24.
//

import Foundation

class ConnectionCallAPIService {
    
    enum ConnectionCallError: Error {
        case custom(message: String)
    }
    
    static let CREATE_CONNECTION_CALL_URL = "https://api.flixdin.com/new-connectionCall"
    static let GET_CONNECTION_CALLS_URL = "https://api.flixdin.com/v2/get-connectionCalls"
    static let LIKE_CONNECTION_CALL_URL = "https://api.flixdin.com/v2/like-connectionCall"
    static let DISLIKE_CONNECTION_CALL_URL = "https://api.flixdin.com/v2/dislike-connectionCall"
    static let APPLY_TO_CONNECTION_CALL_URL = "https://api.flixdin.com/v2/addApplicant-connectionCall"
    static let REMOVE_APPLICANT_OF_CONNECTION_CALL = "https://api.flixdin.com/v2/removeApplicant-connectionCall"
    static let DELETE_CONNECTION_CALL_URL = "https://api.flixdin.com/delete-connectionCall"
    static let GET_USER_CREATED_CONNECTION_CALLS = "https://api.flixdin.com/v2/get-userconnectionCall"
    
    // MARK: - Create Connection Call
    
    struct CreateConnectionCallRequestBody: Codable {
        var postid: String
        var ownerid: String
        var domain: String
        var caption: String
        var applicants: [String]
        var location: String
        var likes: [String]
        var image: String
        var time_of_post: String
    }
    
    final func createConnectionCall(ownerId: String, domain: Domain, description: String, connectionLocation: String, completion: @escaping(Result<String, ConnectionCallAPIService.ConnectionCallError>) -> Void) {
        
        guard let url = URL(string: ConnectionCallAPIService.CREATE_CONNECTION_CALL_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Update Normal User")))
            return
        }
        
        let postId = "connectioncall." + ownerId + "." + Date.now.ISO8601Format(.iso8601)
        
        let body = CreateConnectionCallRequestBody(postid: postId, ownerid: ownerId, domain: domain.title, caption: description, applicants: [], location: connectionLocation, likes: [], image: "", time_of_post: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.custom(message: "Internet Issue - creating connection call")))
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to create new connection call")))
                    return
                }
                
                completion(.success("Created new connection call"))
            }.resume()
        }
    }
    
    // MARK: - Get all connection calls
    
//    struct ConnectionCallbody: Codable {
//        var postid: String
//        var ownerid: String
//        var domain: String
//        var caption: String
//        var applicants: [String]
//        var location: String
//        var likes: [String]
//        var image: String
//        var time_of_post: String
//        var comments: String
//        var fullname: String
//        var profilepic: String
//        var username: String
//    }
    
    final func getAllConnectionCalls(completion: @escaping(Result<[ConnectionCall], ConnectionCallError>) -> Void) {
        
        guard let url = URL(string: ConnectionCallAPIService.GET_CONNECTION_CALLS_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Get connection calls")))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Get User")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to get connection calls")))
                    return
                }
                
                guard let connectionCallsArray = try? JSONDecoder().decode([ConnectionCall].self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get All Connection Calls")))
                    return
                }
                
                completion(.success(connectionCallsArray))
            }.resume()
        }
    }
    
    // MARK: - get user created connection calls
    
    struct GetUserConnectionCallsRequestBody: Codable {
        var userid: String
    }
    
    final func getUserCreatedConnectionCalls(userId: String, completion: @escaping(Result<[ConnectionCall], ConnectionCallError>) -> Void) {
        
        guard let url = URL(string: ConnectionCallAPIService.GET_USER_CREATED_CONNECTION_CALLS) else {
            completion(.failure(.custom(message: "Invalid URL - Get user created connection calls")))
            return
        }
        
        var body = GetUserConnectionCallsRequestBody(userid: userId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Get User created connection calls")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to get user created connection calls")))
                    return
                }
                
                guard let connectionCallsArray = try? JSONDecoder().decode([ConnectionCall].self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get user created Connection Calls")))
                    return
                }
                
                completion(.success(connectionCallsArray))
            }.resume()
        }
    }
    
    // MARK: - Connection call actions
    /*
     * LIKE, DISLIKE, APPLY & REMOVE APPLICANT
     */
    
    enum ConnectionCallAction {
        case like
        case dislike
        case addApplicant
        case removeApplicant
        
        var urlString: String {
            switch self {
            case .like: return ConnectionCallAPIService.LIKE_CONNECTION_CALL_URL
            case .dislike: return ConnectionCallAPIService.DISLIKE_CONNECTION_CALL_URL
            case .addApplicant: return ConnectionCallAPIService.APPLY_TO_CONNECTION_CALL_URL
            case .removeApplicant: return ConnectionCallAPIService.REMOVE_APPLICANT_OF_CONNECTION_CALL
            }
        }
    }
    
    struct ConnectionCallActionRequestBody: Codable {
        var postid: String
        var userid: String
    }
    
    struct ConnectionCallActionResponseBody: Codable {
        var data: [String]
    }
    
    final func connectionCallFunction(postId: String, userId: String, action: ConnectionCallAction, completion: @escaping (Result<ConnectionCallActionResponseBody, ConnectionCallError>) -> Void) {
        
        guard let url = URL(string: action.urlString) else {
            completion(.failure(.custom(message: "Invalid URL - Update Normal User")))
            return
        }
        
        let body = ConnectionCallActionRequestBody(postid: postId, userid: userId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "Internet Issue - update user's non-array info")))
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to create new connection call")))
                    return
                }
                
                guard let updatedLikes = try? JSONDecoder().decode(ConnectionCallActionResponseBody.self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get All Connection Calls")))
                    return
                }
                
                completion(.success(updatedLikes))
            }.resume()
        }
    }
    
    // MARK: - Function to delete a connection call
    
    struct DeleteConnectionCallRequestBody: Codable {
        var postid: String
    }
    
    final func deleteConnectionCall(postId: String, completion: @escaping(Result<String, PostAPIService.PostError>) -> Void) {
        
        guard let url = URL(string: ConnectionCallAPIService.DELETE_CONNECTION_CALL_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Delete connection call")))
            return
        }
        
        let body = DeleteConnectionCallRequestBody(postid: postId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard data != nil, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Delete connection call")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to delete connection call")))
                    return
                }
                
                completion(.success("Connection call successfuly deleted"))
            }.resume()
        }
    }
}
