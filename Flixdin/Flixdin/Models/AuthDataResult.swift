//
//  AuthDataResult.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 17/09/23.
//

import Foundation
import Firebase

struct AuthDataResult {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}
