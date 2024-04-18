//
//  ConnectionCallViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 28/01/24.
//

import Foundation

// MARK: - View Model for the ConnectionCallView

class ConnectionCallViewModel: ObservableObject {
    
    @Published var showNewConnectionCallView: Bool = false
    @Published var connectionCalls: [ConnectionCall] = CONNECTION_CALL_SAMPLES
    @Published var isRefreshing: Bool = false
    
    func getConnectionCalls() {
        isRefreshing = true
        
        ConnectionCallAPIService().getAllConnectionCalls { [unowned self] result in
            DispatchQueue.main.async {
                self.isRefreshing = false
            }
            
            switch result {
            case .success(let newConnectionCalls):
                DispatchQueue.main.async {
                    self.connectionCalls = newConnectionCalls
                }
            case .failure(let failure):
                print("DEBUG: \(failure)")
            }
        }
    }
}

// MARK: - Action functions

extension ConnectionCallViewModel {
    
    static func likeConnectionCall(postId: String, completion: @escaping ([String]) -> Void) {
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ConnectionCallAPIService().connectionCallFunction(postId: postId, userId: loggedInUserId, action: .like) { result in
            switch result {
            case .success(let updatedLikesListData):
                completion(updatedLikesListData.data)
                print("DEBUG: Connection call Liked!")
                print("Updated Liked List : \(updatedLikesListData.data)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    static func dislikeConnectionCall(postId: String, completion: @escaping ([String]) -> Void) {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ConnectionCallAPIService().connectionCallFunction(postId: postId, userId: loggedInUserId, action: .dislike) { result in
            switch result {
            case .success(let updatedLikesListData):
                completion(updatedLikesListData.data)
                print("DEBUG: Connection call Disliked")
                print("Updated Liked List : \(updatedLikesListData.data)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    static func applyToConnectionCall(postId: String, completion: @escaping([String]) -> Void) {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ConnectionCallAPIService().connectionCallFunction(postId: postId, userId: loggedInUserId, action: .addApplicant) { result in
            switch result {
            case .success(let updatedAppliedListData):
                completion(updatedAppliedListData.data)
                print("DEBUG: Connection call Applied!")
                print("Updated Applied List : \(updatedAppliedListData.data)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    static func removeApplicantOfConnectionCall(postId: String, completion: @escaping ([String]) -> Void) {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ConnectionCallAPIService().connectionCallFunction(postId: postId, userId: loggedInUserId, action: .removeApplicant) { result in
            switch result {
            case .success(let updatedAppliedListData):
                completion(updatedAppliedListData.data)
                print("DEBUG: Connection call removed application ")
                print("Updated Applied List : \(updatedAppliedListData.data)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    /// Function to delete a connection call
    static func deleteConnectionCall(postId: String) {
        ConnectionCallAPIService().deleteConnectionCall(postId: postId) { result in
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
            }
        }
    }
    
    static func getConnectionCallsCreatedBy(userId: String, completion: @escaping ([ConnectionCall]) -> Void) {
        ConnectionCallAPIService().getUserCreatedConnectionCalls(userId: userId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let connectionCalls):
                    completion(connectionCalls)
                case .failure(let failure):
                    print("DEBUG: \(failure.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Helping functions

extension ConnectionCallViewModel {
    
    // Function to check whether the current connection call's owner(creator) is the user of this app.
    // If yes then the editing button will be shown at the top of the connection call else not.
    /// Function to check whether the current user is the owner of a connection call
    static func isOwner(ownerId: String) -> Bool {
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return false
        }
        
        if loggedInUserId == ownerId {
            return true
        }
        return false
    }
    
    /// Function to check if current user has applied to a connection call
    static func hasUserAppliedTo(connectionCall: ConnectionCall) -> Bool {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return false
        }
        
        for applicant in connectionCall.applicants {
            if applicant == loggedInUserId {
                return true
            }
        }
        return false
    }
    
    /// Function to check if current user has liked a connection call
    static func hasUserLiked(connectionCall: ConnectionCall) -> Bool {
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return false
        }
        
        for likedUser in connectionCall.likes {
            if likedUser == loggedInUserId {
                return true
            }
        }
        return false
    }
    
    /// Function to check if current user has saved a connection call
    static func hasUserSaved(connectionCall: ConnectionCall) -> Bool {
        
        guard let currentUser = Storage.currentUser else { return false }
        
        for savedCcId in currentUser.savedConnectionCalls {
            if connectionCall.postid == savedCcId {
                return true
            }
        }
        return false
    }
}
