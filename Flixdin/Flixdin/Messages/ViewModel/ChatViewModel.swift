//
//  ChatViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 22/05/2024.
//

import FirebaseAuth
import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatList: [ChatResponse] = []
    @Published var searchedUser: [SearchedUserResponse] = []
    
    @Published var searchQuery: String = ""

    func getChats() async {
        let urlPath = URLPath.chatList

        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }

        let requestBody = ChatRequesstBody(userId: loggedInUserId)

        do {
            let response: [ChatResponse] = try await
                NetworkRequest.request(urlPath: urlPath, method: .post, body: NetworkRequest.encodeRequestBody(requestBody))

            DispatchQueue.main.async { [weak self] in
                self?.chatList = response
                print("success getting chat list \(String(describing: self?.chatList))")
            }
        } catch {
            print("error getting chat list \(error.localizedDescription)")
        }
    }
    
    func getSearchedUser() async{
        
        let urlPath = URLPath.userSearch
        
        let requestBody = SearchUserRequest(query: searchQuery)
        
        do{
            let response: [SearchedUserResponse] = try await NetworkRequest.request(urlPath: urlPath, method: .post, body: NetworkRequest.encodeRequestBody(requestBody))
            
            DispatchQueue.main.async { [weak self] in
                
                self?.searchedUser = response
                print("Success searched user: \(String(describing: self?.searchedUser))")
                
            }
        }catch{
            print("error getting searched user \(error)")
        }
        
    }
}
