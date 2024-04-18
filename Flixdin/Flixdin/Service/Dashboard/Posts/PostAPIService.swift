//
//  PostAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/02/24.
//

import Foundation
import SwiftUI

class PostAPIService {
    
    enum PostError: Error {
        case custom(message: String)
    }
    
    static let CREATE_POST_URL = "https://api.flixdin.com/new-post"
    static let GET_POSTS_URL = "https://api.flixdin.com/get-post"
    static let GET_USER_POSTS_URL = "https://api.flixdin.com/get-user-posts"
    static let DELETE_POST_URL = "https://api.flixdin.com/delete-post"
    static let UPLOAD_POST_IMAGE_URL = "https://api.flixdin.com/upload-image"
    static let UPDATE_POST_URL = "https://api.flixdin.com/update-post"
    static let SAVE_POST_URL = "https://api.flixdin.com/save-post"
    static let LIKE_POST_URL = "https://api.flixdin.com/like-post"
    static let DISLIKE_POST_URL = "https://api.flixdin.com/dislike-post"
    static let GET_DATA_URL = "https://api.flixdin.com/getData"
    
    struct CreatePostRequestBody: Codable {
        var postid: String
        var ownerid: String
        var domain: String
        var caption: String
        var applicants: [String]
        var location: String
        var likes: [String]
        var image: String
    }
    
    // MARK: - Function to create a post
    
    final func createPost(ownerId: String, domain: Domain, description: String, postLocation: String, postImage: UIImage?, completion: @escaping(Result<String, PostAPIService.PostError>) -> Void) {
        
        guard let url = URL(string: PostAPIService.CREATE_POST_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Update Normal User")))
            return
        }
        
        let postId = "post." + ownerId + "." + Date.now.ISO8601Format(.iso8601)
        
        let body = CreatePostRequestBody(postid: postId, ownerid: ownerId, domain: domain.title, caption: description, applicants: [], location: postLocation, likes: [], image: "")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(.failure(.custom(message: "Internet Issue - creating post")))
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to create new post")))
                    return
                }
                
                completion(.success("Created new post"))
                
                self.uploadPostImage(postImage: postImage, postId: postId) { result in
                    switch result {
                    case .success(_):
                        print("DEBUG: Posted image")
                    case .failure(_):
                        print("DEBUG: Error in uploading image")
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - Function to upload image of post
    
    final func uploadPostImage(postImage: UIImage?, postId: String, completion: @escaping (Result<String, PostAPIService.PostError>) -> Void) {
        
        guard let url = URL(string: PostAPIService.UPLOAD_POST_IMAGE_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Upload image of post.")))
            return
        }
        
        guard let postImage = postImage else {
            completion(.failure(.custom(message: "Image Not Found.")))
            return
        }
        
        // Convert the UIImage to Data
        if let imageData = postImage.jpegData(compressionQuality: 1.0) {
            let request = MultipartFormDataRequest(url: url)
            
            // Add "id" as a field with the posts' ID
            request.addTextField(named: "id", value: "\(postId)")
            
            // Add the image data with the appropriate MIME type
            request.addDataField(named: "file", data: imageData, mimeType: "image/jpeg")
            
            DispatchQueue.global(qos: .background).async {
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(.custom(message: "Network Error - Upload Post Image: \(error.localizedDescription)")))
                        return
                    }
                    
                    guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
                        completion(.failure(.custom(message: "Server Error - Post Image")))
                        return
                    }
                    
                    guard let data = data else {
                        completion(.failure(.custom(message: "Data not received - Profile Image")))
                        return
                    }
                    print("DEBUG: Post Image Uploaded Successfully")
                    print("DEBUG: Post Image upload Returned Data - \(data)")
                    completion(.success("Image Uploaded"))
                    
                }.resume()
            }
        } else {
            completion(.failure(.custom(message: "Failed to convert UIImage to Data")))
        }
        
    }
    
    // MARK: - Function to get users posts
    
    struct GetPostsRequestBody: Codable {
        var userid: String
    }
    
    final func getUsersPosts(userId: String, completion: @escaping(Result<[Post], PostAPIService.PostError>) -> Void) {
        
        guard let url = URL(string: PostAPIService.GET_USER_POSTS_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Get users posts")))
            return
        }
        
        let body = GetPostsRequestBody(userid: userId)
        
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
                    completion(.failure(.custom(message: "Unable to get users posts")))
                    return
                }
                
                guard let postsArray = try? JSONDecoder().decode([Post].self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get users posts")))
                    return
                }
                
                completion(.success(postsArray))
            }.resume()
        }
    }
    
    // MARK: - Function to delete a post
    
    struct DeletePostRequestBody: Codable {
        var postid: String
    }
    
    final func deletePost(postId: String, completion: @escaping(Result<String, PostAPIService.PostError>) -> Void) {
        
        guard let url = URL(string: PostAPIService.DELETE_POST_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Delete post")))
            return
        }
        
        let body = DeletePostRequestBody(postid: postId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard data != nil, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Delete post")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to delete post")))
                    return
                }
                
                completion(.success("Post successfuly deleted"))
            }.resume()
        }
    }
    
    // MARK: - Save, Like & Dislike
    
    // MARK: Enum for defining each action on post
    
    enum ActionOnPost: String {
        case save = "Save"
        case like = "Like"
        case dislike = "Disilike"
    }
    
    // MARK: Request body for doing any action on the post, such as like, dislike & save
    
    struct ActionOnPostRequestBody: Codable {
        var postid: String
        var userid: String
    }
    
    // MARK: Function to do a action on post
    
    final func actionOnPost(action: ActionOnPost, postId: String, userId: String, completion: @escaping(Result<String, PostAPIService.PostError>) -> Void) {
        
        var urlString: String
        switch action {
        case .save: urlString = PostAPIService.SAVE_POST_URL
        case .like: urlString = PostAPIService.LIKE_POST_URL
        case .dislike: urlString = PostAPIService.DISLIKE_POST_URL
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.custom(message: "Invalid URL - \(action.rawValue) post")))
            return
        }
        
        let body = ActionOnPostRequestBody(postid: postId, userid: userId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = (action == .save) ? "POST" : "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard data != nil, error == nil else {
                    completion(.failure(.custom(message: "No Internet - \(action.rawValue) post")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to \(action.rawValue) post")))
                    return
                }
                
                completion(.success("Post successfuly \(action.rawValue)" + "d"))
            }.resume()
        }
    }
}
