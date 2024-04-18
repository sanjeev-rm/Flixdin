//
//  PostViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/03/24.
//

import Foundation

class PostViewModel: ObservableObject {
    
    /// Function to check if current user is the owner of a given post
    static func isCurrentUserOwner(postOwnerId: String) -> Bool {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Post - Is current user owner of this post")
            return false
        }
        
        if loggedInUserId == postOwnerId {
            return true
        } else {
            return false
        }
    }
    
    /// Function to delete a post
    static func deletePost(postId: String) {
        PostAPIService().deletePost(postId: postId) { result in
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    /// Function to do a action on post
    static func doActionOnPost(action: PostAPIService.ActionOnPost , postId: String, completion: @escaping (Bool) -> Void) {
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Post - Do action on post")
            return
        }
        
        PostAPIService().actionOnPost(action: action, postId: postId, userId: loggedInUserId) { result in
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
                completion(false)
            }
        }
    }
    
    /// Function to check if current user has liked post
    static func hasUserLiked(post: Post) -> Bool {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Post - Do action on post")
            return false
        }
        
        for likedUser in post.likes {
            if likedUser == loggedInUserId {
                return true
            }
        }
        return false
    }
    
    /// Function to check if current user has liked post
    static func hasUserSaved(post: Post) -> Bool {
        
        guard let currentUser = Storage.currentUser else { return false }
        
        for savedPostId in currentUser.savedposts {
            if post.postid == savedPostId {
                return true
            }
        }
        return false
    }
}
