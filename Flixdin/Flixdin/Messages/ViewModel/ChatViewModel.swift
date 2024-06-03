//
//  ChatViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 22/05/2024.
//

import FirebaseAuth
import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: String = UUID().uuidString
    let content: String
    let sender_id: String
    let receiver_id: String
    let created_at: String
    let read: Bool

    init?(data: [String: Any]) {
        guard  
              let content = data["content"] as? String,
              let sender_id = data["sender_id"] as? String,
              let receiver_id = data["receiver_id"] as? String,
              let created_at = data["created_at"] as? String,
              let read = data["read"] as? Bool else {
            return nil
        }
        
        self.content = content
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.created_at = created_at
        self.read = read
    }
}


class ChatViewModel: ObservableObject {
    @Published var chatList: [ChatResponse] = []
    @Published var searchedUser: [SearchedUserResponse] = []
    
    @Published var searchQuery: String = ""
    
    func getSenderId() -> String{
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return ""
        }
        
        return loggedInUserId
    }

    func getChatList() async {
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
    
    //MARK: Paginated Chats
    @Published var messages: [ChatMessage] = []

    func fetchMessages(senderId: String, receiverId: String, page: Int = 1, pageSize: Int = 10) {
        let url = URL(string: "https://api.flixdin.com/chat")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "senderId": senderId,
            "receiverId": receiverId,
            "page": page,
            "pageSize": pageSize
        ] as [String: Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedMessages = try JSONDecoder().decode([ChatMessage].self, from: data)
                let sortedMessages = decodedMessages.sorted { $0.created_at < $1.created_at }
                DispatchQueue.main.async {
                    self.messages.append(contentsOf: sortedMessages)
                    print("success getting paginated and sorted messages")
                }
            } catch {
                print("Error decoding and sorting messages: \(error)")
            }
        }.resume()
    }

}
