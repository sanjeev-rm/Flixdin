//
//  AddPostViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 03/03/24.
//

import Foundation
import SwiftUI

class AddPostViewModel: ObservableObject {
    
    @Published var showMediaPicker: Bool = true
    @Published var images: [UIImage]?
    @Published var thumbnail: UIImage?
    
    @Published var caption: String = ""
    @Published var tagPeopleQuery: String = ""
    @Published var location: String = ""
    @Published var locationPlace: Place = Place()
    @Published var showLocationSearcher: Bool = false
    
    @Published var showCreatingProgress: Bool = false
    @Published var postPosted: Bool = false
    
    @Published var currentUser: User = User()
    
    // Returns true if all the information needed to create a new post is available.
    func isAllAvailable() -> Bool {
        if let images = images, !images.isEmpty, !caption.isEmpty, !location.isEmpty {
            return true
        }
        return false
    }
    
    func createNewPost(completion: @escaping (Bool) -> Void) {
        showCreatingProgress = true
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        guard let images = images, !images.isEmpty else { return }
        
        PostAPIService().createPost(ownerId: loggedInUserId, domain: Domain.getDomainFromString(string: currentUser.domain), description: caption, postLocation: location, postImage: images.first) { [unowned self] result in
            DispatchQueue.main.async {
                self.showCreatingProgress = false
            }
            
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.postPosted = true
                    }
                }
                completion(true)
            case .failure(let failure):
                print("DEBUG: \(failure.localizedDescription)")
                completion(false)
            }
        }
    }
}
