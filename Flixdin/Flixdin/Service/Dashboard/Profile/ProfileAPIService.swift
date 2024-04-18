//
//  ProfileAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation

class ProfileAPIService {
    
    enum ProfileError: Error {
        case custom(message: String)
    }
    
    enum ProfileAddToArrayInfo: String {
        case otherSkills = "Other Skills"
        case follower = "Follower"
        case following = "Following"
        case connectionCalls = "Connection Calls"
        case savedConnectionCalls = "Saved Connection Calls"
        case appliedConnectionCalls = "Applied Connection Calls"
        case savedPosts = "Saved Posts"
        
        var urlString: String {
            switch self {
            case .otherSkills: return ProfileAPIService.ADD_USER_OTHER_SKILLS_URL
            case .follower: return ProfileAPIService.ADD_USER_FOLLOWER_URL
            case .following: return ProfileAPIService.ADD_USER_FOLLOWING_URL
            case .connectionCalls: return ProfileAPIService.ADD_USER_CONNECTION_CALLS_URL
            case .savedConnectionCalls: return ProfileAPIService.ADD_USER_SAVED_CONNECTION_CALLS_URL
            case .appliedConnectionCalls: return ProfileAPIService.ADD_USER_APPLIED_CONNECTION_CALLS_URL
            case .savedPosts: return ProfileAPIService.ADD_USER_SAVED_POSTS_URL
            }
        }
    }
    
    enum ProfileRemoveFromArrayInfo {
        case otherSkills
        case follower
        case following
        case connectionCalls
        case savedConnectionCalls
        case appliedConnectionCalls
        case savedPosts
        
        var urlString: String {
            switch self {
            case .otherSkills: return ProfileAPIService.REMOVE_USER_OTHER_SKILLS_URL
            case .follower: return ProfileAPIService.REMOVE_USER_FOLLOWER_URL
            case .following: return ProfileAPIService.REMOVE_USER_FOLLOWING_URL
            case .connectionCalls: return ProfileAPIService.REMOVE_USER_CONNECTION_CALLS_URL
            case .savedConnectionCalls: return ProfileAPIService.REMOVE_USER_SAVED_CONNECTION_CALLS_URL
            case .appliedConnectionCalls: return ProfileAPIService.REMOVE_USER_APPLIED_CONNECTION_CALLS_URL
            case .savedPosts: return ProfileAPIService.REMOVE_USER_SAVED_POSTS_URL
            }
        }
    }
    
    // MARK: - GET USER URL
    
    /// URL(String) used to get usert
    static var GET_USER_URL = "https://api.flixdin.com/get-user"
    
    // MARK: - UPDATE URL
    
    /// URL (String)  used to update normal information of the user
    static var UPDATE_USER_NONARRAY_URL = "https://api.flixdin.com/update-user-normal"
    
    // MARK: - UPDATE Profile URL
    
    /// URL (String)  used to update profile information of the user
    static var UPDATE_USER_PROFILE_URL = "https://api.flixdin.com/update-user-details"
    
    // MARK: - ADD URLs
    
    /// URL (String)  used to add a skill to other skills
    static var ADD_USER_OTHER_SKILLS_URL = "https://api.flixdin.com/add-otherskills"
    
    /// URL (String)  used to add a follower
    static var ADD_USER_FOLLOWER_URL = "https://api.flixdin.com/add-follower"
    
    /// URL (String)  used to add to following
    static var ADD_USER_FOLLOWING_URL = "https://api.flixdin.com/add-following"
    
    /// URL (String)  used to add to connection-calls
    static var ADD_USER_CONNECTION_CALLS_URL = "https://api.flixdin.com/add-connectioncalls"
    
    /// URL (String)  used to add to saved connection-calls
    static var ADD_USER_SAVED_CONNECTION_CALLS_URL = "https://api.flixdin.com/add-savedconnectioncalls"
    
    /// URL (String)  used to add to applied connection-calls
    static var ADD_USER_APPLIED_CONNECTION_CALLS_URL = "https://api.flixdin.com/add-appliedconnectioncalls"
    
    /// URL (String)  used to add to saved posts
    static var ADD_USER_SAVED_POSTS_URL = "https://api.flixdin.com/add-savedposts"
    
    // MARK: - REMOVE URLs
    
    /// URL (String)  used to remove a skill from other skills
    static var REMOVE_USER_OTHER_SKILLS_URL = "https://api.flixdin.com/remove-otherskills"
    
    /// URL (String)  used to remove a follower
    static var REMOVE_USER_FOLLOWER_URL = "https://api.flixdin.com/remove-follower"
    
    /// URL (String)  used to remove from following
    static var REMOVE_USER_FOLLOWING_URL = "https://api.flixdin.com/remove-following"
    
    /// URL (String)  used to remove from connection-calls
    static var REMOVE_USER_CONNECTION_CALLS_URL = "https://api.flixdin.com/remove-connectioncalls"
    
    /// URL (String)  used to remove from saved connection-calls
    static var REMOVE_USER_SAVED_CONNECTION_CALLS_URL = "https://api.flixdin.com/remove-savedconnectioncalls"
    
    /// URL (String)  used to remove from applied connection-calls
    static var REMOVE_USER_APPLIED_CONNECTION_CALLS_URL = "https://api.flixdin.com/remove-appliedconnectioncalls"
    
    /// URL (String)  used to remove from saved posts
    static var REMOVE_USER_SAVED_POSTS_URL = "https://api.flixdin.com/remove-savedposts"
}
