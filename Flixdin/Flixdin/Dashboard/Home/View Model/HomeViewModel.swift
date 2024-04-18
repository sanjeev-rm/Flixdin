//
//  HomeViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var showNotifications: Bool = false
    @Published var showMessages: Bool = false
    @Published var showAddPostOrConnectionCallOptions: Bool = false
    @Published var showAddPostView: Bool = false
    @Published var showAddConnectionCallView: Bool = false
    
    @Published var showRefreshingFeed: Bool = false
    
    @Published var feedDataArray: [HomeAPIService.DataResponseBody] = []
    
    // MARK: - function to get Feed data (posts and connection calls
    
    func getFeedData() {
        showRefreshingFeed = true
        HomeAPIService.getData { result in
            DispatchQueue.main.async {
                self.showRefreshingFeed = false
                switch result {
                case .success(let dataArray):
                    self.feedDataArray = dataArray
                    print("DEBUG: Got feed data - \(self.feedDataArray.count)")
                case .failure(let failure):
                    print("DEBUG: Unable to get feed data - \(failure.localizedDescription)")
                }
            }
        }
    }
}
