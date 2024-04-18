//
//  Storage.swift
//  Flixdin
//
//  Created by Sanjeev RM on 25/09/23.
//

import Foundation
import SwiftUI

class Storage {
    
    enum Key: String {
        case isLoggedIn = "isLoggedIn"
        case loggedInUserId = "loggedInUserId"
        case loggedInUser = "loggedUser"
    }
    
    @AppStorage(Key.loggedInUserId.rawValue) static var loggedInUserId: String?
    
    static var currentUser: User?
    
//    @AppStorage(Key.loggedInUser.rawValue) private static var loggedInUser: String?
//    
//    func storeUser(user: User) {
//        let jsonEncoder = JSONEncoder()
//        do {
//            let jsonData = try jsonEncoder.encode(user)
//            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
//            Storage.loggedInUser = jsonString
//            print("DEBUG: Stored user\n\(jsonString ?? "default value")")
//        } catch(let error) {
//            print("DEBUG: Stored user - \(error.localizedDescription)")
//        }
//    }
//    
//    func getStoredUser() -> User? {
//        guard let loggedInUser = Storage.loggedInUser else {
//            print("DEBUG: No user stored")
//            return nil
//        }
//        let jsonDeoder = JSONDecoder()
//        do {
//            let data = loggedInUser.data(using: .utf8)!
//            let storedUser = try jsonDeoder.decode(User.self, from: data)
//            print("DEBUG: User ID - \(storedUser.id)")
//            return storedUser
//        } catch(let error) {
//            print("DEBUG: Stored user - \(error.localizedDescription)")
//        }
//        return nil
//    }
}
