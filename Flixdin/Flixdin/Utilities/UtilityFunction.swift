//
//  UtilityFunction.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation
import SwiftUI

class UtilityFunction {
    
    // MARK: - Function to get image from an URL
    
    final func getImageFromURL(urlString: String?) -> Image {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.fill")
        }
    }
    
    // MARK: - Function to get the current loggedIn user
    
    static func getCurrentUser(completion: @escaping (User?) -> Void) {
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ProfileAPIService().getUser(userId: loggedInUserId) { result in
            switch result {
            case .success(let user):
                Storage.currentUser = User(responseBody: user)
                completion(User(responseBody: user))
            case .failure(let failure):
                print("DEBUG: Unable to get current user (getVurrentUser() in ProfileViewModel)\n\(failure.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    // MARK: - Function to get Post from data
    
    static func getPostFrom(data: HomeAPIService.DataResponseBody) -> Post {
        return Post(postid: data.postid, ownerid: data.ownerid, domain: data.domain, caption: data.caption, applicants: data.applicants, location: data.location, likes: data.likes, image: data.image, time_of_post: data.time_of_post)
    }
    
    // MARK: - Function to get Connection Call from data
    
    static func getConnectionCallFrom(data: HomeAPIService.DataResponseBody) -> ConnectionCall {
        return ConnectionCall(postid: data.postid, ownerid: data.ownerid, domain: data.domain, caption: data.caption, applicants: data.applicants, location: data.location, likes: data.likes, image: data.image, time_of_post: data.time_of_post, comments: "", fullname: "", profilepic: data.profilepic, username: "")
    }
}
