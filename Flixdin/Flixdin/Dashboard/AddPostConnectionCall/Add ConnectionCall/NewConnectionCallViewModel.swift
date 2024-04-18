//
//  NewConnectionCallViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/08/23.
//

import Foundation
import PhotosUI
import SwiftUI
import MapKit

class NewConnectionCallViewModel: ObservableObject {
    
    @Published var selectedImageItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
    @Published var selectedDomain: Domain = .none
    @Published var connectionLocation: String = ""
    @Published var connectionLocationPlace: Place = Place()
    @Published var description: String = ""
    
    @Published var showLocationSearcher: Bool = false
    
    @Published var showCreatingProgress: Bool = false
    
    @Published var connectionCallPosted: Bool = false
    
    @Published var currentUser: User = User()
    
    // Returns true if all the information needed to create a new connection call is available.
    func isAllAvailable() -> Bool {
        if selectedDomain != .none, !connectionLocation.isEmpty, !description.isEmpty {
            return true
        }
        return false
    }
    
    func createNewConnectionCall(completion: @escaping(Bool) -> Void) {
        showCreatingProgress = true
        
        guard let loggedInUserId = Storage.loggedInUserId else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        ConnectionCallAPIService().createConnectionCall(ownerId: loggedInUserId, domain: selectedDomain, description: description, connectionLocation: connectionLocation) { [unowned self] result in
            DispatchQueue.main.async {
                self.showCreatingProgress = false
            }
            
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.connectionCallPosted = true
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
