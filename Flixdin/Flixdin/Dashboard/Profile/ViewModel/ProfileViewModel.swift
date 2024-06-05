//
//  ProfileViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 06/07/23.
//

import Foundation
import FirebaseAuth
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var name: String = "User"
    @Published var username : String = "username"
    @Published var numberPosts: Int = 0
    @Published var numberFollowers: Int = 0
    @Published var numberFollowing: Int = 0
    @Published var numberFlicks: Int = 0
    @Published var domain: Domain = .none
    @Published var otherSkill1: Domain = .none
    @Published var otherSkill2: Domain = .none
    @Published var gender: Gender = .preferNotToSay
    @Published var description: String = "Description / Bio"
    @Published var profilePicUrl: String = ""
    
    @Published var showActionSheet: Bool = false
    
    @Published var showGettingUserProgress: Bool = false
    
    @Published var showUpdatingUserProfileProgress: Bool = false
    
    @Published var errorMessage: String = "Error"
    
    @Published var profilePic: Image? = nil
    
    @Published var user: User = User()
    
    @Published var userPosts: [Post] = []
    
    // MARK: - Function to logout

    func logout(completion: @escaping(Bool) -> Void) {
        do{
            try AuthenticationManager.shared.logout()
            completion(true)
        }catch{
            print("DEBUG: Error logging out")
            completion(false)
        }
    }
    
    // MARK: - Function to get user profile
    
    func getAndUpdateUserProfileView() {
        showGettingUserProgress = true
        
//        guard let loggedInUserId = Storage.loggedInUserId else {
//            print("Logged In UserId invalid - Updating User")
//            return
//        }
        
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ProfileAPIService().getUser(userId: loggedInUserId) { [unowned self] result in
            DispatchQueue.main.async {
                self.showGettingUserProgress = false
            }
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.name = user.fullname
                    self.username = user.username
                    self.numberPosts = user.savedposts.count
                    self.numberFollowers = user.followers.count
                    self.numberFollowing = user.following.count
                    self.numberFlicks = user.savedreels.count
                    self.domain = user.domain.isEmpty ? .none : Domain.getDomainFromString(string: user.domain)
                    self.otherSkill1 = user.otherskills.count >= 1 ? Domain.getDomainFromString(string: user.otherskills[0]) : .none
                    self.otherSkill2 = user.otherskills.count == 2 ? Domain.getDomainFromString(string: user.otherskills[1]) : .none
                    self.gender = Gender.getGenderFromString(string: user.sex)
                    if let bio = user.bio {
                        self.description = bio
                    }
                    self.profilePicUrl = user.profilepic
                    self.user = User(responseBody: user)
                    Storage.currentUser = User(responseBody: user)
                    
                    // get posts
                    ProfileViewModel.getUserPosts(userId: user.id) { posts in
                        self.userPosts = posts
                    }
                }
//                Storage().storeUser(user: User(responseBody: user))
//                Storage().getStoredUser()
                print("DEBUG: USER ID = \(user.id)")
            case .failure(let error):
                print("DEBUG Profile: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Function to Update User Profile
    
    func updateUserProfileInfo(completion: @escaping (Bool) -> Void) {
        showUpdatingUserProfileProgress = true
        
//        guard let loggedInUserId = Storage.loggedInUserId else {
//            print("Logged In UserId invalid - Updating User")
//            completion(false)
//            return
//        }
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            completion(false)
            return
        }
        
        ProfileAPIService().updateUserProfileInfo(userId: loggedInUserId, username: username, fullname: name, domain: domain, otherSkill1: otherSkill1, otherSkill2: otherSkill2, sex: gender, bio: description) { [unowned self] result in
            DispatchQueue.main.async {
                self.showGettingUserProgress = false
            }
            
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
                errorMessage = failure.localizedDescription
                completion(false)
            }
        }
    }
    
    // MARK: - Function to Update User Profile Pic
    
    func updateProfilePic(uiImage: UIImage, completion: @escaping(Bool) -> Void) {
        
        let profilePic = uiImage.toJpegString(compressionQuality: 1.0)
        
        AuthenticationAPIService().uploadProfilePicture(userImage: profilePic?.toImage()) { [unowned self] result in
         
            switch result {
            case .success(let success):
                print("Image Uploaded Successfully. \(success)")
                DispatchQueue.main.async {
                    self.getAndUpdateUserProfileView()
                }
                completion(true)
            case .failure(_):
                print("Error Occurred While Uploading the profile picture.")
                completion(false)
            }
        }
    }
    
    // MARK: - Function to delete profile pic url
    
    func deleteProfilePicUrl(completion: @escaping (Bool) -> Void) {
//        guard let userId = Storage.loggedInUserId else {
//            completion(false)
//            return
//        }
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            completion(false)
            return
        }
        let newUrl = ""
        ProfileAPIService().updateUserProfilePicUrl(userid: loggedInUserId, newUrl: newUrl) { [unowned self]result in
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                DispatchQueue.main.async {
                    self.getAndUpdateUserProfileView()
                }
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    // MARK: - Function to get users posts
    
    static func getUserPosts(userId: String, completion: @escaping ([Post]) -> Void) {
        PostAPIService().getUsersPosts(userId: userId) { result in
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    completion(posts)
                }
            case .failure(let failure):
                print("DEBUG: \(failure)")
            }
        }
    }
}

// MARK: - Functions for Other User profile view
extension ProfileViewModel {
    
    static func doAction(_ action: ProfileAPIService.ActionOnUser, on onUser: String, completion: @escaping (Bool) -> Void) {
        
//        guard let loggedInUserId = Storage.loggedInUserId else {
//            completion(false)
//            return
//        }
        
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            completion(false)
            return
        }
        
        ProfileAPIService.doActionOn(user: onUser, byUser: loggedInUserId, action: action) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print("DEBUG: \(success)")
                    completion(true)
                case .failure(let failure):
                    switch failure {
                    case .custom(let message):
                        print("DEBUG: \(message)")
                    }
                    completion(false)
                }
            }
        }
    }
}
